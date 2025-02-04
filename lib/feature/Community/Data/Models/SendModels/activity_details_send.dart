import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';


class ActivityDetailsSendModel{
  String id;
  ActivitiesType type;
  ActivityDetailsSendModel(this.id, this.type);
  toMap(){
    return {
      "type" : type.filter,
      "ID" : id
    };
  }
}