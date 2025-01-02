import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

// ignore: must_be_immutable
class CheckInDetailsSectionWithImageWidget extends BaseStatelessWidget {
  final List<String> imageUrl;
  final String? value;
  final String title;
  CheckInDetailsSectionWithImageWidget({
    required this.title,
    required this.imageUrl,
    required this.value,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF344054),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        if (!value.isNullOrEmpty) ...[
          Text(
            value!,
            style: const TextStyle(color: Color(0xFF605D62), fontSize: 15),
          ),
          SizedBox(height: 8.h),
        ],
        ...imageUrl
            .map((e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCachedNetworkImage(
                      imageUrl: e,
                      width: width,
                      borderRadius: 10.r,
                      boxFit: BoxFit.fitWidth,
                    ),
                    SizedBox(height: 8.h),
                  ],
                ))
            .toList(),
        const Divider(height: 4, color: Color.fromARGB(255, 198, 199, 200)),
      ],
    );
  }
}
