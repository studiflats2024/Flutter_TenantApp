import 'package:vivas/apis/models/area_model/area_model.dart';

import '../apis/models/profile/profile_info_api_model.dart';
import '../utils/preferences/preferences_utils.dart';
import 'preferences_keys.dart';

class PreferencesManager {
  Future<bool> clearData() async {
    String? locale = await getLocale();
    await PreferencesUtils.clearData();
    if (locale != null) {
      await setLocale(locale);
    }
    return true;
  }

  Future<bool> setLocale(String data) async {
    return await PreferencesUtils.setString(PreferencesKeys.lang.name, data);
  }

  Future<String?> getLocale() async {
    return await PreferencesUtils.getString(PreferencesKeys.lang.name);
  }

  Future<bool> setCommunityFirstTime() async {
    return await PreferencesUtils.setBool(PreferencesKeys.communityFirstTime.name, true);
  }

  Future<bool?> getCommunityFirstTime() async {
    return await PreferencesUtils.getBool(PreferencesKeys.communityFirstTime.name);
  }

  Future<void> setLoggedIn() async {
    await PreferencesUtils.setBool(PreferencesKeys.isLoggedIn.name, true);
  }

  Future<void> setAsGuest() async {
    await PreferencesUtils.setBool(PreferencesKeys.isGuest.name, true);
  }

  Future<void> setNotAsGuest() async {
    await PreferencesUtils.setBool(PreferencesKeys.isGuest.name, false);
  }

  Future<bool> isAsGuest() async {
    return await PreferencesUtils.getBool(PreferencesKeys.isGuest.name);
  }

  Future<void> setNotLoggedIn() async {
    await PreferencesUtils.setBool(PreferencesKeys.isLoggedIn.name, false);
  }

  Future<void> setIsDown() async {
    await PreferencesUtils.setBool(PreferencesKeys.maintenance.name, true);
  }
  Future<void> setIsNotDown() async {
    await PreferencesUtils.setBool(PreferencesKeys.maintenance.name, false);
  }

  Future<bool> isLoggedIn() async {
    return await PreferencesUtils.getBool(PreferencesKeys.isLoggedIn.name);
  }

  Future<bool> isDown() async {
    return await PreferencesUtils.getBool(PreferencesKeys.maintenance.name);
  }

  Future<void> setAccessToken(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.accessToken.name, data);
  }

  Future<String?> getAccessToken() async {
    return await PreferencesUtils.getString(PreferencesKeys.accessToken.name);
  }

  Future<void> setRefreshToken(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.refreshToken.name, data);
  }

  Future<String?> getRefreshToken() async {
    return await PreferencesUtils.getString(PreferencesKeys.refreshToken.name);
  }

  Future<void> setName(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.name.name, data);
  }

  Future<String?> getName() async {
    return await PreferencesUtils.getString(PreferencesKeys.name.name);
  }

  Future<void> setUserImageUrl(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.userImageUrl.name, data);
  }

  Future<String?> getUserImageUrl() async {
    return await PreferencesUtils.getString(PreferencesKeys.userImageUrl.name);
  }

  Future<void> setExpiresToken(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.expiresIn.name, data);
  }

  Future<String?> getExpiresToken() async {
    return await PreferencesUtils.getString(PreferencesKeys.expiresIn.name);
  }

  Future<void> setUUID(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.uuid.name, data);
  }

  Future<String?> getUUID() async {
    return await PreferencesUtils.getString(PreferencesKeys.uuid.name);
  }

  Future<void> setEmail(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.email.name, data);
  }

  Future<String?> getEmail() async {
    return await PreferencesUtils.getString(PreferencesKeys.email.name);
  }

  Future<void> setAbout(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.about.name, data);
  }

  Future<String?> getAbout() async {
    return await PreferencesUtils.getString(PreferencesKeys.about.name);
  }

  Future<void> setMobileNumber(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.mobileNumber.name, data);
  }

  Future<String?> getMobileNumber() async {
    return await PreferencesUtils.getString(PreferencesKeys.mobileNumber.name);
  }

  Future<void> setPhoneVerified(bool data) async {
    await PreferencesUtils.setBool(PreferencesKeys.phoneVerified.name, data);
  }

  Future<bool?> getPhoneVerified() async {
    return await PreferencesUtils.getBool(PreferencesKeys.phoneVerified.name);
  }

  Future<void> setMailVerified(bool data) async {
    await PreferencesUtils.setBool(PreferencesKeys.mailVerified.name, data);
  }

  Future<bool?> getMailVerified() async {
    return await PreferencesUtils.getBool(PreferencesKeys.mailVerified.name);
  }

  Future<void> setProfileVerified(bool data) async {
    await PreferencesUtils.setBool(PreferencesKeys.profileVerified.name, data);
  }

  Future<bool?> getProfileVerified() async {
    return await PreferencesUtils.getBool(PreferencesKeys.profileVerified.name);
  }

  Future<void> setTokenData(String accessToken, String refreshToken,
      String expiresIn, String uuid) async {
    await setAccessToken(accessToken);
    await setRefreshToken(refreshToken);
    await setExpiresToken(expiresIn);
    await setUUID(uuid);
  }

  Future<void> saveUserInfo({
    required String fullName,
    required String email,
    required String about,
    required String mobileNumber,
    required String? imageUrl,
    required bool phoneVerified,
    required bool mailVerified,
    required bool profileVerified,
  }) async {
    await setName(fullName);
    await setEmail(email);
    await setAbout(about);
    await setMobileNumber(mobileNumber);
    await setPhoneVerified(phoneVerified);
    await setMailVerified(mailVerified);
    await setProfileVerified(profileVerified);
    if (imageUrl != null) {
      await setUserImageUrl(imageUrl);
    }
  }

  Future<ProfileInfoApiModel> getUserInfo() async {
    final userId = await getUUID() ?? "";
    final fullName = await getName() ?? "";
    final email = await getEmail() ?? "";
    final mobileNumber = await getMobileNumber() ?? "";
    final about = await getAbout() ?? "";
    final profileImageUrl = await getUserImageUrl() ?? "";
    final phoneVerified = await getPhoneVerified() ?? true;
    final mailVerified = await getMailVerified() ?? true;
    final profileVerified = await getProfileVerified() ?? true;

    return ProfileInfoApiModel(
        userId: userId,
        fullName: fullName,
        email: email,
        mobile: mobileNumber,
        about: about,
        profileImageUrl: profileImageUrl,
        phoneVerified: phoneVerified,
        mailVerified: mailVerified,
        profileVerified: profileVerified);
  }

  Future<bool> setAreasList(List<AreaModel> areaList) async {
    return await PreferencesUtils.setString(
        PreferencesKeys.areaList.name, AreaModel.encode(areaList));
  }

  Future<List<AreaModel>> getAreasList() async {
    String cartJson =
        await PreferencesUtils.getString(PreferencesKeys.areaList.name) ?? "";
    if (cartJson.isEmpty) {
      return [];
    } else {
      return AreaModel.decode(cartJson);
    }
  }
}
