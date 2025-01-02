import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';

//ignore:must_be_immutable
class BaseBottomSheetWidget extends BaseStatelessWidget {
  BaseBottomSheetWidget({
    Key? key,
    required this.child,
    required this.title,
    this.onCloseCallBack,
  }) : super(key: key);
  final Widget child;
  final String title;
  final VoidCallback? onCloseCallBack;
  @override
  Widget baseBuild(BuildContext context) {
    return SizedBox(
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF0F0F0F),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: InkWell(
                          onTap: () => _closeClicked(context),
                          child: SvgPicture.asset(AppAssetPaths.closeIcon)),
                    ),
                  ],
                ),
                SingleChildScrollView(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _closeClicked(BuildContext context) {
    Navigator.of(context).pop();
    if (onCloseCallBack != null) {
      onCloseCallBack!();
    }
  }
}
