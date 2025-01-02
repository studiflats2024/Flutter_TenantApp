import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class DateAndAgencyCode extends BaseStatelessWidget {
  final TextEditingController startDateController, endDateController;
  final Function(DateTime?) startDateSave, endDateSave;
  final Function(String?) agencyBrokerCodeSaved;
  final String? Function(DateTime?) dateTimeValidator;
  final DateTime maxDateInit, initialEndDate, startDateInit;
  final DateTime? startDate;

   DateAndAgencyCode({super.key,
    required this.startDateController,
    required this.endDateController,
    required this.startDateSave,
    required this.endDateSave,
    required this.agencyBrokerCodeSaved,
    required this.dateTimeValidator,
    required this.maxDateInit,
    required this.initialEndDate,
    required this.startDateInit,
    this.startDate,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: AppColors.cardColor,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate(LocalizationKeys.bookingDetails) ?? "",
              style: textTheme.labelMedium?.copyWith(
                fontSize: 18.spMin,
                color: AppColors.formFieldText,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(height: 1.h, color: AppColors.divider),
            SizedBox(
              height: 10.h,
            ),
            DatePickerFormFiledWidget(
              controller: startDateController,
              title: translate(LocalizationKeys.startDate)!,
              hintText: translate(LocalizationKeys.startDate),
              onSaved: startDateSave,
              validator: dateTimeValidator,
              maximumDate: maxDateInit,
              minimumDate: startDateInit,
              startDate: startDate,
            ),
            SizedBox(height: 10.h),
            DatePickerFormFiledWidget(
              controller: endDateController,
              title: translate(LocalizationKeys.endDate)!,
              hintText: translate(LocalizationKeys.endDate),
              onSaved: endDateSave,
              validator: dateTimeValidator,
              maximumDate: maxDateInit,
              minimumDate: initialEndDate,
              startDate: initialEndDate,
            ),
            SizedBox(height: 10.h),
            AppTextFormField(
              title: translate(LocalizationKeys.agencyBrokerCode)!,
              requiredTitle: false,
              hintText: translate(LocalizationKeys.eg100),
              onSaved: agencyBrokerCodeSaved,
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }
}
