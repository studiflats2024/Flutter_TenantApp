import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/apartments/apartment_list/apartment_item_api_model.dart';
import 'package:vivas/feature/add_or_remove_bookmark/widgets/wish_icon_button.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../res/app_colors.dart';

class UintWidget extends BaseStatefulWidget {
  const UintWidget({
    required this.apartmentItemApiModel,
    required this.cardClickCallback,
    super.key,
  });

  final Function(ApartmentItemApiModel model) cardClickCallback;
  final ApartmentItemApiModel apartmentItemApiModel;

  @override
  BaseState<UintWidget> baseCreateState() => _UintWidgetState();
}

class _UintWidgetState extends BaseState<UintWidget> {
  @override
  Widget baseBuild(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.black.withOpacity(0.8),
      elevation: 10,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => widget.cardClickCallback(widget.apartmentItemApiModel),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerWidget(),
              Padding(
                padding: EdgeInsets.all(16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleRateWidget(),
                    SizedBox(height: 5.h),
                    _locationWidget(),
                    SizedBox(height: 10.h),
                    _specificationsWidget(),
                    SizedBox(height: 20.h),
                    _priceWidget(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return SizedBox(
      height: 289.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
            child: AppCachedNetworkImage(
              imageUrl: widget.apartmentItemApiModel.aptThumbImg,
              boxFit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          PositionedDirectional(
            end: 20,
            top: 13,
            child: WishIconButton(
              uuid: widget.apartmentItemApiModel.aptUuid,
              isWish: widget.apartmentItemApiModel.isWishlist,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleRateWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.apartmentItemApiModel.aptName,
            style: const TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        // SvgPicture.asset(AppAssetPaths.starIcon),
        // SizedBox(width: 10.w),
        // Text(
        //   widget.apartmentItemApiModel.rate.toString(),
        //   style: const TextStyle(
        //     color: Color(0xFF0F0F0F),
        //     fontSize: 16,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
      ],
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
            widget.apartmentItemApiModel.aptArea,
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
            widget.apartmentItemApiModel.isApartment
                ? "${widget.apartmentItemApiModel.aptBedrooms} ${translate(LocalizationKeys.room)}"
                : widget.apartmentItemApiModel.aptTypes,
            AppAssetPaths.unitBedroomIcon),
        _specificationItemWidget(
            "${widget.apartmentItemApiModel.aptMaxGuest} ${translate(LocalizationKeys.person)}",
            AppAssetPaths.unitPersonIcon),
        _specificationItemWidget(
            "${widget.apartmentItemApiModel.aptSquareMeters.toInt()} ${translate(LocalizationKeys.m2)}",
            AppAssetPaths.unitHomeIcon),
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

  Widget _priceWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                '€ ${widget.apartmentItemApiModel.aptPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: const Color(0xFF1151B4),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' /${translate(LocalizationKeys.month)}',
                style: TextStyle(
                  color: const Color(0xFF878787),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible:
          widget.apartmentItemApiModel.availableBeds != widget.apartmentItemApiModel.aptMaxGuest,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 8.0.w, vertical: 5.h),
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              color: AppColors.colorPrimary.withOpacity(.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Beds left: ${widget.apartmentItemApiModel.availableBeds}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UintWidgetV2 extends BaseStatefulWidget {
  const UintWidgetV2({
    required this.apartmentItemApiV2Model,
    required this.cardClickCallback,
    super.key,
  });

  final Function(ApartmentItemApiV2Model model) cardClickCallback;
  final ApartmentItemApiV2Model apartmentItemApiV2Model;

  @override
  BaseState<UintWidgetV2> baseCreateState() => _UintWidgetStateV2();
}

class _UintWidgetStateV2 extends BaseState<UintWidgetV2> {
  @override
  Widget baseBuild(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.black.withOpacity(0.8),
      elevation: 10,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => widget.cardClickCallback(widget.apartmentItemApiV2Model),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerWidget(),
              Padding(
                padding: EdgeInsets.all(16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleRateWidget(),
                    SizedBox(height: 5.h),
                    _locationWidget(),
                    SizedBox(height: 10.h),
                    _specificationsWidget(),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Visibility(
                        visible: widget
                            .apartmentItemApiV2Model.apartmentSharedType !=
                            null &&
                            widget.apartmentItemApiV2Model.apartmentSharedType
                        == 'Shared Apartment',
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0.w , vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC5C2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              widget.apartmentItemApiV2Model.apartmentSharedType ??
                                  '',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffB3261E)),
                            ),
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible:
                      //   widget.apartmentItemApiV2Model.apartmentAvailableBeds != widget.apartmentItemApiV2Model.apartmentPersonsNo,
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 8.0.w, vertical: 5.h),
                      //     margin: EdgeInsets.symmetric(horizontal: 5.w),
                      //     decoration: BoxDecoration(
                      //       color: AppColors.colorPrimary.withOpacity(.2),
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         " Beds left: ${widget.apartmentItemApiV2Model.apartmentAvailableBeds}",
                      //         style: const TextStyle(
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.w500,
                      //             color: AppColors.colorPrimary),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],),
                    SizedBox(height: 20.h),
                    _priceWidget(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return SizedBox(
      height: 289.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
            child: AppCachedNetworkImage(
              imageUrl: widget.apartmentItemApiV2Model.apartmentImage ?? '',
              boxFit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          PositionedDirectional(
            end: 20,
            top: 13,
            child: WishIconButton(
              uuid: widget.apartmentItemApiV2Model.apartmentId ?? "",
              isWish: widget.apartmentItemApiV2Model.isWishlist,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleRateWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.apartmentItemApiV2Model.apartmentName ?? '',
            style: TextStyle(
              color: const Color(0xFF0F0F0F),
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        //TODO::Rate Not Added To Response
        // SvgPicture.asset(AppAssetPaths.starIcon),
        // SizedBox(width: 10.w),
        // Text(
        //   widget.apartmentItemApiV2Model.rate.toString(),
        //   style: const TextStyle(
        //     color: Color(0xFF0F0F0F),
        //     fontSize: 16,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
      ],
    );
  }

  Widget _locationWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 15.w,
          height: 15.h,
          child: SvgPicture.asset(
            AppAssetPaths.unitLocationIcon,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            "${widget.apartmentItemApiV2Model.apartmentLocation?.split(",")[3] ?? ""},${widget.apartmentItemApiV2Model.apartmentLocation?.split(",")[2] ?? ""}",
            style: TextStyle(
              color: const Color(0xFF475466),
              fontSize: 12.sp,
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
            widget.apartmentItemApiV2Model.isApartment
                ? "${widget.apartmentItemApiV2Model.apartmentNoBedrooms} ${translate(LocalizationKeys.room)}"
                : widget.apartmentItemApiV2Model.apartmentType ?? '',
            AppAssetPaths.unitBedroomIcon),
        _specificationItemWidget(
            "${widget.apartmentItemApiV2Model.apartmentPersonsNo} ${translate(LocalizationKeys.person)}",
            AppAssetPaths.unitPersonIcon),
        _specificationItemWidget(
            "${widget.apartmentItemApiV2Model.apartmentAreaSquare} ${translate(LocalizationKeys.m2)}",
            AppAssetPaths.unitHomeIcon),
      ],
    );
  }

  Widget _specificationItemWidget(String title, String imagePath) {
    return Row(

      children: [
        Stack(children: [
          SvgPicture.asset(imagePath , height: 20.h, width: 20.w,),
        ],),

        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF7D7F88),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _priceWidget() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                '€ ${widget.apartmentItemApiV2Model.apartmentPrice?.toStringAsFixed(2)}',
            style: TextStyle(
              color: const Color(0xFF1151B4),
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: ' /${translate(LocalizationKeys.month)}',
            style: TextStyle(
              color: const Color(0xFF878787),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
