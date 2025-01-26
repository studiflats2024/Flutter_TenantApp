// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

//ignore: must_be_immutable
class CheckOutItemWidget extends BaseStatelessWidget {
  final String title;
  final String description;
  final double price;
  final List<String>? images;
  final VoidCallback? downloadClickedCallBack;
  final bool? hasLink;
  CheckOutItemWidget(
    this.title,
    this.description,
    this.price,
    this.images,
    this.downloadClickedCallBack,
    this.hasLink, {
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFF5F5F5)),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 15,
              offset: Offset(0, 8),
              spreadRadius: 0,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                color: Color(0xFF605D62),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF484649),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            images!.isNotEmpty
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: SizedBox(
                height: 100.h,
                child: GalleryImage(
                  key: UniqueKey(),
                  imageUrls: images ?? [],
                  childAspectRatio: 1,
                  numOfShowImages:
                  images!.length > 3 ? 3 : images!.length,
                ),
              ),
            )
                : const SizedBox(),
            Row(
              children: [
                Text(
                  translate(LocalizationKeys.costOfProblem)!,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF605D62),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "$price €",
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF313033),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            hasLink!
                ? Padding(
              //if download url not null
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: _downloadButton(),
            )
                : SizedBox(height: 8.h)
          ],
        ),
      ),
    );
  }

  Widget _downloadButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: downloadClickedCallBack,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: const Color(0xFFEAEEF3),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssetPaths.downloadIcon),
              SizedBox(width: 10.w),
              Text(
                translate(LocalizationKeys.downloadAttachement)!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF2D4568),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
