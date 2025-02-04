class PaySubscriptionSendModel {
  String invoiceId;
  bool isCash;

  PaySubscriptionSendModel(
    this.invoiceId,
    this.isCash,
  );

  toMap() {
    return {
      "Invoice_ID": invoiceId,
      "IS_Cash": isCash,
    };
  }
}
