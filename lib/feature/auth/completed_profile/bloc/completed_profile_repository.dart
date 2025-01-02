import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/apis/managers/profile_api_manger.dart';
import 'package:vivas/apis/models/auth/login/login_successful_response.dart';
import 'package:vivas/apis/models/auth/register/finish_account_send_model.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/auth/completed_profile/bloc/completed_profile_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseCompletedProfiledRepository {
  Future<CompletedProfileState> completedProfileInfoApi({
    String? email,
    String? mobileNumber,
    required String genderKey,
    required String birthday,
    required String nationality,
    required String uuid,
    required bool fromSocial,
  });

  Future<CompletedProfileState> savaTokenData(
      LoginSuccessfulResponse loginSuccessfulResponse);
  Future<CompletedProfileState> setAsLoggedUser();
  Future<CompletedProfileState> getProfileInfoApi();
  Future<CompletedProfileState> saveProfileInfo(ProfileInfoApiModel profileInfoApiModel);
}

class CompletedProfileRepository implements BaseCompletedProfiledRepository {
  final PreferencesManager preferencesManager;
  final ProfileApiManger profileApiManger;
  final AuthApiManager authApiManager;

  CompletedProfileRepository({
    required this.preferencesManager,
    required this.profileApiManger,
    required this.authApiManager,
  });

  @override
  Future<CompletedProfileState> completedProfileInfoApi({
    String? email,
    String? mobileNumber,
    required String genderKey,
    required String birthday,
    required String nationality,
    required String uuid,
    required bool fromSocial,
  }) async {
    late CompletedProfileState completedProfileState;
    await authApiManager.finishAccountApi(
        FinishAccountSendModel(
          email: email,
          gender: genderKey,
          mobileNumber: mobileNumber,
          dob: birthday,
          nationality: nationality,
          providerApiKey:
              fromSocial ? ProviderApiKey.google : ProviderApiKey.locale,
          uuid: uuid,
        ), (loginWrapper) async{
      await preferencesManager.setTokenData(
          loginWrapper.accessToken,
          loginWrapper.refreshToken,
          loginWrapper.expiration,
          loginWrapper.uuid);
      await preferencesManager.isLoggedIn();
      completedProfileState = CompletedProfileInfoSuccessfullyState(loginWrapper);
    }, (errorApiModel) {
      completedProfileState = CompletedProfileErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return completedProfileState;
  }


  @override
  Future<CompletedProfileState> savaTokenData(
      LoginSuccessfulResponse loginSuccessfulResponse,
      ) async {
    late CompletedProfileState loginState;

    await preferencesManager.setTokenData(
        loginSuccessfulResponse.accessToken,
        loginSuccessfulResponse.refreshToken,
        loginSuccessfulResponse.expiration,
        loginSuccessfulResponse.uuid);

    loginState = SaveTokenDataSuccessfullyState(loginSuccessfulResponse);
    return loginState;
  }

  @override
  Future<CompletedProfileState> setAsLoggedUser() async {
    late CompletedProfileState loginState;

    await preferencesManager.setLoggedIn();
    loginState = OpenHomeScreenState();
    return loginState;
  }

  @override
  Future<CompletedProfileState> getProfileInfoApi() async {
    late CompletedProfileState loginState;
    await preferencesManager.setLoggedIn();

    await profileApiManger.getProfileApi((profileWrapper) {
      loginState = ProfileInfoLoadedState(profileWrapper);
    }, (errorApiModel) {
      loginState = CompletedProfileErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return loginState;
  }

  @override
  Future<CompletedProfileState> saveProfileInfo(
      ProfileInfoApiModel profileInfoApiModel) async {
    late CompletedProfileState loginState;

    await preferencesManager.saveUserInfo(
        fullName: profileInfoApiModel.fullName,
        imageUrl: profileInfoApiModel.profileImageUrl,
        about: profileInfoApiModel.about,
        email: profileInfoApiModel.email,
        mobileNumber: profileInfoApiModel.mobile,
        phoneVerified: profileInfoApiModel.phoneVerified,
        mailVerified: profileInfoApiModel.mailVerified,
        profileVerified: profileInfoApiModel.profileVerified);

    loginState = SaveProfileInfoSuccessfullyState();
    return loginState;
  }
}
