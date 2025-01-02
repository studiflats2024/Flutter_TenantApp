import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class EditProblemWidget extends BaseStatefulWidget {
  final void Function(String newDescription) sendCallBack;
  final String description;
  const EditProblemWidget({
    required this.sendCallBack,
    required this.description,
    super.key,
  });

  @override
  BaseState<EditProblemWidget> baseCreateState() => _EditProblemWidgetState();
}

class _EditProblemWidgetState extends BaseState<EditProblemWidget>
    with AuthValidate {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String description;

  @override
  Widget baseBuild(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          AppTextFormField(
              initialValue: widget.description,
              title: translate(LocalizationKeys.problemDescription)!,
              hintText: translate(LocalizationKeys.problemDescription)!,
              validator: textValidator,
              maxLines: 8,
              onSaved: (value) {
                description = value!;
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
                  title: translate(LocalizationKeys.update)!),
            ],
          ),
        ],
      ),
    );
  }

  void _cancelClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _sendClicked() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      widget.sendCallBack(description);
      Navigator.of(context).pop();
    } else {
      autovalidateMode = AutovalidateMode.always;
    }
  }
}
