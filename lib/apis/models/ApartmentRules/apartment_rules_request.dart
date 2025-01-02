class ApartmentRulesRequest {
  String bookingId;
  String apartmentId;
  String bedId;

  ApartmentRulesRequest(this.bookingId, this.apartmentId, this.bedId);

  Map<String, dynamic> toMap() {
    return {
      "Booking_ID": bookingId,
      "Apartment_ID": apartmentId,
      "Bed_ID": bedId,
    };
  }
}
