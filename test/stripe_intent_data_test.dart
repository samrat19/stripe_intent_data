import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';

import 'package:stripe_intent_data/stripe_intent_data.dart';

void main() {
  String stripeSecretKey = 'sk_test_51IVOCEDsldlDrGbdxAd4UY8SwuWT9efngApyMZVza7qkD3byJty6UUt8aYdUsyDoXvlvM40DK6ifQVR77Hl3oIqB00Sjy3lCis';
  test('test my function', () async {
    var data = await StripeIntentData(
      currency: 'EUR',
      stripeSecretKey: stripeSecretKey,
    ).getStripeIntent('Disha Demo', 'disha2@demo.com', '2000', null);
    log(data.toString());
  });
}
