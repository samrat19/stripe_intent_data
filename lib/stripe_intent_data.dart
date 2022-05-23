library stripe_intent_data;

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'response/charge_data.dart';
import 'response/intent_data.dart';

class StripeIntentData {
  final String stripeSecretKey;
  final String currency;

  StripeIntentData({required this.stripeSecretKey, required this.currency});


  ///generates the header with the Stripe secret Key
  ///
  ///
  ///
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
        ///if customer ID iv valid then go with that
        _customerID = customerID;
      } else {
        ///if the customer ID is not valid then create one
        _customerID = await _createCustomer(name, emailID);
      }
    } else {
      ///if customer ID is null then create a customer ID
      _customerID = await _createCustomer(name, emailID);
    }



    ///get the ephemeral Key of the customer
    ///it is a temporary key for the customer which stripe provides
    ///
    ///
    var ephemeralKey = await _getEphemeralKey(_customerID);

    ///gets the payment intent response of the customer regarding this amount
    ///
    var intentResp = await _createStripePaymentIntent(amount, _customerID);

    ///generating an Map object with response to be returned
    ///
    ///
    Map<String, String> setupIntent = {
      'payment_intent_client_secret': intentResp['client_secret'],
      'customer': _customerID,
      'ephemeral_key': ephemeralKey,
      'payment_intent_id': intentResp['id']
    };

    ///returns the response in a form of IntentData object
    ///
    ///
    return IntentData.fromJSON(setupIntent);
  }

  ///private function to get the ephemeral Keu
  ///
  ///
  ///
  Future<String> _getEphemeralKey(String customerID) async {
    var ephemeralKeyResponse = await http.post(
      Uri.parse(
          'https://api.stripe.com/v1/ephemeral_keys?customer=$customerID'),
      headers: {...header(), 'Stripe-Version': '2020-08-27'},
    );
    return json.decode(ephemeralKeyResponse.body)['secret'];
  }

  ///private function to create a customer
  ///
  ///
  ///
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


  ///private function to create the stripe payment intent
  ///
  ///
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

  ///get the payment details of the last payment intent
  ///
  /// if will be called after a successful payment
  ///
  ///
  /// if returns the charge ID, receipt URL in form of Charge Data object
  ///
  ///
  ///
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


  ///search a customer with the customerID provided
  ///
  ///
  Future<bool> _searchCustomer(String customerID) async {
    var response = await http.get(
      Uri.parse('https://api.stripe.com/v1/customers/$customerID'),
      headers: header(),
    );
    return response.statusCode.toString().startsWith('2');
  }
}
