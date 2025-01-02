class UpdateWishListRequestResponse {
  final String message;

  UpdateWishListRequestResponse(
    this.message,
  );

  UpdateWishListRequestResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
