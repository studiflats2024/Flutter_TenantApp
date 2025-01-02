import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

// ignore: must_be_immutable
class RemainingTimeWidget extends BaseStatelessWidget {
  final DateTime target;
  RemainingTimeWidget(this.target, {super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _counterWidget(remainingFirstText()),
            _dotWidget(),
            _counterWidget(remainingSecondText()),
          ],
        );
      },
    );
  }

  Widget _dotWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: SizedBox(
        height: 50.h,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const ShapeDecoration(
                color: Color(0xFF1151B4),
                shape: OvalBorder(),
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: const ShapeDecoration(
                color: Color(0xFF1151B4),
                shape: OvalBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterWidget(String remainingText) {
    return Container(
      width: 100.w,
      height: 90.h,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Color(0xFF1151B4)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        child: Center(
          child: Column(
            children: [
              Text(getNumber(remainingText),
                  style: const TextStyle(
                    color: Color(0xFF1151B4),
                    fontSize: 56,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center),
              Text(
                getTitle(remainingText),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF0E4190),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String remainingFirstText() {
    Duration duration = target.difference(DateTime.now());

    return prettyDuration(
      duration,
      tersity: DurationTersity.hour,
      upperTersity: DurationTersity.day,
      first: true,
      spacer: "\n",
      locale: DurationLocale.fromLanguageCode(appLocale.locale.languageCode)!,
    );
  }

  String remainingSecondText() {
    Duration duration = target.difference(DateTime.now());
    List<String> list = prettyDuration(
      duration,
      delimiter: "%",
      tersity: DurationTersity.minute,
      upperTersity: DurationTersity.hour,
      locale: DurationLocale.fromLanguageCode(appLocale.locale.languageCode)!,
    ).split("%");

    if (list.length > 1) {
      return list[1];
    } else {
      return list.first;
    }
  }

  String getNumber(String value) {
    var f = NumberFormat("00", appLocale.locale.languageCode);
    int number = int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    return f.format(number);
  }

  String getTitle(String value) {
    return value.replaceAll(RegExp(r'[^A-Za-z]'), '').capitalize;
  }
}
