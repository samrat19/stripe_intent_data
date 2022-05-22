class ChargeData {
  String? id;
  int? amount;
  String? balanceTransaction;
  bool? paid;
  String? paymentIntent;
  String? paymentMethod;
  String? receiptEmail;
  String? receiptUrl;

  ChargeData(
      {this.id,
        this.amount,
        this.balanceTransaction,
        this.paid,
        this.paymentIntent,
        this.paymentMethod,
        this.receiptEmail,
        this.receiptUrl});

  ChargeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    balanceTransaction = json['balance_transaction'];
    paid = json['paid'];
    paymentIntent = json['payment_intent'];
    paymentMethod = json['payment_method'];
    receiptEmail = json['receipt_email'];
    receiptUrl = json['receipt_url'];
  }
}