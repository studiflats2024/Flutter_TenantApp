import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/apis/models/apartments/apartment_details/unit_details_api_model.dart';
import 'package:vivas/app_route.dart';
import 'package:vivas/feature/add_or_remove_bookmark/widgets/wish_icon_button.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/res/app_asset_paths.dart';

class DetailsHeaderActionWidget extends StatefulWidget {
  final UnitDetailsApiModel unitDetailsApiModel;
  final Function(UnitDetailsApiModel model) shareClicked;

  const DetailsHeaderActionWidget({
    super.key,
    required this.unitDetailsApiModel,
    required this.shareClicked,
  });

  @override
  State<DetailsHeaderActionWidget> createState() =>
      _DetailsHeaderActionWidgetState();
}

class _DetailsHeaderActionWidgetState extends State<DetailsHeaderActionWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _itemWidget(
            assetPaths: AppAssetPaths.arrowBackIcon,
            onTap: () {
              Navigator.of(context).pop();
            }),
        const Spacer(),
        /* _itemWidget(
          assetPaths: AppAssetPaths.shareIcon,
          onTap: () => widget.shareClicked(widget.unitDetailsApiModel),
        ), */
        SizedBox(width: 10.w),
        WishIconButton(
          uuid: widget.unitDetailsApiModel.generalInfo.aptUuid,
          isWish: widget.unitDetailsApiModel.isWishlist,
        )
      ],
    );
  }

  Widget _itemWidget(
      {required String assetPaths, required void Function() onTap}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: InkWell(
        radius: 100,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(5.h),
          child: SvgPicture.asset(assetPaths),
        ),
      ),
    );
  }
}

class DetailsHeaderActionWidgetV2 extends StatefulWidget {
  final ApartmentDetailsApiModelV2 unitDetailsApiModel;
  final Function(ApartmentDetailsApiModelV2 model) shareClicked;
  final Function() onBack;

  const DetailsHeaderActionWidgetV2({
    super.key,
    required this.unitDetailsApiModel,
    required this.shareClicked,
    required this.onBack,
  });

  @override
  State<DetailsHeaderActionWidgetV2> createState() =>
      _DetailsHeaderActionWidgetStateV2();
}

class _DetailsHeaderActionWidgetStateV2
    extends State<DetailsHeaderActionWidgetV2> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _itemWidget(
            assetPaths: AppAssetPaths.arrowBackIcon,
            onTap: widget.onBack),
        const Spacer(),
        _itemWidget(
          assetPaths: AppAssetPaths.shareIcon,
          onTap: () => widget.shareClicked(widget.unitDetailsApiModel),
        ),
        SizedBox(width: 10.w),
        WishIconButton(
          uuid: widget.unitDetailsApiModel.apartmentId ?? "",
          isWish: widget.unitDetailsApiModel.isWishlist,
        )
      ],
    );
  }

  Widget _itemWidget(
      {required String assetPaths, required void Function() onTap}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: InkWell(
        radius: 100,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(5.h),
          child: SvgPicture.asset(assetPaths),
        ),
      ),
    );
  }
}
