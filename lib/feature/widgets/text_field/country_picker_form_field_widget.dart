import 'package:country_picker/country_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class CountryPickerWidgetItem extends Equatable {
  final String value;
  final String key;
  const CountryPickerWidgetItem({
    required this.value,
    required this.key,
  });

  @override
  List<Object?> get props => [value, key];
}

class CountryPickerFormFieldWidget extends FormField<CountryPickerWidgetItem> {
  /// Creates a [Select Gender Widget] widget that is a [FormField], wrapped in an
  /// [InputDecorator].
  ///
  /// For a description of the `onSaved`, `validator`, or `autovalidateMode`
  /// parameters, see [FormField].
  ///
  final ValueChanged<CountryPickerWidgetItem?>? onChanged;

  CountryPickerFormFieldWidget({
    Key? key,
    CountryPickerWidgetItem? value,
    AutovalidateMode? autovalidateMode,
    FocusNode? focusNode,
    required String hintText,
    bool enabled = true,
    bool? autoFocus = false,
    FormFieldSetter<CountryPickerWidgetItem>? onSaved,
    this.onChanged,
    required FormFieldValidator<CountryPickerWidgetItem> validator,
    required String title,
    bool requiredTitle = true,
  })  : assert(autoFocus != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value,
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<CountryPickerWidgetItem> field) {
            final _CountryPickerFormFieldState state =
                field as _CountryPickerFormFieldState;
            const InputDecoration decorationArg = InputDecoration();
            final InputDecoration effectiveDecoration =
                decorationArg.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );
            // An unFocusAble Focus widget so that this widget can detect if its
            // descendants have focus or not.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  requiredTitle ? title.concatenateAsterisk : title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.appFormFieldTitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Focus(
                  canRequestFocus: false,
                  skipTraversal: true,
                  child: Builder(builder: (BuildContext context) {
                    return InputDecorator(
                      decoration: effectiveDecoration.copyWith(
                        errorText: field.errorText,
                        enabled: enabled,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 25.h,
                          color: AppColors.suffixIcon,
                        ),
                        fillColor: AppColors.appFormFieldFill,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 15.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.enabledAppFormFieldBorder,
                          ),
                        ),
                      ),
                      isEmpty: state.value == null,
                      isFocused: Focus.of(context).hasFocus,
                      child: _CountryPickerWidget(
                        hintText: hintText,
                        initialValue: state.value,
                        onSaved: onSaved,
                        onChange: state.didChange,
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );

  @override
  FormFieldState<CountryPickerWidgetItem> createState() =>
      _CountryPickerFormFieldState();
}

class _CountryPickerFormFieldState
    extends FormFieldState<CountryPickerWidgetItem> {
  @override
  void didChange(CountryPickerWidgetItem? value) {
    super.didChange(value);
    final CountryPickerFormFieldWidget dropdownButtonFormField = widget;
    if (dropdownButtonFormField.onChanged != null) {
      dropdownButtonFormField.onChanged!(value);
    }
  }

  @override
  void didUpdateWidget(CountryPickerFormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }

  @override
  CountryPickerFormFieldWidget get widget =>
      super.widget as CountryPickerFormFieldWidget;
}

// ignore: must_be_immutable
class _CountryPickerWidget extends BaseStatelessWidget {
  final void Function(CountryPickerWidgetItem?)? onChange;
  final void Function(CountryPickerWidgetItem?)? onSaved;
  final CountryPickerWidgetItem? initialValue;
  final String hintText;

  CountryPickerWidgetItem? selectedItem;

  _CountryPickerWidget({
    Key? key,
    this.onChange,
    this.onSaved,
    this.initialValue,
    required this.hintText,
  })  : selectedItem = initialValue,
        super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppColors.countryPickerFormFieldBackground,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          selectedItem?.value ?? hintText,
          textAlign: TextAlign.start,
          style: textTheme.bodyMedium?.copyWith(
              color: (selectedItem != null)
                  ? AppColors.countryPickerFormFieldText
                  : AppColors.unCountryPickerFormFieldText),
        ),
      ),
      onTap: () => _showCountyPicker(context),
    );
  }

  void _showCountyPicker(BuildContext context) {
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
          flagSize: 25,
          backgroundColor: Colors.white,
          bottomSheetHeight: height - kToolbarHeight,
          // radius for the BottomSheet.
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),

          //Optional. Styles the search field.
          inputDecoration: InputDecoration(
            labelText: translate(LocalizationKeys.search),
            hintText: translate(LocalizationKeys.selectYourNationality),
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
        ),
        onSelect: (Country country) {
          changeChoose(CountryPickerWidgetItem(
              key: country.countryCode,
              value: country.nameLocalized ?? country.name));
        });
  }

  changeChoose(CountryPickerWidgetItem choose) {
    selectedItem = choose;
    if (onChange != null) {
      onChange!(selectedItem!);
    }
    if (onSaved != null) {
      onSaved!(selectedItem!);
    }
  }
}
