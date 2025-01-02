import 'dart:convert';

ArrivingDetailsRequestModel arrivingDetailsRequestModelFromJson(String str) => ArrivingDetailsRequestModel.fromJson(json.decode(str));

String arrivingDetailsRequestModelToJson(ArrivingDetailsRequestModel data) => json.encode(data.toJson());

class ArrivingDetailsRequestModel {
  String? bookingId;
  String? guestId;
  String? checkinDate;
  String? checkinTime;
  String? airportName;
  String? flightNo;
  bool? moveService;
  bool fromBerlin ;

  ArrivingDetailsRequestModel({
    this.bookingId,
    this.guestId,
    this.checkinDate,
    this.checkinTime,
    this.airportName,
    this.flightNo,
    this.moveService,
    this.fromBerlin = true
  });

  factory ArrivingDetailsRequestModel.fromJson(Map<String, dynamic> json) => ArrivingDetailsRequestModel(
    bookingId: json["booking_ID"],
    guestId: json["guest_ID"],
    checkinDate: json["checkin_Date"],
    checkinTime: json["checkin_Time"],
    airportName: json["airport_Name"],
    flightNo: json["flight_No"],
    moveService: json["move_Service"],
  );

  Map<String, dynamic> toJson() => {
    "booking_ID": bookingId,
    "guest_ID": guestId,
    "checkin_Date": checkinDate,
    "checkin_Time": checkinTime,
    "airport_Name": airportName,
    "flight_No": flightNo,
    "move_Service": moveService,
  };
}
