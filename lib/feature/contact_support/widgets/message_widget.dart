import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/contact_support/model/chat_message_ui_model.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class MessageWidget extends BaseStatelessWidget {
  final ChatMessageUiModel chatMessageUiModel;
  final ChatMessageUiModel? previousChatMessageUiModel;
  final VoidCallback? messageClicked;
  final VoidCallback? reportProblemClicked;
  final VoidCallback? startChat;
  MessageWidget({
    required this.chatMessageUiModel,
    this.previousChatMessageUiModel,
    this.messageClicked,
    this.reportProblemClicked,
    this.startChat,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: GestureDetector(
        onTap: messageClicked,
        child: _messageWidget(),
      ),
    );
  }

  Widget _messageWidget() {
    switch (chatMessageUiModel.messageType) {
      case MessageType.customer:
      case MessageType.botQuestion:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isNotSamePrevious) _messageOwner(),
                  const SizedBox(height: 10),
                  if (chatMessageUiModel.msgBody != null) _messageBody(),
                  if (chatMessageUiModel.msgAttachment != null)
                    _messageImageBody(),
                  if (chatMessageUiModel.sendTime != null) _messageTime(),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            _messageIcon(),
          ],
        );
      case MessageType.agent:
      case MessageType.botAnswer:
        return Row(
          children: [
            _messageIcon(),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isNotSamePrevious) _messageOwner(),
                  const SizedBox(height: 10),
                  if (chatMessageUiModel.msgBody != null) _messageBody(),
                  if (chatMessageUiModel.msgAttachment != null)
                    _messageImageBody(),
                  if (chatMessageUiModel.sendTime != null) _messageTime(),
                ],
              ),
            )
          ],
        );
    }
  }

  Widget _messageIcon() {
    switch (chatMessageUiModel.messageType) {
      case MessageType.customer:
        return isNotSamePrevious
            ? !chatMessageUiModel.userPhoto.isNullOrEmpty
                ? AppCachedNetworkImage(
                    imageUrl: chatMessageUiModel.userPhoto!,
                    height: 40,
                    width: 40)
                : Image.asset(AppAssetPaths.chatHistoryIcon)
            : const SizedBox(width: 40);
      case MessageType.agent:
        return isNotSamePrevious
            ? !chatMessageUiModel.userPhoto.isNullOrEmpty
                ? AppCachedNetworkImage(imageUrl: chatMessageUiModel.userPhoto!)
                : Image.asset(AppAssetPaths.chatHistoryIcon)
            : const SizedBox(width: 40);
      case MessageType.botAnswer:
      case MessageType.botQuestion:
        return const EmptyWidget();
    }
  }

  Widget _messageTime() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Text(AppDateFormat.formattingTime(
          chatMessageUiModel.sendTime!, appLocale.currentLocaleCode())),
    );
  }

  Widget _messageOwner() {
    switch (chatMessageUiModel.messageType) {
      case MessageType.customer:
        return Text(
            chatMessageUiModel.userName ?? translate(LocalizationKeys.me)!);
      case MessageType.agent:
        return Text(
            chatMessageUiModel.userName ?? translate(LocalizationKeys.agent)!);
      case MessageType.botAnswer:
      case MessageType.botQuestion:
        return const EmptyWidget();
    }
  }

  Widget _messageImageBody() {
    switch (chatMessageUiModel.messageType) {
      case MessageType.customer:
      case MessageType.agent:
        return Card(
          margin: EdgeInsets.zero,
          color: const Color(0xffEFEFEF),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppCachedNetworkImage(
              imageUrl: chatMessageUiModel.msgAttachment!,
              fontSize: 16,
            ),
          ),
        );
      case MessageType.botAnswer:
      case MessageType.botQuestion:
        return const EmptyWidget();
    }
  }

  Widget _messageBody() {
    switch (chatMessageUiModel.messageType) {
      case MessageType.customer:
        return _bodyTextWidget(
            message: chatMessageUiModel.msgBody!,
            textColor: Colors.white,
            background: AppColors.colorPrimary);
      case MessageType.agent:
        return _bodyTextWidget(
            message: chatMessageUiModel.msgBody!,
            textColor: Colors.black,
            background: const Color(0xffF2F7FB));
      case MessageType.botQuestion:
        return _bodyTextWidget(
            message: chatMessageUiModel.msgBody!,
            textColor: Colors.black,
            background: const Color(0xffD3EBFF));
      case MessageType.botAnswer:
        return _answerBodyWidget(message: chatMessageUiModel.msgBody!);
    }
  }

  Widget _bodyTextWidget(
      {required String message,
      required Color textColor,
      required Color background}) {
    return Card(
      margin: EdgeInsets.zero,
      color: background,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Text(
          message,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  Widget _answerBodyWidget({required String message}) {
    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xffF2F7FB),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: chatMessageUiModel.chatBootQuestionModel?.quest
                    .concatenateNewline.concatenateNewline,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff686868),
                ),
              ),
              TextSpan(
                text: message.concatenateNewline.concatenateNewline,
                style: const TextStyle(
                  color: Color(0xff686868),
                ),
              ),
              TextSpan(
                text: translate(LocalizationKeys.toReportAProblem),
                style: const TextStyle(
                  color: Color(0xff686868),
                ),
              ),
              TextSpan(
                text: translate(LocalizationKeys.clickHere),
                style: const TextStyle(
                  color: Color(0xFF1151B4),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = reportProblemClicked,
              ),
              TextSpan(
                text: "".concatenateNewline.concatenateNewline,
                style: const TextStyle(),
              ),
              TextSpan(
                text: translate(LocalizationKeys.needMoreHelp),
                style: const TextStyle(
                  color: Color(0xff686868),
                ),
              ),
              TextSpan(
                text: translate(LocalizationKeys.chatWithSupport),
                style: const TextStyle(
                  color: Color(0xFF1151B4),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                recognizer: TapGestureRecognizer()..onTap = startChat,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get isNotSamePrevious =>
      chatMessageUiModel.messageType.index !=
      previousChatMessageUiModel?.messageType.index;
}
