import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/size_manager.dart';

class CountdownTimer extends BaseStatefulScreenWidget {
  final String endDate;
  final String planName;

  const CountdownTimer(this.endDate, this.planName, {super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() =>
      _CountdownTimerState();
}

class _CountdownTimerState extends BaseScreenState<CountdownTimer> {
  late DateTime endTime; // Target end time
  late Timer _timer;
  Duration remainingDuration = Duration.zero;
  late DateTimeRange dateTimeRange;
  late Duration totalDuration;

  @override
  void initState() {
    super.initState();
    endTime = DateFormat("MM/dd/yyyy").parse(widget.endDate);
    endTime = endTime.add(const Duration(days: 1));
    dateTimeRange = DateTimeRange(start: DateTime.now(), end: endTime);
    totalDuration = dateTimeRange.duration;
    _updateRemainingTime(); // Initialize remaining time
    _startTimer(); // Start the countdown
  }

  void _updateRemainingTime() {
    setState(() {
      remainingDuration = endTime.difference(DateTime.now());
      if (remainingDuration.isNegative) {
        remainingDuration = Duration.zero; // Timer ends if time passed
        _timer.cancel();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    // Calculate progress percentage

    final double progress =
        remainingDuration.inSeconds / totalDuration.inSeconds;

    // Extract days, hours, minutes from remainingDuration
    final int days = remainingDuration.inDays;
    final int hours = remainingDuration.inHours % 24;
    final int minutes = remainingDuration.inMinutes % 60;
    final int seconds = remainingDuration.inSeconds % 60;

    return Scaffold(
      body: Container(
        height: 230.r,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          border: Border.all(color: AppColors.cardBorderPrimary100),
          borderRadius: BorderRadius.all(SizeManager.circularRadius10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(SizeManager.sizeSp4),
                decoration: BoxDecoration(
                    color: AppColors.cardCountdown,
                    borderRadius:
                        BorderRadius.all(SizeManager.circularRadius4)),
                child: SvgPicture.asset(
                  AppAssetPaths.communityCountdownIcon,
                )),
            SizedBox(
              height: SizeManager.sizeSp24,
            ),
            TextApp(
              fontSize: FontSize.fontSize14,
              color: AppColors.textMainColor,
              text:
                  "Only ${days != 0 ? days : hours != 0 ? hours : minutes != 0 ? minutes : seconds} ${days != 0 ? "days" : hours != 0 ? "hours" : minutes != 0 ? "minutes" : "seconds"} left in your ${widget.planName}! ",
            ),
            SizedBox(
              height: SizeManager.sizeSp24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (days != 0) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      timeItem(days, 3),
                      SizedBox(
                        height: SizeManager.sizeSp4,
                      ),
                      TextApp(
                        text: "Days",
                        fontSize: FontSize.fontSize14,
                      )
                    ],
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                  Column(
                    children: [
                      TextApp(
                        text: ":",
                        fontSize: FontSize.fontSize40,
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp24,
                      )
                    ],
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                ],
                if (hours != 0) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      timeItem(hours, 2),
                      SizedBox(
                        height: SizeManager.sizeSp4,
                      ),
                      TextApp(
                        text: "Hours",
                        fontSize: FontSize.fontSize14,
                      )
                    ],
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                  Column(
                    children: [
                      TextApp(
                        text: ":",
                        fontSize: FontSize.fontSize32,
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp24,
                      )
                    ],
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    timeItem(minutes, 2),
                    SizedBox(
                      height: SizeManager.sizeSp4,
                    ),
                    TextApp(
                      text: "Minutes",
                      fontSize: FontSize.fontSize14,
                    )
                  ],
                ),
                if (hours == 0) ...[
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                  Column(
                    children: [
                      TextApp(
                        text: ":",
                        fontSize: FontSize.fontSize32,
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp24,
                      )
                    ],
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                ],
                if (hours == 0) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      timeItem(seconds, 2),
                      SizedBox(
                        height: SizeManager.sizeSp4,
                      ),
                      TextApp(
                        text: "Seconds",
                        fontSize: FontSize.fontSize14,
                      )
                    ],
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget timeItem(time, characters) {
    var timeLength = time.toString().characters.length;
    String timer = timeLength == 1 ? "0$time" : "$time";
    return Row(
      children: List.generate(timer.length, (index) {
        return timerItem(index, timer);
      }),
    );
  }

  Widget timerItem(
    index,
    time,
  ) {
    return Container(
      margin: EdgeInsets.only(
          right: index != (time.toString().characters.length - 1)
              ? SizeManager.sizeSp8
              : 0),
      padding: EdgeInsets.symmetric(
          vertical: SizeManager.sizeSp10, horizontal: SizeManager.sizeSp10),
      decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.cardBorderPrimary100,
          ),
          borderRadius: BorderRadius.all(SizeManager.circularRadius4)),
      child: Center(
        child: TextApp(
          text: time.toString().characters.elementAt(index),
          fontSize: FontSize.fontSize20,
          color: AppColors.colorPrimary,
        ),
      ),
    );
  }
}
