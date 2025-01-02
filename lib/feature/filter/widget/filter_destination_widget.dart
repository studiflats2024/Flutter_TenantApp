import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/area_model/area_model.dart';
import 'package:vivas/feature/widgets/text_field/auto_complete_form_field.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class FilterDestinationWidget extends BaseStatefulWidget {
  void Function(AreaModel?) changeDestinationCallBack;
  final List<AreaModel> area;
  final AreaModel? selected;
  FilterDestinationWidget({
    required this.changeDestinationCallBack,
    this.selected,
    required this.area,
    super.key,
  });

  @override
  BaseState<FilterDestinationWidget> baseCreateState() =>
      _DestinationWidgetState();
}

class _DestinationWidgetState extends BaseState<FilterDestinationWidget> {
  AreaModel? selectedDestination;
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
          Text(
            translate(LocalizationKeys.selectArea)!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.appFormFieldTitle,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          AutocompleteFormField<AreaModel>(
            decoration: InputDecoration(
              labelText: translate(LocalizationKeys.pleaseSelectArea)!,
              hintText: translate(LocalizationKeys.pleaseSelectArea)!,
              prefixIcon: const Icon(Icons.search),
              fillColor: AppColors.appFormFieldFill,
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              hintStyle: textTheme.labelMedium?.copyWith(
                color: AppColors.formFieldHintText,
                fontWeight: FontWeight.w400,
                fontSize: 16,
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
            initialValue: selectedDestination,
            maxSuggestions: widget.area.length,
            itemToString: (item) => item?.areaName ?? "",
            itemBuilder: (context, city) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                city?.areaName ?? "",
                style: const TextStyle(
                  color: Color(0xFF1D1B20),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            onSearch: (search) async => widget.area
                .where((area) =>
                    area.areaName.toLowerCase().contains(search.toLowerCase()))
                .toList(),
            itemFromString: (string) {
              final matches = widget.area.where((area) =>
                  area.areaName.toLowerCase() == string.toLowerCase());
              return matches.isEmpty ? null : matches.first;
            },
            onChanged: _changeArea,
          ),
        ],
      );
    });
  }

  void _changeArea(AreaModel? value) {
    setState(() => selectedDestination = value);
    widget.changeDestinationCallBack(selectedDestination);
  }
}
