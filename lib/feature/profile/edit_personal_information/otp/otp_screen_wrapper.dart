import 'package:flutter/material.dart';

import 'package:vivas/feature/auth/otp/bloc/otp_bloc.dart';
import 'package:vivas/feature/auth/otp/screen/otp_screen.dart';

class OtpScreenWrapper extends StatelessWidget {
  final String uuid;
  final bool sendOtpWhenOpen;
  final String? restToken;
  final OpenAfterCheckOtp openAfterCheckOtp;
  final Function(OtpState)? otpStateListener;

  const OtpScreenWrapper(
      {super.key,
      required this.uuid,
      this.sendOtpWhenOpen = false,
      this.restToken,
      this.openAfterCheckOtp = OpenAfterCheckOtp.emailPhoneUpdatedDialog,
      this.otpStateListener});

  @override
  Widget build(BuildContext context) {
    return OtpScreen(
      uuid: uuid,
      restToken: restToken,
      sendOtpWhenOpen: sendOtpWhenOpen,
      openAfterCheckOtp: openAfterCheckOtp,
      otpStateListener: otpStateListener,
    );
  }
}
