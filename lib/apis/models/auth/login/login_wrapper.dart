import 'package:vivas/apis/models/_base/base_wrapper.dart';
import 'package:vivas/apis/models/auth/login/login_successful_response.dart';

class LoginWrapper extends BaseWrapper {
  final LoginSuccessfulResponse? data;

  LoginWrapper(this.data) : super(false, null);

  LoginWrapper.fromJson(Map<String, dynamic> json)
      : data = (json['access_token'] != null)
            ? LoginSuccessfulResponse.fromJson(json)
            : null,
        super.fromJson(json);

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
      };
}
