class IntentData {
  String? paymentIntentClientSecret;
  String? customer;
  String? ephemeralKey;
  String? paymentIntentId;

  IntentData(
    this.paymentIntentClientSecret,
    this.customer,
    this.ephemeralKey,
    this.paymentIntentId,
  );

  IntentData.fromJSON(Map<String, String> json) {
    paymentIntentClientSecret = json['payment_intent_client_secret'];
    customer = json['customer'];
    ephemeralKey = json['ephemeral_key'];
    paymentIntentId = json['payment_intent_id'];
  }
}
