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
  double? heightBar, leadingWidth;
  PreferredSizeWidget? bottom;
  Function()? onBack;
  List<Widget>? actions;
  Widget? flexibleSpace;
  Color? backgroundColor, iconColor, titleColor;
  SystemUiOverlayStyle? systemOverlayStyle;

  CustomAppBar({
    required this.title,
    required this.withBackButton,
    this.centerTitle = true,
    this.titleColor,
    this.multiLan = true,
    this.leading,
    this.onBack,
    this.bottom,
    this.heightBar,
    this.actions,
    this.flexibleSpace,
    this.leadingWidth,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.iconColor,
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
      flexibleSpace: flexibleSpace,
      backgroundColor: backgroundColor,
      actions: actions,
      systemOverlayStyle: systemOverlayStyle ??
          const SystemUiOverlayStyle(statusBarColor: AppColors.textWhite),
      leading: leading ??
          (withBackButton
              ? TextButton(
                  onPressed: onBack,
                  child: SvgPicture.asset(
                    AppAssetPaths.backIcon,
                    color: iconColor,
                  ),
                )
              : null),
      leadingWidth: leadingWidth,
      title: TextApp(
        text: title,
        multiLang: multiLan,
        color: titleColor,
        fontWeight: FontWeight.w500,
        fontSize: SizeManager.sizeSp16,
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(heightBar ?? kToolbarHeight);
}
