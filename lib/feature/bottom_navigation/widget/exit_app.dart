import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/app_route.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ExitApp extends BaseStatelessWidget {
  Function() exitApp;

  ExitApp({required this.exitApp});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          AppAssetPaths.signOutIcon,
          color: AppColors.colorPrimary,
          width: 40.w,
          height: 40.h,
        ),
        SizedBox(
          height: 16.r,
        ),
        Text(
          translate(LocalizationKeys.exitAppMessage) ?? "",
          style: textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18.spMin),
        ),
        SizedBox(height: 20.r,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppElevatedButton.whiteWithTitle(
              onPressed: (){
                Navigator.of(context).pop();
              },
              title: translate(LocalizationKeys.no) ?? "",
              textColor: AppColors.formFieldText,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.appCancelButtonBackground) ,
                  minimumSize: MaterialStateProperty.resolveWith((states) => Size(140.w, 40.r))
              ),
            ),
            AppElevatedButton.withTitle(
              onPressed: exitApp,
              title: translate(LocalizationKeys.yes) ?? "",
              textColor: AppColors.textWhite,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.colorPrimary) ,
                minimumSize: MaterialStateProperty.resolveWith((states) => Size(140.w, 40.r))
              ),
            ),
          ],
        )
      ],
    );
  }


}
