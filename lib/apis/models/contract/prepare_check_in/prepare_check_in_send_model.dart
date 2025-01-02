class PrepareCheckInSendModel {
  final String requestId;
  final String checkDate;
  final String checkTime;
  final bool moveService;

  PrepareCheckInSendModel(
      {required this.requestId,
      required this.checkDate,
      required this.checkTime,
      required this.moveService});

  Map<String, dynamic> toMap() {
    return {
      "Req_ID": requestId,
      "CheckDate": checkDate,
      "CheckTime": checkTime,
      "Move_Service": moveService,
    };
  }
}
