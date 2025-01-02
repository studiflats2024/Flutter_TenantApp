import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/make_waiting_request/screen/make_waiting_request_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class WaitingListWidget extends BaseStatelessWidget {
  WaitingListWidget({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Card(
          color: const Color(0xff1151B4).withOpacity(.1),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(LocalizationKeys.noSuitableApartmentFound)!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    translate(LocalizationKeys
                        .putYourselfOnTheWaitingListAndWeWillInformYouAsSoonAsASuitableApartmentIsAvailable)!,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 30.h),
        AppElevatedButton.withTitle(
            onPressed: () => _openRequestWaitingListScreen(context),
            title: translate(LocalizationKeys.setOnWaitingList)!),
        SizedBox(height: 10.h),
      ],
    );
  }

  _openRequestWaitingListScreen(BuildContext context) {
    MakeWaitingRequestScreen.open(context);
  }
}
