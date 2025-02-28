import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart'
    show BaseStatelessWidget;
import 'package:vivas/feature/Community/presentations/Views/Widgets/InviteFrindes/invite_frindes.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MyActivities/my_activity.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MyPlan/my_plan.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/QrDetails/qr_details.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class CommunityHeader extends BaseStatelessWidget {
  bool isGuest;
  CommunityHeader(this.isGuest, {super.key,});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextApp(multiLang: true, text: LocalizationKeys.communityClub),
                SizedBox(
                  height: SizeManager.sizeSp4,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssetPaths.locationIcon,
                    ),
                    SizedBox(
                      width: SizeManager.sizeSp4,
                    ),
                    TextApp(
                      multiLang: false,
                      text: "Berlin , Germany",
                      style: textTheme.titleMedium?.copyWith(
                          color: AppColors.formFieldHintText,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              ],
            ),
            CircleAvatar(
              backgroundColor: AppColors.textWhite,
              radius: 25.r,
              child: SvgPicture.asset(
                AppAssetPaths.mapIcon,
                width: 25.r,
                height: 25.r,
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: AppColors.textWhite,
            //     border: Border.all(color: AppColors.placeholder.withOpacity(.5))
            //   ),
            //   width: 50.r,
            //   height: 50.r,
            //   padding: EdgeInsets.all(SizeManager.sizeSp8),
            //   child: SvgPicture.asset(
            //     AppAssetPaths.mapIcon,
            //
            //   ),
            // )
          ],
        ),
        SizedBox(
          height: SizeManager.sizeSp25,
        ),
        SizedBox(
          height: 120.r,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            shrinkWrap: true,
            children: [
              itemActions(
                  color: AppColors.colorPrimary,
                  asset: AppAssetPaths.qrIcon,
                  title: LocalizationKeys.qrCode,
                  multiLang: true,
                  action: () {
                    CommunityQrDetails.open(
                      context,
                      false,
                      false
                    );
                  },
                context: context,
              ),
              SizedBox(
                width: SizeManager.sizeSp16,
              ),
              itemActions(
                  color: AppColors.cardBorderGreen,
                  asset: AppAssetPaths.myActivityIcon,
                  title: LocalizationKeys.myActivity,
                  multiLang: true,
                  action: () {
                    MyActivities.open(context, false);
                  },
                context: context,
              ),
              SizedBox(
                width: SizeManager.sizeSp16,
              ),
              itemActions(
                color: AppColors.cardBorderGold,
                asset: AppAssetPaths.myPlanIcon,
                title: LocalizationKeys.myPlan,
                multiLang: true,
                action: () {
                  MyPlan.open(context, false);
                },
                context: context,
              ),
              SizedBox(
                width: SizeManager.sizeSp16,
              ),
              itemActions(
                color: AppColors.cardBorderBlue,
                asset: AppAssetPaths.inviteFriendsIcon,
                title: LocalizationKeys.inviteFriends,
                multiLang: true,
                action: () {
                  InviteFriends.open(context, false);
                }, context: context,
              ),
            ],
          ),
        ),
      ],
    );
  }

  itemActions(
      {required Color color,
      required String asset,
      required String title,
      required bool multiLang,
      required BuildContext context,
      required Function() action}) {
    return InkWell(
      onTap: (){
        if(isGuest){
          AppBottomSheet.showLoginOrRegisterDialog(context);
        }else{
          action();
        }
      },
      child: Container(
        width: 104.r,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x3FA1A1A1),
              blurRadius: 5,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
          color: AppColors.textWhite,
          border: Border(top: BorderSide(color: color, width: 2.r)),
          borderRadius: BorderRadius.all(
            SizeManager.circularRadius10,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(asset),
            SizedBox(
              height: SizeManager.sizeSp10,
            ),
            TextApp(
              multiLang: multiLang,
              text: title,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.formFieldText,
              ),
            )
          ],
        ),
      ),
    );
  }
}
