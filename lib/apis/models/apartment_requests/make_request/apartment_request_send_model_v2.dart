import 'dart:convert';

ApartmentRequestsSendModelV2 apartmentRequestsSendModelV2FromJson(String str) => ApartmentRequestsSendModelV2.fromJson(json.decode(str));

String apartmentRequestsSendModelV2ToJson(ApartmentRequestsSendModelV2 data) => json.encode(data.toJson());

class ApartmentRequestsSendModelV2 {
  String? bookingApartmentId;
  String? bookingRoomId;
  String? bookingBedId;
  DateTime? bookingStartDate;
  DateTime? bookingEndDate;
  String? bookingAgentCode;
  String? bookingPromoCode;
  List<BookingGuest>? bookingGuests;
  String? bookingGuestProfession;
  String? bookingUnvWpName;
  bool? fullApartment;

  ApartmentRequestsSendModelV2({
    this.bookingApartmentId,
    this.bookingRoomId,
    this.bookingBedId,
    this.bookingStartDate,
    this.bookingEndDate,
    this.bookingAgentCode,
    this.bookingPromoCode,
    this.bookingGuests,
    this.bookingGuestProfession,
    this.bookingUnvWpName,
    this.fullApartment
  });

  factory ApartmentRequestsSendModelV2.fromJson(Map<String, dynamic> json) => ApartmentRequestsSendModelV2(
    bookingApartmentId: json["apartment_ID"],
    bookingStartDate: json["booking_Start_Date"] == null ? null : DateTime.parse(json["booking_Start_Date"]),
    bookingEndDate: json["booking_End_Date"] == null ? null : DateTime.parse(json["booking_End_Date"]),
    bookingAgentCode: json["booking_Agent_Code"],
    bookingGuests: json["booking_Guests"] == null ? [] : List<BookingGuest>.from(json["booking_Guests"]!.map((x) => BookingGuest.fromJson(x))),
    bookingGuestProfession: json["booking_Guest_Profession"],
    bookingUnvWpName: json["booking_Unv_WP_Name"],
      fullApartment : json["full_Apartment"],
    bookingPromoCode : json["promo_code"],

  );

  Map<String, dynamic> toJson() => {
    "apartment_ID": bookingApartmentId,
    "booking_Start_Date": bookingStartDate?.toIso8601String(),
    "booking_End_Date": bookingEndDate?.toIso8601String(),
    "booking_Agent_Code": bookingAgentCode,
    "booking_Guests": bookingGuests == null ? [] : List<dynamic>.from(bookingGuests!.map((x) => x.toJson())),
    "booking_Guest_Profession": bookingGuestProfession,
    "booking_Unv_WP_Name": bookingUnvWpName,
    "full_Apartment" : fullApartment,
    "promo_code" : bookingPromoCode,
    if(bookingRoomId != null) "room_ID" : bookingRoomId,
    if(bookingBedId != null) "bed_ID" : bookingBedId,

  };
}

class BookingGuest {
  String? roomId;
  String? apartmentID;
  String? bedID;
  String? guestName;
  String? guestWaNumber;
  String? guestEmail;

  BookingGuest({
    this.roomId,
    this.bedID,
    this.apartmentID,
    this.guestName,
    this.guestWaNumber,
    this.guestEmail,
  });

  factory BookingGuest.fromJson(Map<String, dynamic> json) => BookingGuest(
    roomId: json["room_ID"],
    apartmentID : json["apartment_ID"],
    bedID : json["bed_ID"],
    guestName: json["guest_Name"],
    guestWaNumber: json["guest_WA_No"],
    guestEmail: json["guest_Email"],
  );

  Map<String, dynamic> toJson() => {
    "room_ID": roomId,
    "bed_ID": bedID,
    "apartment_ID" : apartmentID,
    "guest_Name": guestName,
    "guest_WA_No": guestWaNumber,
    "guest_Email": guestEmail,
  };
}
