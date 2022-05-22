import 'dart:developer';

import 'package:stripe_intent_data/stripe_intent_data.dart';

void main() async {
  String stripeSecretKey =
      'sk_test_51I';

  var data = await StripeIntentData(
    currency: 'EUR',
    stripeSecretKey: stripeSecretKey,
  ).getStripeIntent('name', 'email ID', 'amount', 'customer ID if available otherwise null');

  log(data.paymentIntentId.toString());
}
