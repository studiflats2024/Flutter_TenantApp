import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/UploadPassportRequestModel/passport_request_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/guests_request_model.dart';
import 'package:vivas/feature/request_details/request_passport/widget/edit_tenant_widget.dart';
import 'package:vivas/feature/request_details/request_passport/widget/edit_tenant_widget_v2.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class TenantWidgetV2 extends BaseStatelessWidget {
  final PassportRequestModel guestsRequestModel;
  final bool canEdit;
  void Function(PassportRequestModel guestsRequestModel) afterEditCallBack;

  TenantWidgetV2({required this.guestsRequestModel,
    required this.afterEditCallBack,
    required this.canEdit,
    super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      width: double.infinity,
      height: 220,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: guestsRequestModel.isInValidData
                ? const Color(0xFFF6E7E7)
                : Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      guestsRequestModel.guestName,
                      style: const TextStyle(
                        color: Color(0xFF1B1B2F),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: SizeManager.sizeSp8,
                    ),
                    Text(
                      guestsRequestModel.status != null ? "(${guestsRequestModel
                          .status ?? ""})" : "",
                      style: const TextStyle(
                        color: Color(0xFF1B1B2F),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (canEdit)
                      GestureDetector(
                        onTap: () => _editTenantClicked(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          padding: const EdgeInsets.all(8),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE7EEF8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: SvgPicture.asset(AppAssetPaths.editIcon),
                        ),
                      ),
                  ],
                ),
                if (guestsRequestModel.isInValidData) ...[
                  Text(
                    guestsRequestModel.invalidReason ?? "",
                    style: const TextStyle(
                      color: Color(0xFFED2E38),
                      fontSize: 14,
                    ),
                  ),
                ]
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _editTenantClicked(context),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0x0F1151B4)),
                child: guestsRequestModel.passportImg != null
                    ? AppCachedNetworkImage(
                    imageUrl: guestsRequestModel.passportImg!)
                    : guestsRequestModel.passportImgRejected != null
                    ? AppCachedNetworkImage(
                    imageUrl: guestsRequestModel.passportImgRejected!)
                    : _noImage(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noImage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(AppAssetPaths.addImage),
        const SizedBox(height: 16),
        Text(
          translate(LocalizationKeys.clickToUploadImage)!,
          style: const TextStyle(
            color: Color(0xFF1D2838),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _editTenantClicked(BuildContext context) {
    print(guestsRequestModel.status);
    if (guestsRequestModel.status == "Approved" ||
        guestsRequestModel.status == "InReview") {} else {
      AppBottomSheet.openAppBottomSheet(
          context: context,
          child: EditTenantWidgetV2(
            saveCallBack: (tenantModel) {
              afterEditCallBack(tenantModel);
            },
            guestsRequestModel: guestsRequestModel,
          ),
          title: translate(LocalizationKeys.editTenant)!);
    }
  }
}
