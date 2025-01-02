class InvoiceRentRequest {
  String bookingId;
  List<String> tenants;

  InvoiceRentRequest(this.bookingId, this.tenants);

  toParameters() {
    return {
      "Booking_ID": bookingId,
    };
  }

  toMap() {
    return List<dynamic>.from(tenants.map((x) => x));
  }
}
