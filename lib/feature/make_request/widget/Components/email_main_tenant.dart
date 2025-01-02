import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class EmailMainGuest extends BaseStatefulScreenWidget {
  final int index;
  final String bedId;
  final Function(int roomIndex, String value) guestEmailSavedSaved;

  const EmailMainGuest(
      {super.key,
      required this.index,
      required this.bedId,
      required this.guestEmailSavedSaved});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return MainEmail();
  }
}

class MainEmail extends BaseScreenState<EmailMainGuest> with AuthValidate {
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    Future.wait([init()]);
    super.initState();
  }

  Future<void> init() async {
    emailController.text =
        (await GetIt.I.get<PreferencesManager>().getEmail()) ?? "";
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.email)!}"
                  .concatenateAsterisk,
              style: textTheme.titleMedium?.copyWith(
                  fontSize: FontSize.fontSize12,
                  color: AppColors.appFormFieldTitle,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          TextFormField(
            readOnly: true,
            enabled: false,
            onSaved: (value) =>
                widget.guestEmailSavedSaved(widget.index, value!),
            controller: emailController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.emailAddress,
            validator: emailValidator,
            style: textTheme.labelMedium?.copyWith(
                fontSize: FontSize.fontSize14,
                color: AppColors.appFormFieldTitle,
                fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              hintText: "${translate(LocalizationKeys.enterEmailOfGuest)!} ",
              fillColor: AppColors.appFormFieldFill,
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              hintStyle: textTheme.labelMedium?.copyWith(
                color: AppColors.formFieldHintText,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
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
          ),
          SizedBox(height: 10.h),
          Text(
            translate(LocalizationKeys.bookingWillSentToEmail) ?? "",
            style: textTheme.bodySmall?.copyWith(
              fontSize: FontSize.fontSize12,
              color: AppColors.colorPrimary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
