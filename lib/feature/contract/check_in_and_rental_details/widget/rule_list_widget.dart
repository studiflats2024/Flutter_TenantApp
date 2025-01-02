import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class RuleListWidget extends BaseStatelessWidget {
  final List<String> rulesList;
  RuleListWidget(this.rulesList, {super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.rentalRules)!,
          style: const TextStyle(
            color: Color(0xFF344054),
            height: 1.5,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        ...getRuleList,
      ],
    );
  }

  List<Widget> get getRuleList {
    var list = <Widget>[];
    for (var i = 0; i < rulesList.length; i++) {
      list.add(_ruleWidget((i + 1), rulesList[i]));
    }
    return list;
  }

  Widget _ruleWidget(int index, String rule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Text(
          "${translate(LocalizationKeys.rule)!} $index",
          style: const TextStyle(
            color: Color(0xFF344054),
            height: 1.5,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          rule,
          style: const TextStyle(
            color: Color(0xFF605D62),
            height: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.h),
        const Divider(height: 2, color: Color(0xFFEAECF0)),
        SizedBox(height: 8.h),
      ],
    );
  }
}
