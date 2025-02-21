class ConsultSubscription {
  String? date;
  DateTime? dateTime;
  String? day;
  String? time;
  String? satus;

  ConsultSubscription({
    this.date,
    this.dateTime,
    this.day,
    this.time,
    this.satus,
  });

  factory ConsultSubscription.fromJson(Map<String, dynamic> json) =>
      ConsultSubscription(
        date: json["date"],
        dateTime:
        json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        day: json["day"],
        time: json["time"],
        satus: json["satus"],
      );

  Map<String, dynamic> toJson() => {
    "date": date,
    "dateTime": dateTime?.toIso8601String(),
    "day": day,
    "time": time,
    "satus": satus,
  };
}