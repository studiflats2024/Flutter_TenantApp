class ExtendContractModel {
  DateTime? startDate;
  DateTime? endDate;
  String bookingId;
  String guestId;

  ExtendContractModel({
    required this.bookingId,
    required this.guestId,
    this.startDate,
    this.endDate
  });

  toMap(){
    return {
      "Booking_ID" : bookingId,
      "Guset_ID" : guestId,
      "Start_Date" : startDate,
      "End_Date" : endDate,
    };
  }
}
