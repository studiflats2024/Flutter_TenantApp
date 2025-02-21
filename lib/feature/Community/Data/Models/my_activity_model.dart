import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Models/consult_subscription.dart';


class MyActivityModel {
  String id;
  String image;
  String name;
  ActivitiesType activitiesType;
  String? day;
  String date;
  num rate;
  bool? hasRated;
  List<ConsultSubscription> ? consultSubscription;

  MyActivityModel({
    required this.id,
    required this.image,
    required this.name,
    required this.activitiesType,
    required this.date,
    required this.rate,
    this.consultSubscription,
    this.hasRated,
    this.day,
  });
}
