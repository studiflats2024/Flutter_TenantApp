class ChangeCheckOutDateModel{
  DateTime? startDate;
  DateTime? endDate;
  DateTime? newEndDate;
  String bookingId;

  ChangeCheckOutDateModel(this.bookingId ,this.startDate, this.endDate,);

  toMap(){
    return {
      "Booking_ID" : bookingId,
      "Checkout_Date" : newEndDate,
    };
  }
}