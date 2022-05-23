import 'dart:developer';

import 'package:example/stripe_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_intent_data/response/intent_data.dart';
import 'package:stripe_intent_data/stripe_intent_data.dart';
import 'package:url_launcher/url_launcher.dart';

main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKeyTest; //your publishable key here
  Stripe.merchantIdentifier = '';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  IntentData? paymentIntentData;
  String? customerID;
  String? receiptURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () async{checkOut();},
          color: Colors.blue,
          child: const Text(
            "Pay Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkOut() async {

    ///todo store the customer ID in your database
    ///initially it will be null the Strip will create customer ID and you will get it with
    ///intentData object
    ///when you will get that save to your database
    ///and when it is required call it

    paymentIntentData = await StripeIntentData(
      stripeSecretKey: stripeSecretKey,
      currency: 'EUR',
    ).getStripeIntent('User One', 'userone@user.com', '2000', customerID);

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        applePay: true,
        googlePay: true,
        style: ThemeMode.dark,
        testEnv: true,
        merchantCountryCode: 'GB',
        merchantDisplayName: 'My Merchandise',
        paymentIntentClientSecret: paymentIntentData!.paymentIntentClientSecret,
        customerEphemeralKeySecret: paymentIntentData!.ephemeralKey,
        customerId: paymentIntentData!.customer,
      ),
    );

    await displayPaymentSheet();
    Uri _url = Uri.parse(receiptURL!);
    await launchUrl(_url,mode: LaunchMode.inAppWebView);
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) async {
        ///get charge details
        ///
        ///
        var data = await StripeIntentData(
            stripeSecretKey: stripeSecretKey, currency: 'EUR')
            .getPaymentDetails(
          paymentIntentData!.paymentIntentId!,
        );
        setState(() {
          receiptURL = data.receiptUrl;
          //todo saving the customer ID here but in your case save it to your database
          customerID = paymentIntentData!.customer;
        });
      });
    } on StripeException catch (e) {
      log(e.error.message.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}
