import 'package:flutter/material.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/locale_cubit.dart';

class RadioLanguageWidget extends StatelessWidget {
  const RadioLanguageWidget({
    super.key,
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final LocaleApp groupValue;
  final LocaleApp value;
  final ValueChanged<LocaleApp> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          if (value != groupValue) {
            onChanged(value);
          }
        },
        splashColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(label),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.languageRadioActive
                    : AppColors.languageRadioDeActive,
                border: Border.all(
                  width: 1.0,
                  color: isSelected
                      ? AppColors.languageRadioActiveBorder
                      : AppColors.languageRadioDeActiveBorder,
                ),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.done,
                      color: AppColors.languageRadioIcon,
                      size: 20,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  bool get isSelected => groupValue == value;
}
