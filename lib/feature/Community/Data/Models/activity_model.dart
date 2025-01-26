class ActivityModel {
  String name;
  String image;
  String rate;
  String startDate;
  String endDate;
  String reviews;
  int seats;
  String? time;
  ActivitiesStatus activitiesStatus;

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

enum ActivitiesStatus { course, workshop, event, consultant }
