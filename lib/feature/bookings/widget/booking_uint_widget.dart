import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class BookingUintWidget extends BaseStatefulWidget {
  const BookingUintWidget({
    required this.apartmentBookingModel,
    required this.cardClickCallback,
    super.key,
  });
  final Function(ApartmentRequestsApiModel model) cardClickCallback;
  final ApartmentRequestsApiModel apartmentBookingModel;

  @override
  BaseState<BookingUintWidget> baseCreateState() => _UintWidgetState();
}

class _UintWidgetState extends BaseState<BookingUintWidget> {
  @override
  Widget baseBuild(BuildContext context) {
    return Container(
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
        onTap: () => widget.cardClickCallback(widget.apartmentBookingModel),
        child: Row(
          children: [
            _imageWidget(),
            SizedBox(width: 5.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleWidget(),
                      SizedBox(height: 5.h),
                      _locationWidget(),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(child: _dateWidget()),
                        ],
                      ),
                    ],
                  )
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
      height: 116.h,
      width: 100.w,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(10.r),
              bottomStart: Radius.circular(10.r),
            ),
            child: AppCachedNetworkImage(
              imageUrl: widget.apartmentBookingModel.thumbImg,
              boxFit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          PositionedDirectional(
              top: 10.h,
              start: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                child: Text(
                  widget.apartmentBookingModel.requestStatus,
                  style: const TextStyle(
                    color: Color(0xFF1151B4),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      widget.apartmentBookingModel.aptName,
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
            widget.apartmentBookingModel.aptAddress,
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

  Widget _dateWidget() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.checkIn)!,
                style: const TextStyle(
                  color: Color(0xFF667084),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                AppDateFormat.formattingMonthDay(
                    widget.apartmentBookingModel.startDate,
                    appLocale.locale.languageCode),
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFF344053),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        Container(
          width: 1,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          height: 40,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.checkOut)!,
                style: const TextStyle(
                  color: Color(0xFF667084),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                AppDateFormat.formattingMonthDay(
                    widget.apartmentBookingModel.endDate,
                    appLocale.locale.languageCode),
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFF344053),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
