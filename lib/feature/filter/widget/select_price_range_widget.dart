import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class SelectPriceRange extends BaseStatefulWidget {
  final double? min;
  final double? max;
  final void Function(double min, double max) changeRangeCallBack;
  const SelectPriceRange({
    required this.min,
    required this.max,
    required this.changeRangeCallBack,
    super.key,
  });

  @override
  BaseState<SelectPriceRange> baseCreateState() => _SelectPriceRangeState();
}

class _SelectPriceRangeState extends BaseState<SelectPriceRange> {
  double min = 0;
  double maxPrice = 10000;
  late double max = maxPrice;
  @override
  void initState() {
    min = widget.min?.toDouble() ?? 0;
    max = widget.max?.toDouble() ?? maxPrice;
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.selectPriceRange)!,
          style: const TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 16.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape()),
          child: RangeSlider(
            values: RangeValues(min, max),
            max: maxPrice,
            divisions: maxPrice.toInt() ~/ 10,
            labels: RangeLabels(
              min.round().toString(),
              max.round().toString(),
            ),
            onChanged: _changeRange,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _priceItemWidget(
                "${translate(LocalizationKeys.min)}: ${min.toInt()}"),
            _priceItemWidget(
                "${translate(LocalizationKeys.max)}: ${max.toInt()}")
          ],
        )
      ],
    );
  }

  Widget _priceItemWidget(String title) {
    return Container(
      width: 110.w,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0xFF7097D2)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: const TextStyle(
                          color: Color(0xFF1D2838),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const TextSpan(
                        text: '€',
                        style: TextStyle(
                          color: Color(0xFF1D2838),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeRange(RangeValues values) {
    setState(() {
      min = values.start;
      max = values.end;
      widget.changeRangeCallBack(min, max);
    });
  }
}
