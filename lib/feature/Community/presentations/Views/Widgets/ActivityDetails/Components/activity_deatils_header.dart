import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/size_manager.dart';

//ignore: must_be_immutable
class ActivityDetailsHeader extends BaseStatelessWidget
    implements PreferredSize {

  Function() onBack;

  ActivityDetailsHeader({required this.onBack ,super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return child;
  }

  @override
  Widget get child => CustomAppBar(
    title: "",
    multiLan: false,
    withBackButton: false,
    backgroundColor: Colors.transparent,
    leading: Padding(
      padding: EdgeInsets.all(SizeManager.sizeSp8),
      child: InkWell(
        onTap: onBack,
        child: CircleAvatar(
          backgroundColor: AppColors.textWhite,
          radius: SizeManager.sizeSp24,
          child: SvgPicture.asset(
            AppAssetPaths.backIcon,
          ),
        ),
      ),
    ),
    systemOverlayStyle:
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    leadingWidth: 60.r,
    // actions: [
    //   CircleAvatar(
    //     backgroundColor: AppColors.textWhite,
    //     child: SvgPicture.asset(AppAssetPaths.communityShareIcon),
    //   ),
    //   SizedBox(
    //     width: SizeManager.sizeSp8,
    //   ),
    //   CircleAvatar(
    //     backgroundColor: AppColors.textWhite,
    //     child: SvgPicture.asset(AppAssetPaths.communityFav),
    //   ),
    //   SizedBox(
    //     width: SizeManager.sizeSp16,
    //   ),
    // ],
  );

  @override
  Size get preferredSize => Size.fromHeight(200.r);
}
