class GetContractSendModel {
  final String requestId;

  GetContractSendModel({required this.requestId});

  Map<String, dynamic> toMap() {
    return {
      "Req_ID": requestId,
    };
  }
}

class GetContractSendModelV2 {
  final String requestId;
  final String apartmentId;
  final String bedId;

  GetContractSendModelV2({required this.requestId, required this.apartmentId , required this.bedId});

  Map<String, dynamic> toMap() {
    return {
      "Booking_ID": requestId,
      "Apartment_ID": apartmentId,
      "Bed_ID": bedId,
    };
  }
}
