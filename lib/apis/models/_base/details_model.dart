class DetailsModel {
  final int? statusCode;
  final String? message;
  bool isHandled = false;

  DetailsModel(this.statusCode, this.message);

  DetailsModel.fromJson(Map<String, dynamic> json)
      : statusCode = json['status_code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() =>
      {'status_code': statusCode, 'message': message};

  static DetailsModel getUnknownError() {
    return DetailsModel(6004, "Unknown Error");
  }
}

/// reference
/// https://flutter.dev/docs/development/data-and-backend/json
/// https://www.raywenderlich.com/4038868-parsing-json-in-flutter
