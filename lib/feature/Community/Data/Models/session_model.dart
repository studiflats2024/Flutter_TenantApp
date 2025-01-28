class SessionModel {
  String title;
  String date;
  String startTime;
  String endTime;
  String? video;

  SessionModel({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.video,
  });
}
