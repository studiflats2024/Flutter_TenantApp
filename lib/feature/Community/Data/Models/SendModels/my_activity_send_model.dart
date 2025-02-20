import 'package:vivas/feature/Community/Data/Managers/my_activity_enum.dart';

class MyActivitySendModel {
  num pageNum;
  num pageSize;
  MyActivityStatus status;

  MyActivitySendModel({
    required this.pageNum,
    this.pageSize = 10,
    this.status = MyActivityStatus.ongoing,
  });

  toMap() {
    return {
      "Page_No": pageNum,
      "page_Size": pageSize,
      "_Status": status.filter,
    };
  }
}
