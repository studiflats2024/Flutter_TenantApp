import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'square_circle_loading_widget.dart';

class FullScreenLoaderWidget extends StatelessWidget {
  final String? message;
  final String? lottieFile;

  const FullScreenLoaderWidget({Key? key, this.message, this.lottieFile})
      : super(key: key);

  factory FullScreenLoaderWidget.onlyAnimation() {
    return const FullScreenLoaderWidget();
  }

  factory FullScreenLoaderWidget.withLottieFile(String txt, String lottie) {
    return FullScreenLoaderWidget(
      message: txt,
      lottieFile: lottie,
    );
  }

  factory FullScreenLoaderWidget.message(String message) {
    return FullScreenLoaderWidget(message: message);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      color: theme.primaryColor.withOpacity(0.86),
      child: Center(
          child: lottieFile != null
              ? lottieWithLoading(theme.cardColor)
              : message != null
                  ? txtWithLoading(theme.cardColor)
                  : flashLoading(theme.cardColor)),
    );
  }

  Widget flashLoading(Color color) => SquareCircleLoadingWidget(color: color);

  Widget txtWithLoading(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        flashLoading(color),
        const SizedBox(width: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Text(message!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: color)),
        )
      ],
    );
  }

  Widget lottieWithLoading(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(lottieFile!),
        const SizedBox(width: 20),
        Text(message!, style: TextStyle(fontSize: 20, color: color))
      ],
    );
  }
}
