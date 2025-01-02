import 'package:vivas/apis/errors/error_api_model.dart';

class LoginFailResponse extends ErrorApiModel {
  final String status;
  final String uuid;

  final bool profileCompleted;
  final bool accountConfirmed;

  LoginFailResponse({
    required this.status,
    required this.uuid,
    required String message,
    required this.profileCompleted,
    required this.accountConfirmed,
  }) : super(isMessageLocalizationKey: false, message: message, code: 400);

  factory LoginFailResponse.fromJson(Map<String, dynamic> json) {
    return LoginFailResponse(
      status: json['status'] as String,
      uuid: json['uuid'] ?? "",
      message: json['message'],
      profileCompleted: json['profileCompleted'] != null
          ? json['profileCompleted'] as bool
          : true,
      accountConfirmed: json['account_Confirmed'] != null
          ? json['account_Confirmed'] as bool
          : true,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'uuid': uuid,
        'profile_Completed': profileCompleted,
        'account_Confirmed': accountConfirmed,
      };
}
