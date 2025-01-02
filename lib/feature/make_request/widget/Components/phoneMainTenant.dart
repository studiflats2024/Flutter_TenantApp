import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class PhoneMainGuest extends BaseStatefulScreenWidget {
  int index;
  String bedId;
  final Function(int roomIndex, PhoneNumber? value, {String? myPhone})
      guestWaNoSaved;

  PhoneMainGuest(
      {super.key,
      required this.index,
      required this.bedId,
      required this.guestWaNoSaved});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return MainPhone();
  }
}

class MainPhone extends BaseScreenState<PhoneMainGuest> {
  PhoneController phoneController = PhoneController();
  final AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    Future.wait([init()]);
    super.initState();
  }

  Future<void> init() async {
    phoneController.value = PhoneNumber.parse(
        (await GetIt.I.get<PreferencesManager>().getMobileNumber()) ?? "");
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.whatsAppNumber)!}"
                  .concatenateAsterisk,
              style: textTheme.titleMedium?.copyWith(
                  fontSize: FontSize.fontSize12,
                  color: AppColors.appFormFieldTitle,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          PhoneFormField(
            autovalidateMode: autoValidateMode,
            autofillHints: const [AutofillHints.telephoneNumber],
            countrySelectorNavigator:
                const CountrySelectorNavigator.draggableBottomSheet(),
            controller: phoneController,
            decoration: InputDecoration(
              hintText: "ex.1234567890",
              fillColor: AppColors.appFormFieldFill,
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              hintStyle: textTheme.labelMedium?.copyWith(
                color: AppColors.formFieldHintText,
                fontWeight: FontWeight.w400,
                fontSize: 16.spMin,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.enabledAppFormFieldBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.formFieldFocusIBorder,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            enabled: false,
            countryButtonStyle: CountryButtonStyle(
                textStyle: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.formFieldText),
                flagSize: 20.r,
                showFlag: true,
                showDropdownIcon: false),
            cursorColor: Theme.of(context).colorScheme.primary,
            onSaved: (value) => widget.guestWaNoSaved(widget.index, value),
            textInputAction: TextInputAction.done,
            isCountrySelectionEnabled: true,
            isCountryButtonPersistent: true,
            style:
                textTheme.bodyMedium?.copyWith(color: AppColors.formFieldText),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
