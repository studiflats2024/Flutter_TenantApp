import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class CommunityAbout extends BaseStatelessWidget {
  CommunityAbout({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeManager.sizeSp20,
        ),
        TextApp(multiLang: true, text: LocalizationKeys.aboutCommunityClub),
        SizedBox(
          height: SizeManager.sizeSp16,
        ),
        Stack(
          children: [
            Container(
              height: 200.r,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(SizeManager.circularRadius15),
                  image: const DecorationImage(
                      image: AssetImage(AppAssetPaths.aboutCommunity),
                      fit: BoxFit.cover)),
            ),
            Positioned(
              bottom: SizeManager.sizeSp10,
              left: SizeManager.sizeSp20,
              right: SizeManager.sizeSp20,
              child: Container(
                height: 70.r,
                padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp10),
                decoration: BoxDecoration(
                  color: AppColors.textWhite.withOpacity(.75),
                  borderRadius: BorderRadius.all(SizeManager.circularRadius10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          multiLang: true,
                          text: LocalizationKeys.communityClub,
                        ),
                        SizedBox(
                          height: SizeManager.sizeSp8,
                        ),
                        TextApp(
                          multiLang: true,
                          text: LocalizationKeys.aboutClub,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.formFieldHintText,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.colorPrimary,
                      child: SvgPicture.asset(AppAssetPaths.playIcon),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: SizeManager.sizeSp8,)
          ],
        ),
      ],
    );
  }
}
