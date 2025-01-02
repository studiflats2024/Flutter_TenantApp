import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';

class AppBackButton extends StatelessWidget {
  final Color? iconColor;
  final Color? backgroundColor;
  const AppBackButton({super.key, this.iconColor, this.backgroundColor});

  factory AppBackButton.auth() {
    return const AppBackButton(
      backgroundColor: Color(0x99EAECF0),
      iconColor: Color(0xFF344054),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (ModalRoute.of(context)?.impliesAppBarDismissal ?? false)
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                width: 32.w,
                height: 32.h,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: backgroundColor ?? const Color(0xFFF8F9FB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: iconColor ?? const Color(0xFF101828),
                )),
          )
        : const EmptyWidget();
  }
}
