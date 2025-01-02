import 'package:flutter/material.dart';
import 'package:vivas/feature/widgets/app_buttons/common_widgets.dart';

class AppOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? borderColor;
  final EdgeInsets? padding;

  const AppOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.borderColor,
  }) : super(key: key);

  factory AppOutlinedButton.withTitle({
    Key? key,
    VoidCallback? onPressed,
    EdgeInsets? padding,
    Color? textColor,
    Color? borderColor,
    required String title,
  }) {
    return AppOutlinedButton(
      key: key,
      onPressed: onPressed,
      padding: padding,
      borderColor: borderColor,
      child: labelTextWidget(title, textColor),
    );
  }
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(
              width: 0.50, color: borderColor ?? const Color(0xFFCFD4DC)),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        ),
        onPressed: onPressed,
        child: child);
  }
}
