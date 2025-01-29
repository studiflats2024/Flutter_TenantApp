class ActivityModel {
  String name;
  String image;
  String rate;
  String startDate;
  String endDate;
  String reviews;
  int seats;
  String? time;
  ActivitiesType activitiesStatus;

  ActivityModel({
    required this.name,
    required this.image,
    required this.rate,
    required this.startDate,
    required this.endDate,
    required this.reviews,
    required this.seats,
    this.time,
    required this.activitiesStatus,
  });
}

enum ActivitiesType {
  all("All"),
  course("Courses"),
  workshop("Workshops"),
  event("Events"),
  consultant("Consultant");

  final String code;

  const ActivitiesType(this.code);

  static ActivitiesType? fromValue(String value) {
    return ActivitiesType.values.firstWhere(
      (s) => s.code == value,
      orElse: () => ActivitiesType.all,
    );
  }
}
