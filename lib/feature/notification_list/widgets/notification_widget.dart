import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/notifications_list/notification_item_api_model.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/format/app_date_format.dart';

// ignore: must_be_immutable
class NotificationWidget extends BaseStatelessWidget {
  final NotificationItemApiModel notificationItemApiModel;
  final void Function(NotificationItemApiModel) cardClickCallback;
  NotificationWidget(
      {super.key,
      required this.notificationItemApiModel,
      required this.cardClickCallback});

  @override
  Widget baseBuild(BuildContext context) {
    return InkWell(
      onTap: () => cardClickCallback(notificationItemApiModel),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(AppAssetPaths.appLogo, height: 30),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationItemApiModel.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppDateFormat.formattingDate(
                        notificationItemApiModel.createAt,
                        appLocale.locale.languageCode),
                    style: const TextStyle(
                      color: Color(0xFF7F7F7F),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
