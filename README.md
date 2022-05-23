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

<img src = "https://user-images.githubusercontent.com/30453784/169808199-8c12fdbe-c6ee-4cd6-be8a-71fbcf62cb1b.png" width = 200>    <img src = "https://user-images.githubusercontent.com/30453784/169808205-25fd5a08-54a9-44e1-bbd5-4676d3d01164.png" width = 200>   <img src = "https://user-images.githubusercontent.com/30453784/169808208-3c6f9e62-e22e-4cda-963c-0f6379e8c984.png" width = 200>  


