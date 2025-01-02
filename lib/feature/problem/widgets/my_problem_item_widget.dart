import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/my_problems/problem_api_model.dart';
import 'package:vivas/feature/problem/widgets/problem_status_widget.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/read_more_text_widget/read_more_text_widget.dart';

// ignore: must_be_immutable
class MyProblemItemWidget extends BaseStatelessWidget {
  final ProblemApiModel problemApiModel;
  final void Function(ProblemApiModel) cardClickCallback;
  MyProblemItemWidget(
      {super.key,
      required this.problemApiModel,
      required this.cardClickCallback});

  @override
  Widget baseBuild(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => cardClickCallback(problemApiModel),
      child: Container(
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
            _dateNumberWidget(),
            SizedBox(height: 10.h),
            if (!problemApiModel.resolveDescription.isNullOrEmpty) ...[
              _resolveDescriptionWidget(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            problemApiModel.aptName,
            style: const TextStyle(
              color: Color(0xFF1B1B2F),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 4),
        ProblemStatusWidget(
          statusString: problemApiModel.statusString,
          statusKey: problemApiModel.statusKey,
        ),
      ],
    );
  }

  Widget _dateNumberWidget() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.problemId)!,
                style: const TextStyle(
                  color: Color(0xFF667084),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                problemApiModel.issueCode,
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
                translate(LocalizationKeys.dateOfIssue)!,
                style: const TextStyle(
                  color: Color(0xFF667084),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                AppDateFormat.formattingMonthDay(
                    problemApiModel.createdAt, appLocale.locale.languageCode),
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

  Widget _resolveDescriptionWidget() {
    return ReadMoreText(
      text: problemApiModel.resolveDescription,
      maxLines: 1,
      maxLength: 50,
    );
  }
}
