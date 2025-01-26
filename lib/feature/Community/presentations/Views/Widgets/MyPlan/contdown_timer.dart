import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/size_manager.dart';

class CountdownTimer extends BaseStatefulScreenWidget {
  const CountdownTimer({super.key});

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

    // Set the target end time (7 days and 11 hours from now)
    endTime = DateTime.now().add(const Duration(hours: 0,minutes: 2));
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
        padding: EdgeInsets.all(SizeManager.sizeSp16),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularPercentIndicator(
                radius: hours == 0 ? 140.0.r : 130.0.r,
                lineWidth: 10.0,
                percent: progress.clamp(0.0, 1.0),
                // Ensure progress stays valid
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.grey.shade300,
                linearGradient: const LinearGradient(
                  colors: [
                    AppColors.colorPrimary,
                    AppColors.cardBorderPrimary100,
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style:  TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        children: [
                          if (days != 0) ...[
                            TextSpan(text: '$days '),
                            const TextSpan(
                              text: 'days',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                          if (hours != 0) ...[
                            TextSpan(text:days == 0?'$hours ' : ' : $hours '),
                            const TextSpan(
                              text: 'hours',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                          if (days == 0 && minutes != 0) ...[
                            TextSpan(
                                text: hours != 0 ? ' : $minutes' : '$minutes '),
                            const TextSpan(
                              text: 'minutes',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                          if (hours == 0 && seconds != 0) ...[
                            TextSpan(
                                text: minutes == 0
                                    ? '$seconds '
                                    : ' : $seconds '),
                            const TextSpan(
                              text: 'Seconds',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Only $days days left in your free trial!',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textNatural700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
