import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/InviteFrindes/history_invitation.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_time_form_field_widget.dart';
import 'package:vivas/feature/widgets/text_field/phone_number_form_filed_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class InviteFriends extends BaseStatelessWidget {
  InviteFriends({super.key});

  static const routeName = '/invite-friends-community';

  static Future<void> open(
    BuildContext context,
    bool replacement,
  ) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(
        routeName,
      );
    } else {
      await Navigator.of(context).pushNamed(
        routeName,
      );
    }
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: AppColors.textWhite),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            AppAssetPaths.backIcon,
          ),
        ),
        title: TextApp(
          text: LocalizationKeys.inviteFriends,
          multiLang: true,
          fontWeight: FontWeight.w500,
          fontSize: SizeManager.sizeSp16,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(SizeManager.circularRadius10),
                border: Border.all(color: AppColors.cardBorderPrimary100)),
            margin: EdgeInsets.symmetric(vertical: SizeManager.sizeSp8),
            child: TextButton(
              onPressed: () {
                HistoryInviteFriends.open(context, false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppAssetPaths.messageIcon),
                      SizedBox(
                        width: SizeManager.sizeSp8,
                      ),
                      TextApp(
                        text:
                            "${translate(LocalizationKeys.inviteYouHave)}4${translate(LocalizationKeys.friendsLeft)}",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor,
                      )
                    ],
                  ),
                  SvgPicture.asset(AppAssetPaths.reInviteIcon)
                ],
              ),
            ),
          ),
          SizedBox(
            height: SizeManager.sizeSp16,
          ),
          Column(
            children: [
              SvgPicture.asset(AppAssetPaths.reInviteImage),
              SizedBox(
                height: SizeManager.sizeSp25,
              ),
              TextApp(
                text: translate(LocalizationKeys.invitationTitle) ?? "",
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textMainColor,
              ),
              SizedBox(
                height: SizeManager.sizeSp4,
              ),
              SizedBox(
                width: 250.r,
                child: TextApp(
                  text: translate(LocalizationKeys.invitationDescription) ?? "",
                  textAlign: TextAlign.center,
                  fontSize: 12.sp,
                  lineHeight: 1.2,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textNatural700,
                ),
              ),
              SizedBox(
                height: SizeManager.sizeSp32,
              ),
              Form(
                child: Column(
                  children: [
                    AppTextFormField(
                        title: translate(LocalizationKeys.friendsName) ?? "",
                        hintText:
                            translate(LocalizationKeys.friendsNameHint) ?? "",
                        prefix: SvgPicture.asset(
                          AppAssetPaths.personIconForm,
                          fit: BoxFit.none,
                        ),
                        focusColor: AppColors.cardBorderPrimary100,
                        enableBorderColor: AppColors.cardBorderPrimary100,
                        titleStyle: textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.textMainColor,
                            fontWeight: FontWeight.w500),
                        hintStyle: textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.textNatural700,
                            fontWeight: FontWeight.w400),
                        onSaved: (v) {}),
                    SizedBox(
                      height: SizeManager.sizeSp24,
                    ),
                    AppTextFormField(
                        title: translate(LocalizationKeys.friendsEmail) ?? "",
                        hintText:
                            translate(LocalizationKeys.friendsEmailHint) ?? "",
                        hintStyle: textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.textNatural700,
                            fontWeight: FontWeight.w400),
                        focusColor: AppColors.cardBorderPrimary100,
                        enableBorderColor: AppColors.cardBorderPrimary100,
                        titleStyle: textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.textMainColor,
                            fontWeight: FontWeight.w500),
                        prefix: SizedBox(
                          child: SvgPicture.asset(
                            AppAssetPaths.messageIconOutline,
                            fit: BoxFit.none,
                          ),
                        ),
                        onSaved: (v) {}),
                    SizedBox(
                      height: SizeManager.sizeSp24,
                    ),
                    PhoneNumberFormFiledWidget(
                      onSaved: (v) {},
                      title: translate(LocalizationKeys.friendsPhone) ?? "",
                      focusColor: AppColors.cardBorderPrimary100,
                      enableBorderColor: AppColors.cardBorderPrimary100,
                      titleStyle: textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textMainColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: SizeManager.sizeSp24,
                    ),
                    DateTimeFormFieldWidget(
                      title: translate(LocalizationKeys.invitationDate) ?? "",
                      hintText:
                          translate(LocalizationKeys.invitationDateHint) ?? "",
                      borderColor: AppColors.cardBorderPrimary100,
                      hintStyle: textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.textNatural700,
                          fontWeight: FontWeight.w400),
                      titleStyle: textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textMainColor,
                          fontWeight: FontWeight.w500),
                      iconStart: true,
                      onSaved: (v) {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeManager.sizeSp24,
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 120.r,
        color: AppColors.textWhite,
        child: Column(
          children: [
            SubmitButtonWidget(
              title: translate(LocalizationKeys.sendInvitations) ?? "",
              titleStyle: textTheme.bodyMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textWhite),
              shadows: const [
                BoxShadow(
                  color: Color(0x3FA1A1A1),
                  blurRadius: 5,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
              hint: translate(LocalizationKeys.sendInvitationsHint) ?? "",
              onClicked: () {},
            ),
          ],
        ),
      ),
    );
  }
}
