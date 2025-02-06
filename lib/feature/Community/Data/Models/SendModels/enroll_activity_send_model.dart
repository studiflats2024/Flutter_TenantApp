import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';

class EnrollActivitySendModel {
  String id;
  ActivitiesType type;

  EnrollActivitySendModel(this.id, this.type);

  toMap() {
    return {"type": type.filter, "activity_ID": id};
  }
}
