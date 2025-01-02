import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';

// ignore: must_be_immutable
class RatingItemWidget extends BaseStatelessWidget {
  final String title;
  //final void Function(double)? onChanged;
  final ValueChanged<double> onRateValueChanged;
  RatingItemWidget(
      {super.key, required this.title, required this.onRateValueChanged});

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFF475467),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          RatingBar.builder(
            initialRating: 0,
            itemCount: 5,
            itemSize: 26.0,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Color(0xFFFABF35),
            ),
            unratedColor: const Color(0xFFE8E8E8),
            onRatingUpdate: onRateValueChanged,
          )
        ],
      ),
    );
  }

  void _openFlitterCallBack(BuildContext context) {}
}
