import 'package:flutter/material.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/custom_drop_down_form_filed_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class SendComplaintsWidget extends BaseStatelessWidget with AuthValidate {
  final List<String> listType;
  final void Function(CustomDropDownItem?) typeSaved;
  final void Function(String?) detailSaved;
  SendComplaintsWidget({
    super.key,
    required this.listType,
    required this.typeSaved,
    required this.detailSaved,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleWidget(),
            const SizedBox(height: 15),
            CustomDropDownFormFiledWidget(
              title: translate(LocalizationKeys.complaintType)!,
              hintText: translate(LocalizationKeys.pleaseSelectComplaintType)!,
              items: listType.map((maritalStatus) {
                return CustomDropDownItem(
                    key: maritalStatus, value: maritalStatus);
              }).toList(),
              validator: customDropDownItemValidator,
              onSaved: typeSaved,
            ),
            const SizedBox(height: 15),
            AppTextFormField(
              title: translate(LocalizationKeys.complaintDetails)!,
              hintText: translate(LocalizationKeys.pleaseEnterComplaintDetails),
              onSaved: detailSaved,
              textInputAction: TextInputAction.next,
              validator: textValidator,
              maxLines: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          translate(LocalizationKeys.complaints)!,
          style: const TextStyle(
            color: Color(0xFF505050),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          translate(LocalizationKeys.followUpYourComplaintsFromHere)!,
          style: const TextStyle(
            color: Color(0xFF676767),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
