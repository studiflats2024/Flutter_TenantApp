import 'package:vivas/feature/Community/Data/Models/activity_model.dart';

enum ActivityStatus { started, cancelled, rescheduled }

class MyActivityModel {
  String image;
  String name;
  ActivitiesType activitiesType;
  ActivityStatus status;
  String? day;
  String date;
  String endDate;
  String time;
  num rate;

  MyActivityModel({
    required this.image,
    required this.name,
    required this.activitiesType,
    required this.status,
    required this.date,
    required this.endDate,
    required this.time,
    required this.rate,
    this.day,
  });
}
