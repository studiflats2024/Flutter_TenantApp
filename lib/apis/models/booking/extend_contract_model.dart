class ExtendContractModel {
  DateTime? startDate;
  DateTime? endDate;
  String bookingId;
  String guestId;
  String? extendId;
  String? extendStatus;
  String? extendContract;
  String? extendSignature;
  String? extendedAt;
  String? extendedFrom;
  String? extendedTo;
  String? rejectReason;
  bool? extendAccepted;
  bool? extendSigned;

  ExtendContractModel({
    required this.bookingId,
    required this.guestId,
    this.startDate,
    this.endDate,
    this.extendId,
    this.extendedTo,
    this.extendedAt,
    this.extendedFrom,
    this.extendStatus,
    this.extendContract,
    this.rejectReason,
    this.extendSignature,
    this.extendAccepted,
    this.extendSigned
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
