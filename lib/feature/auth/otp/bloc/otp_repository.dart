import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/apis/models/auth/otp/check_otp_model.dart';
import 'package:vivas/apis/models/auth/otp/send_otp_model.dart';
import 'package:vivas/feature/auth/otp/bloc/otp_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseOtpRepository {
  Future<OtpState> requestOTPAgainApi(String uuid);
  Future<OtpState> checkOTPApi(String uuid, String otp);
}

class OtpRepository implements BaseOtpRepository {
  final PreferencesManager preferencesManager;
  final AuthApiManager authApiManager;

  OtpRepository({
    required this.authApiManager,
    required this.preferencesManager,
  });

  @override
  Future<OtpState> requestOTPAgainApi(String uuid) async {
    late OtpState otpState;
    await authApiManager.sendOtpApi(SendOtpModelApi(uuid),
        (sendOtpSuccessfulResponse) {
      otpState = RequestOTPAgainApiSuccessfullyState(
          sendOtpSuccessfulResponse.message);
    }, (errorApiModel) {
      otpState = OtpErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return otpState;
  }

  @override
  Future<OtpState> checkOTPApi(String uuid, String otpCode) async {
    late OtpState otpState;
    await authApiManager.checkOtpApi(CheckOtpModelApi(otpCode, uuid),
        (sendOtpSuccessfulResponse) {
      otpState =
          CheckOTPApiSuccessfullyState(sendOtpSuccessfulResponse.message);
    }, (errorApiModel) {
      otpState = OtpErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return otpState;
  }
}
