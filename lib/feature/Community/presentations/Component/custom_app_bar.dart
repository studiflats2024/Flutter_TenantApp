import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class CustomAppBar extends BaseStatelessWidget implements PreferredSize {
  String title;
  bool withBackButton;
  Widget? leading;
  bool centerTitle;
  bool multiLan;
  double? heightBar;
  PreferredSizeWidget? bottom;
  Function()? onBack;

  CustomAppBar({
    required this.title,
    required this.withBackButton,
    this.centerTitle = true,
    this.multiLan = true,
    this.leading,
    this.onBack,
    this.bottom,
    this.heightBar,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return child;
  }

  @override
  Widget get child {
    return AppBar(
      centerTitle: centerTitle,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: AppColors.textWhite),
      leading: leading ??
          (withBackButton
              ? TextButton(
                  onPressed: onBack,
                  child: SvgPicture.asset(
                    AppAssetPaths.backIcon,

                  ),
                )
              : null),
      title: TextApp(
        text: title,
        multiLang: multiLan,
        fontWeight: FontWeight.w500,
        fontSize: SizeManager.sizeSp16,
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(heightBar ?? kToolbarHeight);
}
