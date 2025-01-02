import 'package:vivas/utils/locale/app_localization_keys.dart';

class RoleUiModel {
  final String key;
  final String value;

  RoleUiModel(this.key, this.value);
  static List<RoleUiModel> roles = [
    RoleUiModel(RoleApiKey.student, LocalizationKeys.student),
    RoleUiModel(RoleApiKey.employee, LocalizationKeys.employee),
  ];

  static RoleUiModel? fromApiKey(String key) {
    try {
      RoleUiModel genderModelApiLocalizationKey = roles.firstWhere(
          (genderModelApiLocalizationKey) =>
              genderModelApiLocalizationKey.key == key);
      return genderModelApiLocalizationKey;
    } catch (_) {
      return null;
    }
  }
}

class RoleApiKey {
  static const String student = "student";
  static const String employee = "employee";
}
