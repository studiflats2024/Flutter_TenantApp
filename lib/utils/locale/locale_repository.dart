import 'package:vivas/preferences/preferences_manager.dart';

import 'locale_cubit.dart';

abstract class BaseLocaleRepository {
  Future<void> changeLanguageLocal(LocaleApp localeApp);
  Future<String?> getLanguageLocal();
  Future<void> changeLanguageApi(LocaleApp localeApp);
  Future<void> updateLanguageInfo(LocaleApp localeApp);
}

class LocaleRepository implements BaseLocaleRepository {
  final PreferencesManager preferenceManager;

  LocaleRepository({required this.preferenceManager});

  @override
  Future<void> changeLanguageLocal(LocaleApp localeApp) async {
    await preferenceManager.setLocale(localeApp.mapToPreferenceKey());
  }

  @override
  Future<String?> getLanguageLocal() async {
    return await preferenceManager.getLocale();
  }

  @override
  Future<void> changeLanguageApi(LocaleApp localeApp) async {}

  @override
  Future<void> updateLanguageInfo(LocaleApp localeApp) async {
    await changeLanguageLocal(localeApp);
    if (await preferenceManager.isLoggedIn()) {
      changeLanguageApi(localeApp);
    }
  }
}
