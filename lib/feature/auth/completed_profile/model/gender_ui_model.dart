import 'package:vivas/utils/locale/app_localization_keys.dart';

class GenderUiModel {
  final String key;
  final String value;

  GenderUiModel(this.key, this.value);
  static List<GenderUiModel> genders = [
    GenderUiModel(GenderApiKey.male, LocalizationKeys.male),
    GenderUiModel(GenderApiKey.female, LocalizationKeys.female),
  ];

  static GenderUiModel? fromApiKey(String key) {
    try {
      GenderUiModel genderModelApiLocalizationKey = genders.firstWhere(
          (genderModelApiLocalizationKey) =>
              genderModelApiLocalizationKey.key == key);
      return genderModelApiLocalizationKey;
    } catch (_) {
      return null;
    }
  }
}

class GenderApiKey {
  static const String male = "Male";
  static const String female = "Female";
}
