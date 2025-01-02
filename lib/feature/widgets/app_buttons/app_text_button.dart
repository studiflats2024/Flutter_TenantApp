import 'package:flutter/material.dart';
import 'package:vivas/feature/widgets/app_buttons/common_widgets.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  final EdgeInsets? padding;

  const AppTextButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.padding,
  }) : super(key: key);

  factory AppTextButton.withTitle({
    Key? key,
    VoidCallback? onPressed,
    EdgeInsets? padding,
    Color? textColor,
    required String title,
  }) {
    return AppTextButton(
      key: key,
      padding: padding,
      onPressed: onPressed,
      child: labelTextWidget(title, textColor),
    );
  }
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        ),
        onPressed: onPressed,
        child: child);
  }
}
