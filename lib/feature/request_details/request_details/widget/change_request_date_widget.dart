import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/validations/validator.dart';

// ignore: must_be_immutable
class ChangeRequestDateWidget extends BaseStatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? availableFrom;
  final DateTime? availableTo;
  final int? minStay;
  void Function(DateTime startDate, DateTime endDate) saveCallBack;

  ChangeRequestDateWidget({
    required this.startDate,
    required this.endDate,
    required this.saveCallBack,
    this.availableFrom,
    this.availableTo,
    this.minStay,
    super.key,
  });

  @override
  BaseState<ChangeRequestDateWidget> baseCreateState() =>
      _EditTenantWidgetState();
}

class _EditTenantWidgetState extends BaseState<ChangeRequestDateWidget> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  late DateTime _startDate = startDateInit;
  late DateTime _endDate = _initialEndDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(_setInitialData);
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          DatePickerFormFiledWidget(
            controller: _startDateController,
            title: translate(LocalizationKeys.startDate)!,
            hintText: translate(LocalizationKeys.startDate),
            onSaved: (p0) {

            },
            validator: (value) {
              if (value != null) {
                return Validator.validateTimeRange(
                    DateTimeRange(start: value, end: _endDate),
                    minStay: widget.minStay!);
              } else {
                return null;
              }
            },
            maximumDate: widget.availableTo!,
            minimumDate: widget.availableFrom!,
            startDate: _startDate,
          ),
          SizedBox(height: 10.h),
          DatePickerFormFiledWidget(
            controller: _endDateController,
            title: translate(LocalizationKeys.endDate)!,
            hintText: translate(LocalizationKeys.endDate),
            onSaved: (p0) {},
            validator: (value) {
              return Validator.validateTimeRange(
                  DateTimeRange(start: _startDate, end: value!),
                  minStay: widget.minStay!);
            },
            maximumDate: widget.availableTo!,
            minimumDate: widget.availableFrom!,
            startDate: _endDate,
          ),
          SizedBox(height: 24.h),
          const SizedBox(height: 24),
          Row(
            children: [
              AppElevatedButton.withTitle(
                color: const Color(0xFFEFEFEF),
                textColor: const Color(0xFF0F0F0F),
                title: translate(LocalizationKeys.cancel)!,
                onPressed: () => _cancelClicked(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              const Spacer(),
              AppElevatedButton.withTitle(
                  onPressed: _savedClicked,
                  title: translate(LocalizationKeys.save)!),
            ],
          ),
        ],
      ),
    );
  }

  get startDateInit {
    return DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
  }

  late final maxDateInit = _startDate.add(const Duration(days: 365 * 5));

  void _setInitialData() {
    _startDate = widget.startDate;
    _endDate = widget.endDate;

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
  }

  void _changeStartDate(DateTime? startDate) {
    setState(() {
      _startDate = startDate!;
      _changeEndDate(_initialEndDate);
      _endDateController.text = AppDateFormat.formattingDatePicker(
          _initialEndDate, appLocale.locale.languageCode);
    });
  }

  void _changeEndDate(DateTime? endDate) {
    setState(() {
      _endDate = endDate!;
    });
  }

  DateTime get _initialEndDate {
    DateTime endDate = _startDate.add(const Duration(days: 155));
    return DateTime(endDate.year, endDate.month, 0);
  }

  void _cancelClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _savedClicked() {

      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState!.save();
        widget.saveCallBack(_startDate, _endDate);
        Navigator.of(context).pop();
      } else {
        autovalidateMode = AutovalidateMode.always;
      }
  }
}
