import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/feature/profile/profile_screen/widget/radio_language_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/locale/locale_cubit.dart';

// ignore: must_be_immutable
class ChangeLanguageWidget extends BaseStatefulWidget {
  const ChangeLanguageWidget({
    super.key,
  });

  @override
  BaseState<ChangeLanguageWidget> baseCreateState() => _EditTenantWidgetState();
}

class _EditTenantWidgetState extends BaseState<ChangeLanguageWidget> {
  late LocaleApp localeApp;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localeApp = appLocale.isLTR() ? LocaleApp.en : LocaleApp.de;
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 40.h),
        RadioLanguageWidget(
          label: translate(LocalizationKeys.english)!,
          value: LocaleApp.en,
          groupValue: localeApp,
          onChanged: _selectLanguage,
        ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        RadioLanguageWidget(
          label: translate(LocalizationKeys.germany)!,
          value: LocaleApp.de,
          groupValue: localeApp,
          onChanged: _selectLanguage,
        ),
        const SizedBox(height: 24),
        AppElevatedButton.withTitle(
            onPressed: _closeChangeLanguageScreen,
            title: translate(LocalizationKeys.changeLanguage)!),
        const SizedBox(height: 24),
      ],
    );
  }

  void _selectLanguage(LocaleApp value) {
    setState(() {
      localeApp = value;
    });
  }

  void _closeChangeLanguageScreen() async {
    context.read<LocaleCubit>().changeLocale(localeApp);
    Navigator.of(context).pop();
  }
}
