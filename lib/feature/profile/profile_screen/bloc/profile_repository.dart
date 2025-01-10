import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vivas/apis/managers/profile_api_manger.dart';
import 'package:vivas/apis/models/profile/edit_profile/basic_info/update_basic_data_model.dart';
import 'package:vivas/apis/models/profile/edit_profile/profile_image/update_profile_image_model.dart';
import 'package:vivas/apis/models/profile/edit_profile/update_email_or_phone/update_phone_model.dart';
import 'package:vivas/feature/profile/profile_screen/bloc/profile_bloc.dart';

import 'package:vivas/apis/models/profile/edit_profile/update_email_or_phone/update_email_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/feature/profile/edit_personal_information/bloc/edit_profile_bloc.dart';

import '../../../../utils/build_type/build_type.dart';

abstract class BaseProfileRepository {
  Future<GetProfileState> getProfileData();
  Future<GetProfileState> logout();
  Future<GetProfileState> deleteAccount();

  Future<EditProfileState> getUpdatedLocalData();
  Future<EditProfileState> updateBasicData(String fullName, String about);
  Future<EditProfileState> updateProfileImage(String imagePath);
  Future<EditProfileState> updateEmail(
      String currentEmail, String password, String newEmail);
  Future<EditProfileState> updatePhoneNumber(
      String currentPhoneNumber, String password, String newPhoneNumber);
}

class ProfileRepository implements BaseProfileRepository {
  final ProfileApiManger profileApiManger;

  final PreferencesManager preferencesManager;

  ProfileRepository(
      {required this.profileApiManger, required this.preferencesManager});

  @override
  Future<GetProfileState> getProfileData() async {
    late GetProfileState profileState;

    bool isLoggedIn = await preferencesManager.isLoggedIn();
    if (isLoggedIn) {
      final profileInfo = await preferencesManager.getUserInfo();
      profileState = GetProfileLoadedState(profileInfo);
    } else {
      profileState = GuestModeStateState();
    }
    return profileState;
  }

  @override
  Future<EditProfileState> updateBasicData(
      String fullName, String about) async {
    late EditProfileState editProfileState;

    await profileApiManger.updateBasicDataApi(
        UpdateBasicDataSendModel(fullName, about), (basicInfoWrapper) {
      preferencesManager.setName(fullName);
      preferencesManager.setAbout(about);
      editProfileState = BasicDataSuccessfullyUpdatedState(
          basicInfoWrapper.message ?? "Successfully Updated");
    }, (errorApiModel) {
      editProfileState = EditProfileErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return editProfileState;
  }

  @override
  Future<EditProfileState> updateProfileImage(String imagePath) async {
    late EditProfileState editProfileState;

    await profileApiManger.updateProfileImageApi(
        UpdateProfileImageSendModel(imagePath: imagePath),
        (profileImageWrapper) {
      preferencesManager.setUserImageUrl(profileImageWrapper.url ?? "");
      editProfileState = ProfileImageSuccessfullyUpdatedState(
          profileImageWrapper.message ?? "Successfully Updated");
    }, (errorApiModel) {
      editProfileState = EditProfileErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return editProfileState;
  }

  @override
  Future<EditProfileState> updateEmail(
      String currentEmail, String password, String newEmail) async {
    late EditProfileState updateState;
    await profileApiManger
        .updateEmailApi(UpdateEmailSendModel(currentEmail, password, newEmail),
            (updateEmailWrapper) {
      preferencesManager.setEmail(newEmail);
      updateState = CurrentEmailSuccessfullyUpdatedState(updateEmailWrapper);
    }, (errorApiModel) {
      updateState = EditProfileErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return updateState;
  }

  @override
  Future<EditProfileState> updatePhoneNumber(
      String currentPhoneNumber, String password, String newPhoneNumber) async {
    late EditProfileState updateState;
    await profileApiManger.updatePhoneNumberApi(
        UpdatePhoneNumberSendModel(
            currentPhoneNumber, password, newPhoneNumber),
        (updatePhoneNumberWrapper) {
      preferencesManager.setMobileNumber(newPhoneNumber);
      updateState =
          CurrentPhoneNumberSuccessfullyUpdatedState(updatePhoneNumberWrapper);
    }, (errorApiModel) {
      updateState = EditProfileErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return updateState;
  }

  @override
  Future<EditProfileState> getUpdatedLocalData() async {
    late EditProfileState editProfileState;

    final profileInfo = await preferencesManager.getUserInfo();
    editProfileState = LocalDataUpdatedSuccessfullyState(profileInfo);

    return editProfileState;
  }

  @override
  Future<GetProfileState> logout() async {
    late GetProfileState getProfileState;
    String deviceToken = await (Platform.isIOS && isDebugMode()
        ?FirebaseMessaging.instance.getAPNSToken()
        :FirebaseMessaging.instance.getToken() ) ?? "";
    await profileApiManger.logoutApi(deviceToken, (p0) {}, (p0) {});
    await preferencesManager.clearData();

    getProfileState = LogoutState();
    return getProfileState;
  }

  @override
  Future<GetProfileState> deleteAccount() async {
    late GetProfileState getProfileState;
    //String deviceToken = (await FirebaseMessaging.instance.getToken())!;
    await profileApiManger.deleteAccountApi((p0) {}, (p0) {});
    await preferencesManager.clearData();

    getProfileState = DeleteAccountState();
    return getProfileState;
  }
}
