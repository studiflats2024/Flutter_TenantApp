import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/apis/managers/profile_api_manger.dart';
import 'package:vivas/apis/models/auth/login/login_fail_response.dart';
import 'package:vivas/apis/models/auth/login/login_send_model.dart';
import 'package:vivas/apis/models/auth/login/login_with_social_send_model_api.dart';
import 'package:vivas/apis/models/auth/register/finish_account_send_model.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';

import 'package:vivas/apis/models/auth/login/login_successful_response.dart';

import '../../../../utils/build_type/build_type.dart';
import 'login_bloc.dart';

abstract class BaseLoginRepository {
  Future<LoginState> loginWithUserNameAndPasswordApi(
      String userName, String password);
  Future<LoginState> signInWithGoogleApi(
      GoogleSignInAccount googleSignInAccount);
  Future<LoginState> signInWithAppleApi(AuthorizationCredentialAppleID appleID);
  Future<LoginState> savaTokenData(
      LoginSuccessfulResponse loginSuccessfulResponse);
  Future<LoginState> setAsLoggedUser();
  Future<LoginState> getProfileInfoApi();
  Future<LoginState> saveProfileInfo(ProfileInfoApiModel profileInfoApiModel);
}

class LoginRepository implements BaseLoginRepository {
  final AuthApiManager authApiManager;
  final ProfileApiManger profileApiManger;

  final PreferencesManager preferencesManager;

  LoginRepository({
    required this.preferencesManager,
    required this.authApiManager,
    required this.profileApiManger,
  });

  @override
  Future<LoginState> loginWithUserNameAndPasswordApi(
      String userName, String password) async {
    late LoginState loginState;
    String deviceToken = await (Platform.isIOS && isDebugMode()
        ?FirebaseMessaging.instance.getAPNSToken()
        :FirebaseMessaging.instance.getToken() ) ?? "";
    await authApiManager.loginApi(
        LoginSendModelApi(userName, password, deviceToken), (loginWrapper) {
      loginState = LoginWithPhoneSuccessfullyState(loginWrapper);
    }, (errorApiModel) {
      if (errorApiModel is LoginFailResponse) {
        loginState = LoginFailState(errorApiModel, false);
      } else {
        loginState = LoginErrorState(
            errorApiModel.message, errorApiModel.isMessageLocalizationKey);
      }
    });

    return loginState;
  }

  @override
  Future<LoginState> signInWithGoogleApi(
      GoogleSignInAccount googleSignInAccount) async {
    late LoginState loginState;
    String deviceToken =  await (Platform.isIOS && isDebugMode()
        ?FirebaseMessaging.instance.getAPNSToken()
        :FirebaseMessaging.instance.getToken() ) ?? "";

    await authApiManager.loginWithSocial(
        LoginWithSocialSendModelApi(
            email: googleSignInAccount.email,
            name: googleSignInAccount.displayName ?? "",
            providerApiKey: ProviderApiKey.google,
            socialId: googleSignInAccount.id,
            deviceToken: deviceToken), (loginWrapper) {
      loginState = LoginWithGoogleSuccessfullyState(loginWrapper);
    }, (errorApiModel) {
      if (errorApiModel is LoginFailResponse) {
        loginState = LoginFailState(errorApiModel, true);
      } else {
        loginState = LoginErrorState(
            errorApiModel.message, errorApiModel.isMessageLocalizationKey);
      }
    });

    return loginState;
  }

  @override
  Future<LoginState> signInWithAppleApi(
      AuthorizationCredentialAppleID appleID) async {
    late LoginState loginState;
    String deviceToken =  await (Platform.isIOS && isDebugMode()
        ?FirebaseMessaging.instance.getAPNSToken()
        :FirebaseMessaging.instance.getToken() ) ?? "";

    await authApiManager.loginWithSocial(
        LoginWithSocialSendModelApi(
          email: appleID.email ?? "",
          name: "${appleID.givenName ?? ''} ${appleID.familyName ?? ''}",
          providerApiKey: ProviderApiKey.apple,
          socialId: appleID.userIdentifier ?? "",
          deviceToken: deviceToken,
        ), (loginWrapper) {
      loginState = LoginWithAppleSuccessfullyState(loginWrapper);
    }, (errorApiModel) {
      if (errorApiModel is LoginFailResponse) {
        loginState = LoginFailState(errorApiModel, true);
      } else {
        loginState = LoginErrorState(
            errorApiModel.message, errorApiModel.isMessageLocalizationKey);
      }
    });

    return loginState;
  }

  @override
  Future<LoginState> savaTokenData(
      LoginSuccessfulResponse loginSuccessfulResponse,
      ) async {
    late LoginState loginState;

    await preferencesManager.setTokenData(
        loginSuccessfulResponse.accessToken,
        loginSuccessfulResponse.refreshToken,
        loginSuccessfulResponse.expiration,
        loginSuccessfulResponse.uuid);

    loginState = SaveTokenDataSuccessfullyState(loginSuccessfulResponse);
    return loginState;
  }

  @override
  Future<LoginState> setAsLoggedUser() async {
    late LoginState loginState;

    await preferencesManager.setLoggedIn();
    loginState = OpenHomeScreenState();
    return loginState;
  }

  @override
  Future<LoginState> getProfileInfoApi() async {
    late LoginState loginState;
    await preferencesManager.setLoggedIn();

    await profileApiManger.getProfileApi((profileWrapper) {
      loginState = ProfileInfoLoadedState(profileWrapper);
    }, (errorApiModel) {
      loginState = LoginErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return loginState;
  }

  @override
  Future<LoginState> saveProfileInfo(
      ProfileInfoApiModel profileInfoApiModel) async {
    late LoginState loginState;

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
