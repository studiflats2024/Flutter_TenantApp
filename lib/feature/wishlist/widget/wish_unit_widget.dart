import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/apartments/wish_list/wish_item_api_model.dart';
import 'package:vivas/feature/add_or_remove_bookmark/widgets/wish_icon_button.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class WishUintWidget extends BaseStatefulWidget {
  const WishUintWidget({
    required this.wishItemApiModel,
    required this.cardClickCallback,
    super.key,
  });
  final void Function(WishItemApiModel model) cardClickCallback;

  final WishItemApiModel wishItemApiModel;

  @override
  BaseState<WishUintWidget> baseCreateState() => _UintWidgetState();
}

class _UintWidgetState extends BaseState<WishUintWidget> {
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
        onTap: () => widget.cardClickCallback(widget.wishItemApiModel),
        child: Row(
          children: [
            _imageWidget(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
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
                          Expanded(child: _priceWidget()),
                          _addFavWidget()
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return SizedBox(
      height: 116.h,
      width: 100.w,
      child: ClipRRect(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10.r),
          bottomStart: Radius.circular(10.r),
        ),
        child: AppCachedNetworkImage(
          imageUrl: widget.wishItemApiModel.aptThumbImg,
          boxFit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      widget.wishItemApiModel.aptName,
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
            widget.wishItemApiModel.aptAddress,
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

  Widget _priceWidget() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '€ ${widget.wishItemApiModel.aptPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF1151B4),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: ' /${translate(LocalizationKeys.month)}',
            style: const TextStyle(
              color: Color(0xFF878787),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addFavWidget() {
    return WishIconButton(
      uuid: widget.wishItemApiModel.aptUuid,
      isWish: widget.wishItemApiModel.isWishlist,
    );
  }
}
