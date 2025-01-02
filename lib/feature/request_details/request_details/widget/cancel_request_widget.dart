import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_time_form_field_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class CancelRequestWidget extends BaseStatefulWidget {
  final void Function(String reason, DateTime? terminationDate) sendCallBack;
  final bool showTerminationDate;
  const CancelRequestWidget({
    required this.sendCallBack,
    required this.showTerminationDate,
    super.key,
  });

  @override
  BaseState<CancelRequestWidget> baseCreateState() => _EditTenantWidgetState();
}

class _EditTenantWidgetState extends BaseState<CancelRequestWidget>
    with AuthValidate {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String reason;
  DateTime? _terminationDate;

  late final minDate = DateTime.now();
  late final maxDate = minDate.add(const Duration(days: 365));
  @override
  Widget baseBuild(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          if (widget.showTerminationDate) ...[
            DateTimeFormFieldWidget(
              title: translate(LocalizationKeys.terminationDate)!,
              hintText: translate(LocalizationKeys.enterTerminationDate),
              onSaved: _arrivalDateSave,
              validator: dateTimeValidator,
              showFullDay: true,
              maximumDate: maxDate,
              minimumDate: minDate,
              languageKey: appLocale.locale.languageCode,
            ),
            SizedBox(height: 10.h),
          ],
          AppTextFormField(
              title: translate(LocalizationKeys.cancellationReason)!,
              hintText:
                  translate(LocalizationKeys.tellUsReasonForCancellation)!,
              validator: textValidator,
              maxLines: 8,
              onSaved: (value) {
                reason = value!;
              }),
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
                  onPressed: _sendClicked,
                  title: translate(LocalizationKeys.send)!),
            ],
          ),
        ],
      ),
    );
  }

  void _arrivalDateSave(DateTime? date) {
    if (date != null) {
      _terminationDate = date;
    }
  }

  void _cancelClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _sendClicked() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      widget.sendCallBack(reason, _terminationDate);
      Navigator.of(context).pop();
    } else {
      autovalidateMode = AutovalidateMode.always;
    }
  }
}
