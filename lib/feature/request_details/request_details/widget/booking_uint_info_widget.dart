import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class BookingUintInfoWidget extends BaseStatelessWidget {
  BookingUintInfoWidget({
    required this.title,
    required this.address,
    required this.imageUrl,
    required this.aptBedrooms,
    required this.aptMaxGuest,
    required this.cardClickCallback,
    super.key,
  });
  final Function() cardClickCallback;
  final String title;
  final String address;
  final String imageUrl;
  final int aptBedrooms;
  final int aptMaxGuest;

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
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
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => cardClickCallback(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageWidget(),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  _titleWidget(),
                  SizedBox(height: 5.h),
                  _locationWidget(),
                  SizedBox(height: 10.h),
                  _specificationsWidget(),
                ],
              ),
            ),
            SizedBox(width: 5.w),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return SizedBox(
      height: 100.h,
      width: 130.w,
      child: ClipRRect(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10.r),
          bottomStart: Radius.circular(10.r),
        ),
        child: AppCachedNetworkImage(
          imageUrl: imageUrl,
          boxFit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF1B1B2F),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _locationWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(AppAssetPaths.unitLocationIcon),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF475466),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _specificationsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _specificationItemWidget(
            "$aptBedrooms ${translate(LocalizationKeys.room)}",
            AppAssetPaths.unitBedroomIcon),
        _specificationItemWidget(
            "$aptMaxGuest ${translate(LocalizationKeys.person)}",
            AppAssetPaths.unitPersonIcon),
      ],
    );
  }

  Widget _specificationItemWidget(String title, String imagePath) {
    return Row(
      children: [
        SvgPicture.asset(imagePath),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF7D7F88),
            fontSize: 16.spMin,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
