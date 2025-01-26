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
  Function()? onBack;

  CustomAppBar({
    required this.title,
    required this.withBackButton,
    required this.centerTitle,
    this.leading,
    this.onBack,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return child;
  }

  @override
  Widget get child {
    return AppBar(
      centerTitle: true,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: AppColors.textWhite),
      leading: leading ?? (withBackButton
              ? TextButton(
                  onPressed: onBack,
                  child: SvgPicture.asset(
                    AppAssetPaths.backIcon,
                  ),
                )
              : null),
      title: TextApp(
        text: title,
        multiLang: true,
        fontWeight: FontWeight.w500,
        fontSize: SizeManager.sizeSp16,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
