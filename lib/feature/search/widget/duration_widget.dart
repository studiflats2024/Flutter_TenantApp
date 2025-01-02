// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class DurationWidget extends BaseStatefulWidget {
  void Function(DateTime) changeStartDateCallBack;
  void Function(DateTime) changeEndDateCallBack;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  DurationWidget({
    super.key,
    required this.changeStartDateCallBack,
    required this.changeEndDateCallBack,
    required this.selectedStartDate,
    required this.selectedEndDate,
  });

  @override
  BaseState<DurationWidget> baseCreateState() => _DurationWidgetState();
}

class _DurationWidgetState extends BaseState<DurationWidget> with AuthValidate {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final ExpandableController _controller =
      ExpandableController(initialExpanded: true);
  late DateTime _startDate = startDateInit;
  late DateTime _endDate = _initialEndDate;
  bool _dateChanged = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_setInitialData);
  }

  @override
  Widget baseBuild(BuildContext context) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Expandable(
          controller: _controller,
          collapsed: buildCollapsed(),
          expanded: buildExpanded(),
        ),
      ),
    ));
  }

  Widget buildCollapsed() {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => _toggleExpanded(context),
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 15,
            right: 19,
            bottom: 20,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0xFFD0D0DD)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.when)!,
                style: const TextStyle(
                  color: Color(0xFF878787),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_dateChanged) ...[
                SizedBox(width: 10.w),
                Text(
                  "${AppDateFormat.formattingDatePicker(_startDate, appLocale.locale.languageCode)} ${translate(LocalizationKeys.to)} ${AppDateFormat.formattingDatePicker(_endDate, appLocale.locale.languageCode)}",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 103, 103, 103),
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
              if (!_dateChanged)
                Text(
                  translate(LocalizationKeys.selectADuration)!,
                  style: const TextStyle(
                    color: Color(0xFF0F0F0F),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildExpanded() {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFFD0D0DD)),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              child: GestureDetector(
                onTap: () => _toggleExpanded(context),
                child: Text(
                  translate(LocalizationKeys.selectADuration)!,
                  style: const TextStyle(
                    color: Color(0xFF0F0F0F),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              width: width,
              decoration: ShapeDecoration(
                color: const Color(0xFFF9F9FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(LocalizationKeys.selectDate)!,
                    style: const TextStyle(
                      color: Color(0xFF49454F),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  const Divider(),
                  SizedBox(height: 8.h),
                  DatePickerFormFiledWidget(
                    requiredTitle: false,
                    controller: _startDateController,
                    title: translate(LocalizationKeys.startDate)!,
                    hintText: translate(LocalizationKeys.startDate),
                    onSaved: (p0) {},
                    maximumDate: maxDateInit,
                    minimumDate: startDateInit,
                    startDate: _startDate,
                  ),
                  SizedBox(height: 10.h),
                  DatePickerFormFiledWidget(
                    requiredTitle: false,
                    controller: _endDateController,
                    title: translate(LocalizationKeys.endDate)!,
                    hintText: translate(LocalizationKeys.endDate),
                    onSaved: (p0) {},
                    maximumDate: maxDateInit,
                    minimumDate: _initialEndDate,
                    startDate: _endDate,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppTextButton.withTitle(
                        title: translate(LocalizationKeys.cancel)!,
                        onPressed: () => _cancelClicked(context),
                      ),
                      AppTextButton.withTitle(
                        title: translate(LocalizationKeys.ok)!,
                        onPressed: () => _okClicked(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  get startDateInit {
    return DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
  }

  late final maxDateInit = _startDate.add(const Duration(days: 365 * 5));

  DateTime get _initialEndDate {
    DateTime endDate = _startDate.add(const Duration(days: 155));
    return DateTime(endDate.year, endDate.month, 0);
  }

  void _setInitialData() {
    _startDate = widget.selectedStartDate ?? startDateInit;
    _endDate = widget.selectedEndDate ?? _initialEndDate;

    _startDateController.text = AppDateFormat.formattingDatePicker(
        _startDate, appLocale.locale.languageCode);
    _endDateController.text = AppDateFormat.formattingDatePicker(
        _endDate, appLocale.locale.languageCode);
    _startDateController.addListener(() {
      setState(() {
        _changeStartDate(AppDateFormat.appDatePickerParse(
            _startDateController.text, appLocale.locale.languageCode));
      });
    });
    _endDateController.addListener(() {
      setState(() {
        _changeEndDate(AppDateFormat.appDatePickerParse(
            _endDateController.text, appLocale.locale.languageCode));
      });
    });
    widget.changeStartDateCallBack(_startDate);
    widget.changeEndDateCallBack(_endDate);
  }

  void _changeStartDate(DateTime? startDate) {
    setState(() {
      _startDate = startDate!;
      _changeEndDate(_initialEndDate);
      _endDateController.text = AppDateFormat.formattingDatePicker(
          _initialEndDate, appLocale.locale.languageCode);
      _dateChanged = true;
      widget.changeStartDateCallBack(_startDate);
    });
  }

  void _changeEndDate(DateTime? endDate) {
    setState(() {
      _endDate = endDate!;
      _dateChanged = true;
      widget.changeEndDateCallBack(_endDate);
    });
  }

  void _toggleExpanded(BuildContext context) {
    setState(() {
      _controller.toggle();
    });
  }

  void _cancelClicked(BuildContext context) {
    widget.changeEndDateCallBack(_endDate);
    widget.changeStartDateCallBack(_startDate);
    // _dateChanged = false;
    _toggleExpanded(context);
  }

  void _okClicked(BuildContext context) {
    widget.changeEndDateCallBack(_endDate);
    widget.changeStartDateCallBack(_startDate);
    _dateChanged = true;
    _toggleExpanded(context);
  }
}
