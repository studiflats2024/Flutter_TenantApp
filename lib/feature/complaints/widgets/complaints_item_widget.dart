import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/complaint/list/complaint_api_model.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/divider/divider_horizontal_widget.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class ComplaintItemWidget extends BaseStatelessWidget {
  final ComplaintApiModel complaintApiModel;
  final VoidCallback seeDetailsClickCallBack;
  ComplaintItemWidget({
    super.key,
    required this.complaintApiModel,
    required this.seeDetailsClickCallBack,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 20,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _numberTypeWidget(),
            SizedBox(height: 10.h),
            Container(
              color: Colors.grey,
              height: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              complaintApiModel.ticketDesc.concatenateNewline,
              textAlign: TextAlign.start,
              maxLines: 2,
              style: const TextStyle(
                color: Color(0xFF676767),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10.h),
            const DividerHorizontalWidget(),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppTextButton(
                  onPressed: seeDetailsClickCallBack,
                  padding: EdgeInsets.zero,
                  child: Text(
                    translate(LocalizationKeys.seeDetails)!,
                    style: const TextStyle(
                      color: Color(0xFF1151B4),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _numberTypeWidget() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.ticketNumber)!,
                style: const TextStyle(
                  color: Color(0xFF6B6B6B),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                complaintApiModel.ticketCode,
                maxLines: 1,
                style: const TextStyle(
                    color: Color(0xFF313131),
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                translate(LocalizationKeys.typeOfComplaint)!,
                style: const TextStyle(
                  color: Color(0xFF6B6B6B),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                complaintApiModel.ticketType,
                maxLines: 1,
                style: const TextStyle(
                    color: Color(0xFF313131),
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ],
    );
  }
}
