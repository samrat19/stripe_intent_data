library stripe_intent_data;

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'response/charge_data.dart';
import 'response/intent_data.dart';

class StripeIntentData {
  final String stripeSecretKey;
  final String currency;

  StripeIntentData({required this.stripeSecretKey, required this.currency});

  Map<String, String> header() {
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $stripeSecretKey'
    };
  }

  Future<IntentData> getStripeIntent(
    String name,
    String emailID,
    String amount,
    String? customerID,
  ) async {
    String? _customerID;

    ///if customer ID is available then verify it
    if (customerID != null) {
      var searchResult = await _searchCustomer(customerID);
      if (searchResult) {
        _customerID = customerID;
      } else {
        _customerID = await _createCustomer(name, emailID);
      }
    } else {
      _customerID = await _createCustomer(name, emailID);
    }

    var ephemeralKey = await _getEphemeralKey(_customerID);
    var intentResp = await _createStripePaymentIntent(amount, _customerID);

    Map<String, String> setupIntent = {
      'payment_intent_client_secret': intentResp['client_secret'],
      'customer': _customerID,
      'ephemeral_key': ephemeralKey,
      'payment_intent_id': intentResp['id']
    };

    return IntentData.fromJSON(setupIntent);
  }

  Future<String> _getEphemeralKey(String customerID) async {
    var ephemeralKeyResponse = await http.post(
      Uri.parse(
          'https://api.stripe.com/v1/ephemeral_keys?customer=$customerID'),
      headers: {...header(), 'Stripe-Version': '2020-08-27'},
    );
    return json.decode(ephemeralKeyResponse.body)['secret'];
  }

  Future<String> _createCustomer(String name, String emailID) async {
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      headers: header(),
      body: {
        'name': name,
        'email': emailID,
      },
    );

    var resp = json.decode(response.body) as Map<String, dynamic>;
    return resp['id'];
  }

  Future<Map<String, dynamic>> _createStripePaymentIntent(
      String amount, String customerID) async {
    var intentResponse = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: header(),
      body: {
        'amount': amount,
        'currency': currency,
        'customer': customerID,
      },
    );

    Map<String, dynamic> intentResp = json.decode(intentResponse.body);

    return intentResp;
  }

  Future<ChargeData> getPaymentDetails(String paymentIntentID) async {
    var response = await http.post(
        Uri.parse(
            'https://api.stripe.com/v1/payment_intents/$paymentIntentID/confirm'),
        headers: header(),
        body: {'payment_method': 'pm_card_visa'});
    Map<String, dynamic> data = json.decode(response.body);
    return ChargeData.fromJson(
        data['error']['payment_intent']['charges']['data'][0]);
  }

  Future<bool> _searchCustomer(String customerID) async {
    var response = await http.get(
      Uri.parse('https://api.stripe.com/v1/customers/$customerID'),
      headers: header(),
    );
    return response.statusCode.toString().startsWith('2');
  }
}
