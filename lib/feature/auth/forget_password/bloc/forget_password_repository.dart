import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/apis/models/auth/forget_password/forget_password_send_model.dart';
import 'package:vivas/apis/models/auth/forget_password/reset_password_send_model.dart';
import 'package:vivas/feature/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseForgetPasswordRepository {
  Future<ForgetPasswordState> requestOTPApi(String mobile);
  Future<ForgetPasswordState> resetPasswordApi(
      String uuid, String token, String password);
  Future<ForgetPasswordState> resetPasswordApiV2(
      String uuid, String token, String password);
}

class ForgetPasswordRepository implements BaseForgetPasswordRepository {
  final PreferencesManager preferencesManager;
  final AuthApiManager authApiManager;

  ForgetPasswordRepository({
    required this.preferencesManager,
    required this.authApiManager,
  });
  @override
  Future<ForgetPasswordState> requestOTPApi(String mobile) async {
    late ForgetPasswordState forgetPasswordState;

    await authApiManager.forgetPasswordApi(ForgetPasswordSendModel(mobile),
        (authSuccessfulResponse) {
      forgetPasswordState =
          RequestOTPApiSuccessfullyState(authSuccessfulResponse);
    }, (errorApiModel) {
      forgetPasswordState = ForgetPasswordErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return forgetPasswordState;
  }

  @override
  Future<ForgetPasswordState> resetPasswordApi(
      String uuid, String token, String password) async {
    late ForgetPasswordState forgetPasswordState;
    await authApiManager
        .resetPasswordApi(ResetPasswordSendModelApi(uuid, token, password),
            (authSuccessfulResponse) {
      forgetPasswordState =
          ResetPasswordApiSuccessfullyState(authSuccessfulResponse.message);
    }, (errorApiModel) {
      forgetPasswordState = ForgetPasswordErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return forgetPasswordState;
  }

  @override
  Future<ForgetPasswordState> resetPasswordApiV2(
      String uuid, String token, String password) async {
    late ForgetPasswordState forgetPasswordState;
    await authApiManager
        .resetPasswordApiV2(ResetPasswordSendModelApi(uuid, token, password),
            (authSuccessfulResponse) {
          forgetPasswordState =
              ResetPasswordApiSuccessfullyState(authSuccessfulResponse.message);
        }, (errorApiModel) {
          forgetPasswordState = ForgetPasswordErrorState(
              errorApiModel.message, errorApiModel.isMessageLocalizationKey);
        });

    return forgetPasswordState;
  }
}
