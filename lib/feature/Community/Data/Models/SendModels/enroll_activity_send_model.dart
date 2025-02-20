import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';

class EnrollActivitySendModel {
  String id;
  ActivitiesType type;
  String? date;

  EnrollActivitySendModel(this.id, this.type, {this.date});

  toMap() {
    return {
      "type": type.filter,
      "activity_ID": id,
      if (type == ActivitiesType.consultant) "date": date,
    };
  }
}
