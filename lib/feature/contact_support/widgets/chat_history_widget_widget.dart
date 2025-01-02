import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/chat/chat_list/chat_item_model.dart';
import 'package:vivas/feature/contact_support/widgets/chat_state_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';

// ignore: must_be_immutable
class ChatHistoryWidgetWidget extends BaseStatelessWidget {
  final ChatItemModel chatHistoryModel;
  final void Function(ChatItemModel model) cardClickCallback;
  ChatHistoryWidgetWidget({
    required this.chatHistoryModel,
    required this.cardClickCallback,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => cardClickCallback(chatHistoryModel),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFF5F5F5)),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 15,
              offset: Offset(0, 8),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            Image.asset(AppAssetPaths.chatHistoryIcon),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatHistoryModel.aptName,
                    style: const TextStyle(
                      color: Color(0xFF000E08),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    chatHistoryModel.aptName,
                    style: const TextStyle(
                      color: Color(0xFF5D5D5D),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    chatHistoryModel.chatCode,
                    style: const TextStyle(
                      color: Color(0xFF737373),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 15.w),
            ChatStateWidget(chatHistoryModel.isOpen),
            SizedBox(width: 15.w),
            SvgPicture.asset(
              AppAssetPaths.chatIcon,
              colorFilter: const ColorFilter.mode(
                  AppColors.colorPrimary, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
