import 'package:vivas/apis/models/auth/register/finish_account_send_model.dart';

class LoginWithSocialSendModelApi {
  final String socialId;
  final String name;
  final String email;
  final String deviceToken;
  final ProviderApiKey providerApiKey;

  LoginWithSocialSendModelApi(
      {required this.socialId,
      required this.name,
      required this.email,
      required this.deviceToken,
      required this.providerApiKey});

  Map<String, dynamic> toMap() {
    return {
      "SC_ID": socialId,
      "FullName": name,
      "Email": email,
      "Provider": providerApiKey.toApiKey(),
      "deviceToken": deviceToken,
    };
  }
}
