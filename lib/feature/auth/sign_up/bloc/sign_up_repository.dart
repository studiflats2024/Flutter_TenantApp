import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/apis/managers/profile_api_manger.dart';
import 'package:vivas/apis/models/auth/login/login_fail_response.dart';
import 'package:vivas/apis/models/auth/login/login_with_social_send_model_api.dart';
import 'package:vivas/apis/models/auth/register/create_account_send_model.dart';
import 'package:vivas/apis/models/auth/register/finish_account_send_model.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

import 'package:vivas/apis/models/auth/login/login_successful_response.dart';
import 'package:vivas/utils/build_type/build_type.dart';

abstract class BaseSignUpRepository {
  Future<SignUpState> signUpApi(
      String phoneNumber, String fullName, String password);
  Future<SignUpState> savaTokenData(
      LoginSuccessfulResponse loginSuccessfulResponse);
  Future<SignUpState> signUpWithGoogleApi(
      GoogleSignInAccount googleSignInAccount);
  Future<SignUpState> signUpWithAppleApi(
      AuthorizationCredentialAppleID appleID);
  Future<SignUpState> setAsLoggedUser();
  Future<SignUpState> getProfileInfoApi();
  Future<SignUpState> saveProfileInfo(ProfileInfoApiModel profileInfoApiModel);
}

class SignUpRepository implements BaseSignUpRepository {
  final PreferencesManager preferencesManager;
  final AuthApiManager authApiManager;
  final ProfileApiManger profileApiManger;

  SignUpRepository({
    required this.preferencesManager,
    required this.authApiManager,
    required this.profileApiManger,
  });

  @override
  Future<SignUpState> signUpApi(
      String phoneNumber, String fullName, String password) async {
    late SignUpState signUpState;
    await authApiManager.createAccountApi(
        CreateAccountSendModel(fullName, phoneNumber, password),
        (authSuccessfulResponse) async {
      await preferencesManager.setUUID(authSuccessfulResponse.uuid);
      signUpState = SignUpSuccessfullyState(authSuccessfulResponse);
    }, (errorApiModel) {
      signUpState = SignUpErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return signUpState;
  }

  @override
  Future<SignUpState> savaTokenData(
    LoginSuccessfulResponse loginSuccessfulResponse,
  ) async {
    late SignUpState signUpState;

    await preferencesManager.setTokenData(
        loginSuccessfulResponse.accessToken,
        loginSuccessfulResponse.refreshToken,
        loginSuccessfulResponse.expiration,
        loginSuccessfulResponse.uuid);

    signUpState = SaveTokenDataSuccessfullyState();
    return signUpState;
  }

  @override
  Future<SignUpState> signUpWithGoogleApi(
      GoogleSignInAccount googleSignInAccount) async {
    late SignUpState signUpState;
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
      signUpState = SignUpWithGoogleSuccessfullyState(loginWrapper);
    }, (errorApiModel) {
      if (errorApiModel is LoginFailResponse) {
        signUpState = SocialLoginFailState(errorApiModel);
      } else {
        signUpState = SignUpErrorState(
            errorApiModel.message, errorApiModel.isMessageLocalizationKey);
      }
    });

    return signUpState;
  }

  @override
  Future<SignUpState> signUpWithAppleApi(
      AuthorizationCredentialAppleID appleID) async {
    late SignUpState signUpState;
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
      signUpState = SignUpWithAppleSuccessfullyState(loginWrapper);
    }, (errorApiModel) {
      if (errorApiModel is LoginFailResponse) {
        signUpState = SocialLoginFailState(errorApiModel);
      } else {
        signUpState = SignUpErrorState(
            errorApiModel.message, errorApiModel.isMessageLocalizationKey);
      }
    });
    return signUpState;
  }

  @override
  Future<SignUpState> setAsLoggedUser() async {
    late SignUpState signUpState;

    await preferencesManager.setLoggedIn();
    signUpState = OpenHomeScreenState();
    return signUpState;
  }

  @override
  Future<SignUpState> getProfileInfoApi() async {
    late SignUpState signUpState;
    await preferencesManager.setLoggedIn();
    await profileApiManger.getProfileApi((profileWrapper) {
      signUpState = ProfileInfoLoadedState(profileWrapper);
    }, (errorApiModel) {
      signUpState = SignUpErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return signUpState;
  }

  @override
  Future<SignUpState> saveProfileInfo(
      ProfileInfoApiModel profileInfoApiModel) async {
    late SignUpState signUpState;

    await preferencesManager.saveUserInfo(
        fullName: profileInfoApiModel.fullName,
        imageUrl: profileInfoApiModel.profileImageUrl,
        about: profileInfoApiModel.about,
        email: profileInfoApiModel.email,
        mobileNumber: profileInfoApiModel.mobile,
        phoneVerified: profileInfoApiModel.phoneVerified,
        mailVerified: profileInfoApiModel.mailVerified,
        profileVerified: profileInfoApiModel.profileVerified);

    signUpState = SaveProfileInfoSuccessfullyState();
    return signUpState;
  }
}
