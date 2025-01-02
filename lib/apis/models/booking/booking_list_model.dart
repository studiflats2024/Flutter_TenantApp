import 'dart:convert';

BookingListModel bookingListModelFromJson(String str) =>
    BookingListModel.fromJson(json.decode(str));

String bookingListModelToJson(BookingListModel data) =>
    json.encode(data.toJson());

class BookingListModel {
  int pageNumber;
  int pageSize;
  int totalRecords;
  int totalPages;
  List<BookingModel> data;

  BookingListModel({
    required this.pageNumber,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
    required this.data,
  });

  factory BookingListModel.fromJson(Map<String, dynamic> json) =>
      BookingListModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        data: json["data"][0] == null || json["data"] == null
            ? []
            : List<BookingModel>.from(json["data"].map((x) => BookingModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalRecords": totalRecords,
        "totalPages": totalPages,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BookingModel {
  String bookingId;
  String apartmentImage;
  String apartmentName;
  String apartmentLocation;
  String checkIn;
  String checkOut;
  String bookingStatus;

  BookingModel({
    required this.bookingId,
    required this.apartmentImage,
    required this.apartmentName,
    required this.apartmentLocation,
    required this.checkIn,
    required this.checkOut,
    required this.bookingStatus,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        bookingId: json["booking_ID"],
        apartmentImage: json["apartment_Image"],
        apartmentName: json["apartment_Name"],
        apartmentLocation: json["apartment_Location"],
        checkIn: json["check_In"],
        checkOut: json["check_Out"],
        bookingStatus: json["bookingStatus"],
      );

  Map<String, dynamic> toJson() => {
        "booking_ID": bookingId,
        "apartment_Image": apartmentImage,
        "apartment_Name": apartmentName,
        "apartment_Location": apartmentLocation,
        "check_In": checkIn,
        "check_Out": checkOut,
        "bookingStatus": bookingStatus,
      };
}
