import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

// ignore: must_be_immutable
class CheckInDetailsSectionWidget extends BaseStatelessWidget {
  final String title;
  final String? value;
  CheckInDetailsSectionWidget(this.title, this.value, {super.key});

  @override
  Widget baseBuild(BuildContext context) {
    if (value.isNullOrEmpty) {
      return const EmptyWidget();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text(
            translate(title)!,
            style: const TextStyle(
              color: Color(0xFF344054),
              height: 1.5,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value!,
            style: const TextStyle(
              color: Color(0xFF605D62),
              height: 1.5,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
          const Divider(height: 4, color: Color.fromARGB(255, 198, 199, 200)),
          SizedBox(height: 8.h),
        ],
      );
    }
  }
}
