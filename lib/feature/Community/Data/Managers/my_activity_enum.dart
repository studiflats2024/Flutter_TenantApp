enum MyActivityStatus {
  ongoing("OnGoing", "Ongoing"),
  completed("Completed", "Completed"),
  cancelled("Cancelled", "Cancelled");

  final String name;
  final String filter;

  const MyActivityStatus(this.name, this.filter);

  static MyActivityStatus? fromValue(String value) {
    return MyActivityStatus.values.firstWhere(
      (s) => s.name == value || s.filter == value,
      orElse: () => MyActivityStatus.ongoing,
    );
  }
}
