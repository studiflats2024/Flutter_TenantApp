import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/city_model/city_model.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class SearchMultiDestinationWidget extends BaseStatefulWidget {
  void Function(List<CityModel>) changeDestinationCallBack;
  final List<CityModel> cities;
  final bool useMultiMode;
  final bool withTitle;
  final List<CityModel> selected;
  SearchMultiDestinationWidget({
    required this.changeDestinationCallBack,
    this.selected = const [],
    required this.cities,
    this.useMultiMode = true,
    this.withTitle = true,
    super.key,
  });

  @override
  BaseState<SearchMultiDestinationWidget> baseCreateState() =>
      _FilterMultiDestinationWidgetState();
}

class _FilterMultiDestinationWidgetState
    extends BaseState<SearchMultiDestinationWidget> {
  List<CityModel> selectedDestination = [];
  @override
  void initState() {
    selectedDestination = widget.selected;
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.withTitle) ...[
            Text(
              translate(LocalizationKeys.selectArea)!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.appFormFieldTitle,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
          ],
          MultiSelectDropDown<CityModel>(
            selectedOptions: selectedDestination
                .map((e) => ValueItem<CityModel>(label: e.name, value: e))
                .toList(),
            onOptionSelected: _changeCity,
            options: widget.cities
                .map((e) => ValueItem<CityModel>(label: e.name, value: e))
                .toList(),
            selectionType: widget.useMultiMode
                ? SelectionType.multi
                : SelectionType.single,
            hintStyle: textTheme.labelMedium?.copyWith(
              color: AppColors.formFieldHintText,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            hint: translate(LocalizationKeys.pleaseSelectArea)!,
            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
            singleSelectItemStyle: const TextStyle(
              color: AppColors.colorPrimary,
              fontWeight: FontWeight.w500,
            ),
            alwaysShowOptionIcon: true,
            hintColor: AppColors.formFieldHintText,
            searchLabel: translate(LocalizationKeys.search),
            searchEnabled: true,
            borderRadius: 4,
            borderColor: const Color(0xFFD0D0DD),
            borderWidth: .5,
            optionTextStyle: const TextStyle(fontSize: 16),
            selectedOptionIcon: const Icon(Icons.check_circle),
          ),
        ],
      );
    });
  }

  void _changeCity(List<ValueItem<CityModel>> selectedOptions) {
    selectedDestination = selectedOptions.map((e) => e.value!).toList();
    // setState(() =>
    //     selectedDestination = ;
    widget.changeDestinationCallBack(selectedDestination);
  }
}
