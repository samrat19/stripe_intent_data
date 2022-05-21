import 'dart:developer';

import 'package:stripe_intent_data/stripe_intent_data.dart';

void main() async {
  String stripeSecretKey =
      'sk_test_51IVOCEDsldlDrGbdxAd4UY8VR77Hl3oIqB00Sjy3lCis';

  var data = await StripeIntentData(
    currency: 'EUR',
    stripeSecretKey: stripeSecretKey,
  ).getStripeIntent('Disha Demo', 'disha2@demo.com', '2000', null);

  log(data.toString());
}
