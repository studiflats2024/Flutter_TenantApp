import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vivas/res/app_icons.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final BoxFit? boxFit;
  final String? title;
  final double borderRadius;
  final double fontSize;

  const AppCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.placeholder,
    this.title,
    this.width,
    this.height,
    this.boxFit,
    this.borderRadius = 0,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: (imageUrl.split(".").last.toLowerCase() == "pdf")
              ? _pdfPreview(context)
              : CachedNetworkImage(
                  height: height,
                  width: width,
                  imageUrl: imageUrl,
                  fit: boxFit,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) =>
                      placeholder ?? const Icon(Icons.error),
                ),
        ),
        Visibility(
            visible: title != null,
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.r),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    title ?? "",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )))
      ],
    );
  }

//
  Widget _pdfPreview(BuildContext context) {
    return InkWell(
      onTap: () => _openPdfFile(context),
      child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.pdfIcon,
                width: 50.r,
                height: 50.r,
              ),
              SizedBox(
                height: 10.r,
              ),
              Text(
                imageUrl.split("/").last,
                style: TextStyle(
                    fontSize: fontSize,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  Future<void> _openPdfFile(BuildContext context) async {
    try {
      if (await canLaunchUrlString(imageUrl)) {
        await launchUrlString(imageUrl, mode: LaunchMode.externalApplication);
      } else {
        // ignore: use_build_context_synchronously
        showFeedbackMessage(AppLocalizations.of(context)!
            .translate(LocalizationKeys.unableToOpenLink)!);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showFeedbackMessage(AppLocalizations.of(context)!
          .translate(LocalizationKeys.unableToOpenLink)!);
    }
  }
}

class AppCachedNetworkImageProvider extends CachedNetworkImageProvider {
  final String imageUrl;

  const AppCachedNetworkImageProvider({
    required this.imageUrl,
    int? maxHeight,
    int? maxWidth,
  }) : super(
          imageUrl,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
        );
}
