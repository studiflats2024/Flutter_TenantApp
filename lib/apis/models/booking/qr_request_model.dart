class QrRequestModel {
  String bookingId;
  String bedId;
  String scannedQr;

  QrRequestModel(
      {required this.bookingId, required this.bedId, required this.scannedQr});

  Map<String, dynamic> toJson() {
    return {
      "Booking_ID": bookingId,
      "Bed_ID": bedId,
      "ScannedQR_Code": scannedQr,
    };
  }
}
