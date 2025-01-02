// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/area_model/area_model.dart';
import 'package:vivas/feature/widgets/text_field/auto_complete_form_field.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class DestinationWidget extends BaseStatefulWidget {
  void Function(AreaModel?) changeDestinationCallBack;
  final List<AreaModel> area;
  final AreaModel? selected;

  DestinationWidget(
      {required this.changeDestinationCallBack,
      required this.selected,
      required this.area,
      super.key});

  @override
  BaseState<DestinationWidget> baseCreateState() => _DestinationWidgetState();
}

class _DestinationWidgetState extends BaseState<DestinationWidget> {
  AreaModel? selectedDestination;
  bool _destinationChanged = false;

  @override
  void initState() {
    selectedDestination = widget.selected;
    _destinationChanged = selectedDestination != null;
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Expandable(
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
                translate(LocalizationKeys.selectYourDestination)!,
                style: const TextStyle(
                  color: Color(0xFF878787),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_destinationChanged)
                Text(
                  selectedDestination?.areaName ?? "",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 103, 103, 103),
                    fontSize: 12.spMin,
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
                  translate(LocalizationKeys.selectYourDestination)!,
                  style: const TextStyle(
                    color: Color(0xFF0F0F0F),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: AutocompleteFormField<AreaModel>(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: translate(LocalizationKeys.whereTo)!,
                  hintText: translate(LocalizationKeys.whereTo)!,
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
                    .where((area) => area.areaName
                        .toLowerCase()
                        .contains(search.toLowerCase()))
                    .toList(),
                itemFromString: (string) {
                  final matches = widget.area.where((area) =>
                      area.areaName.toLowerCase() == string.toLowerCase());
                  return matches.isEmpty ? null : matches.first;
                },
                onChanged: _changeArea,
              ),
            ),
          ],
        ),
      );
    });
  }

  void _changeArea(AreaModel? value) {
    setState(() => selectedDestination = value);
    _destinationChanged = true;
    widget.changeDestinationCallBack(selectedDestination);
  }

  void _toggleExpanded(BuildContext context) {
    var controller = ExpandableController.of(context, required: true)!;
    controller.toggle();
  }
}
