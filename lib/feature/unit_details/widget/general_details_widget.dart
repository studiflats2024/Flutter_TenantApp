import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class GeneralDetailsWidget extends BaseStatelessWidget {
  final int floorNumber;
  final int maxNumberOfGuest;
  GeneralDetailsWidget({
    required this.floorNumber,
    required this.maxNumberOfGuest,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        SizedBox(height: 16.h),
        _listOfFeature(),
      ],
    );
  }

  Widget _title() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Text(
        translate(LocalizationKeys.generalDetails)!,
        style: const TextStyle(
          color: Color(0xFF1D2838),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _listOfFeature() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${translate(LocalizationKeys.floorNumber)} $floorNumber',
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        const Divider(),
        SizedBox(height: 4.h),
        Text(
          '${translate(LocalizationKeys.maxNumberOfGuests)} $maxNumberOfGuest',
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
