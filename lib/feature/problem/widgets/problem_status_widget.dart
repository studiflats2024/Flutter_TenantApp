import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProblemStatusWidget extends StatelessWidget {
  final String statusString;
  final String statusKey;
  const ProblemStatusWidget(
      {super.key, required this.statusString, required this.statusKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: ShapeDecoration(
        color: statusBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        statusString,
        style: TextStyle(
          color: statusTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Color get statusTextColor {
    switch (statusKey.toLowerCase()) {
      case "pending":
        return const Color(0xFF1151B4);
      case "inprogress":
        return const Color(0xFF1151B4);
      case "solved":
        return const Color(0xFF21C36F);
      case "cancelled":
        return const Color(0xFFED2E38);
      case "completed":
        return const Color(0xFF21C36F);
      default:
        return const Color(0xFF1151B4);
    }
  }

  Color get statusBackgroundColor {
    switch (statusKey) {
      case "Pending":
        return const Color(0x141151B4);
      case "InProgress":
        return const Color(0x141151B4);
      case "Solved":
        return const Color(0xFFDDFEED);
      case "Cancelled":
        return const Color(0x14ED2E38);
      case "Completed":
        return const Color(0xFFDDFEED);
      default:
        return const Color(0x141151B4);
    }
  }
}
