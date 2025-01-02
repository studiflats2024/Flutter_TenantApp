class AcceptRejectOfferResponse {
  final String message;

  AcceptRejectOfferResponse(this.message);

  AcceptRejectOfferResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
