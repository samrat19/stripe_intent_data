[![build status](https://img.shields.io/travis/flutterchina/dio/vm.svg?style=flat-square)](https://travis-ci.org/flutterchina/dio)

# stripe_intent_data

A new Flutter package to reduce the effort to write stripe codes for making intent 
and get data from the API Like:

* Create Customer ID
* Get payment Intent Data
* Get Charge Details

## Getting Started

**Create an Intent**
```dart
  String stripeSecretKey =
      'sk_test_51I';

  var data = await StripeIntentData(
    currency: 'EUR',
    stripeSecretKey: stripeSecretKey,
  ).getStripeIntent('name', 'email ID', 'amount', 'customer ID if available otherwise null');
```

**Get Charge Details**
```dart
  String stripeSecretKey =
      'sk_test_51I';

  var data = await StripeIntentData(
    currency: 'EUR',
    stripeSecretKey: stripeSecretKey,
  ).getPaymentDetails(paymentIntentID);
```

## Example to understand the uses cases 

<img src = "https://github.com/samrat19/stripe_intent_data/blob/master/example/Screenshot_20220523_161852.png" width = 200> <img src = "https://github.com/samrat19/stripe_intent_data/blob/master/example/Screenshot_20220523_161924.png" width = 200>  <img src = "https://github.com/samrat19/stripe_intent_data/blob/master/example/Screenshot_20220523_162038.png" width = 200> <img src = "https://github.com/samrat19/stripe_intent_data/blob/master/example/Screenshot_20220523_162232.png" width = 200>  


