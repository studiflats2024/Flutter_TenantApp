
enum SubscriptionStatus {
  active("Active", "Active"),
  expired("Expired", "Expired"),
  cancelled("Cancelled", "Canelled"),
  waitingPayment("WaitingPayment", "WaitingPayment");

  final String code;
  final String filter;

  const SubscriptionStatus(
      this.code,
      this.filter,
      );

  static SubscriptionStatus? fromValue(String value) {
    return SubscriptionStatus.values.firstWhere(
          (s) => s.code == value,
      orElse: () => SubscriptionStatus.waitingPayment,
    );
  }
}