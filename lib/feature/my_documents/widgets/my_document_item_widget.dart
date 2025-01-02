import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/my_documents/document_api_model.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class MyDocumentItemWidget extends BaseStatelessWidget {
  final DocumentApiModel documentApiModel;
  MyDocumentItemWidget({
    super.key,
    required this.documentApiModel,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(),
          SizedBox(height: 10.h),
          _dateWidget(),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate(LocalizationKeys.rentPrice)!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF344053),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '€${documentApiModel.rentPrice}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF0F1728),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          SizedBox(height: 10.h),
          InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: _downloadClicked,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
                decoration: ShapeDecoration(
                  color: const Color(0xFFEAEEF3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download,
                      color: Color(0xFF2D4568),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      translate(LocalizationKeys.downloadContract)!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF2D4568),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      documentApiModel.aptName!,
      style: const TextStyle(
        color: Color(0xFF1B1B2F),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
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
                AppDateFormat.formattingMonthDay(documentApiModel.invStartDate,
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
          margin: EdgeInsets.symmetric(horizontal: 20.w),
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
                    documentApiModel.invEndDate, appLocale.locale.languageCode),
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

  Future<void> _downloadClicked() async {
    try {
      await launchUrlString(documentApiModel.downloadUrl!,
          mode: LaunchMode.externalApplication);
    } catch (e) {
      showFeedbackMessage(translate(LocalizationKeys.urlNotValid)!);
    }
  }
}
