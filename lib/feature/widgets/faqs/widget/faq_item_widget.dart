import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';

class FaqItemWidget extends StatelessWidget {
  final FAQModel faqUiModel;
  const FaqItemWidget({super.key, required this.faqUiModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              faqUiModel.faqQuest,
              style: const TextStyle(
                color: Color(0xFF1D2838),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              faqUiModel.faqAns,
              style: const TextStyle(
                color: Color(0xFF344053),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
