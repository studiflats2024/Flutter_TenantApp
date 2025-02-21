import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Managers/my_activity_enum.dart';


class ActivityDetailsSendModel{
  String id;
  ActivitiesType type;
  MyActivityStatus? status;
  ActivityDetailsSendModel(this.id, this.type, {this.status});
  toMap(){
    return {
      "type" : type.filter,
      "ID" : id
    };
  }
}