import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_time_form_field_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class HistoryInviteFriends extends BaseStatelessWidget {
  HistoryInviteFriends({super.key});

  static const routeName = '/invitation-history-community';

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
          text: LocalizationKeys.historyInvitation,
          multiLang: true,
          fontWeight: FontWeight.w500,
          fontSize:   SizeManager.sizeSp16,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: SizeManager.sizeSp16),
        child: ListView.separated(
          itemCount: 5,
          itemBuilder: (context, index) {
            return itemHistory(context);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: SizeManager.sizeSp16,
            );
          },
        ),
      ),
    );
  }

  Widget itemHistory(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.cardBorderPrimary100),
          borderRadius: BorderRadius.all(SizeManager.circularRadius10)),
      margin: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
      child: Padding(
        padding: EdgeInsets.all(SizeManager.sizeSp16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: SizeManager.sizeSp25,
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      const AssetImage(AppAssetPaths.profileDefaultAvatar),
                ),
                SizedBox(
                  width: SizeManager.sizeSp15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp(
                      text: "Sara Mohamed",
                      fontSize: 12.sp,
                    ),
                    SizedBox(
                      height: SizeManager.sizeSp4,
                    ),
                    TextApp(
                      text: "Sara.Mhmd@gmail.com",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textNatural700,
                    ),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PopupMenuButton(
                  constraints: BoxConstraints(minWidth: 275.r),
                  icon: SvgPicture.asset(AppAssetPaths.menuIcon),
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      height: SizeManager.sizeSp32,
                      value: "invite_again",

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            multiLang: true,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            text: LocalizationKeys.inviteAgain,
                          ),
                          SvgPicture.asset(
                            AppAssetPaths.messageIcon,
                            color: AppColors.colorPrimary,
                            fit: BoxFit.none,

                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                        height: SizeManager.sizeSp4, child: const Divider()),
                    PopupMenuItem(
                      value: "reminder",
                      height: SizeManager.sizeSp32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            multiLang: true,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            text: LocalizationKeys.reminder,
                          ),
                          SvgPicture.asset(
                            AppAssetPaths.reminderIcon,
                            color: AppColors.colorPrimary,
                          )
                        ],
                      ),
                    )
                  ],
                  onSelected: (value) {
                    if (value == "invite_again") {
                      AppBottomSheet.openBaseBottomSheet(
                        context: context,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeManager.sizeSp16),
                          height: 200.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DateTimeFormFieldWidget(
                                title: translate(
                                        LocalizationKeys.invitationDate) ??
                                    "",
                                hintText: translate(
                                        LocalizationKeys.invitationDateHint) ??
                                    "",
                                hintStyle: textTheme.bodyMedium?.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.textNatural700,
                                    fontWeight: FontWeight.w400),
                                iconStart: true,
                                onSaved: (v) {},
                              ),
                              SizedBox(height: SizeManager.sizeSp16,),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 160.r,
                                    child: SubmitButtonWidget(
                                        withoutShape: true,
                                        withoutCustomShape: true,
                                        padding: EdgeInsets.zero,
                                        sizeTop: 0,
                                        sizeBottom: 0,
                                        title: translate(
                                                LocalizationKeys.cancel) ??
                                            "",
                                        buttonColor: AppColors.textWhite,
                                        titleStyle: textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.colorPrimary),
                                        outlinedBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              SizeManager.circularRadius10),
                                          side: const BorderSide(color: AppColors.colorPrimary,)
                                        ),
                                        onClicked: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                  SizedBox(
                                    width: 160.r,
                                    child: SubmitButtonWidget(
                                        title:
                                            translate(LocalizationKeys.send) ??
                                                "",
                                        withoutShape: true,
                                        padding: EdgeInsets.zero,
                                        sizeTop: 0,
                                        sizeBottom: 0,
                                        onClicked: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(SizeManager.circularRadius10)),
                ),
                TextApp(
                  text: "14 Feb 2024",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textNatural700,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
