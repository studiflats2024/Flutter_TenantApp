import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

class CustomDropDownItem extends Equatable {
  final String value;
  final String key;
  const CustomDropDownItem({
    required this.value,
    required this.key,
  });

  @override
  List<Object?> get props => [value, key];
}

// ignore: must_be_immutable
class CustomDropDownFormFiledWidget extends BaseStatelessWidget {
  final List<CustomDropDownItem>? items;
  final String hintText;
  final String title;
  final bool requiredTitle;
  final ValueChanged<CustomDropDownItem?>? onChanged;
  final bool ignoring;
  CustomDropDownItem? initialValue;
  final bool withBorder;
  final FormFieldSetter<CustomDropDownItem>? onSaved;
  FormFieldValidator<CustomDropDownItem>? validator;
  Color? iconColor;
  TextStyle? titleTextStyle;

  final double? dropdownMaxHeight;
  final FocusNode? focusNode;

  CustomDropDownFormFiledWidget(
      {Key? key,
      this.items,
      required this.title,
      this.requiredTitle = true,
      this.ignoring = false,
      required this.hintText,
      this.onChanged,
    this.onSaved,
    this.validator,
    this.dropdownMaxHeight,
    this.initialValue,
    this.withBorder = true,
    this.iconColor,
    this.focusNode,
    this.titleTextStyle}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          requiredTitle ? title.concatenateAsterisk : title,
          style: titleTextStyle ??
              const TextStyle(
                fontSize: 14,
                color: AppColors.appFormFieldTitle,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField2<CustomDropDownItem>(
          decoration: InputDecoration(
            hintStyle: textTheme.labelMedium?.copyWith(
              color: AppColors.formFieldHintText,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            isDense: true,
            fillColor: AppColors.appFormFieldFill,
            filled: true,
            contentPadding: EdgeInsetsDirectional.only(
              start: 1.w,
              end: 10.h,
              top: 15.h,
              bottom: 15.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.enabledAppFormFieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.formFieldFocusIBorder,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          focusNode: focusNode,
          isExpanded: true,
          hint: initialValue != null
              ? Text(initialValue!.value)
              : Text(
                  hintText,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.formFieldHintText,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.zero,
          ),
          dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          )),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 25.h,
              color: AppColors.suffixIcon,
            ),
          ),
          items: buildDropdownList(items),
          validator: validator,
          value: initialValue,
          onChanged: (value) {
            initialValue = value;
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          style: textTheme.bodyMedium?.copyWith(color: AppColors.formFieldText),
          onSaved: onSaved,
        ),
      ],
    );
  }

  List<DropdownMenuItem<CustomDropDownItem>>? buildDropdownList(
      List<CustomDropDownItem>? list) {
    return list == null || ignoring
        ? null
        : list.map((CustomDropDownItem item) {
            return DropdownMenuItem<CustomDropDownItem>(
              value: item,
              child: Text(item.value),
            );
          }).toList();
  }
}
