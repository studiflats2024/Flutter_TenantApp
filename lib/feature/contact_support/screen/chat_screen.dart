import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/chat_api_manger.dart';
import 'package:vivas/apis/managers/file_api_mangers.dart';
import 'package:vivas/apis/models/chat/chat_boot_question/chat_boot_question_model.dart';
import 'package:vivas/apis/models/chat/send_message/chat_message_send_model.dart';
import 'package:vivas/feature/contact_support/bloc/contact_support_bloc.dart';
import 'package:vivas/feature/contact_support/bloc/contact_support_repository.dart';
import 'package:vivas/feature/contact_support/model/chat_message_ui_model.dart';
import 'package:vivas/feature/contact_support/widgets/message_widget.dart';
import 'package:vivas/feature/contact_support/widgets/send_chat_widget.dart';
import 'package:vivas/feature/problem/screen/select_apartment_problem_screen.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/chat-screen';
  static const argumentUnitUUID = 'UnitUUID';
  static const argumentUChatUUID = 'ChatUUID';

  static Future<void> open(BuildContext context,
      {String? unitUUID,
      String? chatUUID,
      bool openWithReplacement = false}) async {
    if (openWithReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentUnitUUID: unitUUID,
        argumentUChatUUID: chatUUID,
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentUnitUUID: unitUUID,
        argumentUChatUUID: chatUUID,
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactSupportBloc>(
      create: (context) => ContactSupportBloc(ContactSupportRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        chatApiManger: ChatApiManger(dioApiManager, context),
        uploadFileApiManager: UploadFileApiManager(dioApiManager, context),
      )),
      child: ChatScreenWithBloc(unitUUID(context), chatUUID(context)),
    );
  }

  String? unitUUID(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentUnitUUID]
          as String?;

  String? chatUUID(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentUChatUUID]
          as String?;
}

class ChatScreenWithBloc extends BaseStatefulScreenWidget {
  final String? unitUUID;
  final String? chatUUID;

  const ChatScreenWithBloc(this.unitUUID, this.chatUUID, {super.key});

  @override
  BaseScreenState<ChatScreenWithBloc> baseScreenCreateState() {
    return _ChatScreenWithBloc();
  }
}

class _ChatScreenWithBloc extends BaseScreenState<ChatScreenWithBloc> {
  List<ChatBootQuestionModel> _chatBootQuestionsList = [];
  List<ChatMessageUiModel> _chatMessageList = [];
  List<ChatMessageUiModel> _chatMessageBootList = [];
  final AutoScrollController controller = AutoScrollController();
  final TextEditingController textEditingController = TextEditingController();

  bool canSendMessage = false;
  bool messageLoading = false;
  bool showChatBoot = true;
  late String chatUUID;

  @override
  void initState() {

    chatUUID = widget.chatUUID ?? "";
    super.initState();
    canSendMessage = !isNewChat;
    Future.microtask(
        isNewChat ? _getChatBootQuestionsApiEvent : _getChatHistoryApiEvent);
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.chat)!),
      ),
      body: BlocListener<ContactSupportBloc, ContactSupportState>(
        listener: (context, state) {
          if (state is ChatMessageLoadingState) {
            messageLoading = true;
          } else if (state is ContactSupportLoadingState) {
            showLoading();
          } else {
            hideLoading();
            messageLoading = false;
          }

          if (state is ContactSupportErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is ChatBootQuestionListLoadedState) {
            _chatBootQuestionsList = state.list;
            showChatBoot == true;
            _createChatListFromQuestions();
          } else if (state is ChatMessageLoadedState) {
            _chatMessageList = state.list;
          } else if (state is BotQuestionClickedState) {
            _addAnswerToList(state.chatBootQuestionModel);
          } else if (state is StartNewChatSuccessfully) {
            showChatBoot = false;
            canSendMessage = true;
            chatUUID = state.chatUUID;
          } else if (state is SendMessageChatSuccessfully) {
            textEditingController.clear();
            _chatMessageList.add(state.chatMessageUiModel);
            _scrollToLasMessage();
          } else if (state is UploadAttachmentSuccessfully) {
            _addAttachmentMessage(state.filePath);
          }
        },
        child: BlocBuilder<ContactSupportBloc, ContactSupportState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Card(
                    child: _chatWidget(),
                  ),
                ),
                const SizedBox(height: 3),
                if (canSendMessage)
                  SendChatWidget(
                    textEditingController: textEditingController,
                    addTextMessage: _addTextMessage,
                    addAttachmentMessage: _uploadAttachmentMessage,
                    enableSend: state is! ChatMessageLoadingState,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////
  Widget _chatWidget() {
    return showChatBoot == true && widget.chatUUID==null
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            controller: controller,
            itemCount: _chatMessageBootList.length,
            itemBuilder: (context, index) {
              ChatMessageUiModel? previousModel;
              if (index != 0) {
                previousModel = _chatMessageBootList[index - 1];
              }

              return Column(
                children: [
                  AutoScrollTag(
                    controller: controller,
                    index: index,
                    key: ValueKey(index),
                    child: MessageWidget(
                      chatMessageUiModel: _chatMessageBootList[index],
                      previousChatMessageUiModel: previousModel,
                      startChat: _startNewChatApiEvent,
                      reportProblemClicked: _openReportScreen,
                      messageClicked: _chatMessageBootList[index].isBotQuestion
                          ? () => _botQuestionClicked(
                              _chatMessageBootList[index]
                                  .chatBootQuestionModel!)
                          : null,
                    ),
                  ),
                  if (index == (_chatMessageBootList.length - 1) &&
                      messageLoading)
                    const Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: CircularProgressIndicator()),
                ],
              );
            },
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            controller: controller,
            itemCount: _chatMessageList.length,
            itemBuilder: (context, index) {
              ChatMessageUiModel? previousModel;
              if (index != 0) {
                previousModel = _chatMessageList[index - 1];
              }

              return Column(
                children: [
                  if (showChatBoot == true) ...[
                    AutoScrollTag(
                      controller: controller,
                      index: index,
                      key: ValueKey(index),
                      child: MessageWidget(
                        chatMessageUiModel: _chatMessageList[index],
                        previousChatMessageUiModel: previousModel,
                        startChat: _startNewChatApiEvent,
                        reportProblemClicked: _openReportScreen,
                        messageClicked: _chatMessageList[index].isBotQuestion
                            ? () => _botQuestionClicked(
                                _chatMessageList[index].chatBootQuestionModel!)
                            : null,
                      ),
                    ),
                  ] else ...[
                    AutoScrollTag(
                      controller: controller,
                      index: index,
                      key: ValueKey(index),
                      child: MessageWidget(
                        chatMessageUiModel: _chatMessageList[index],
                        previousChatMessageUiModel: previousModel,
                        startChat: _startNewChatApiEvent,
                        reportProblemClicked: _openReportScreen,
                        messageClicked: _chatMessageList[index].isBotQuestion
                            ? () => _botQuestionClicked(
                                _chatMessageList[index].chatBootQuestionModel!)
                            : null,
                      ),
                    ),
                  ],
                  if (index == (_chatMessageList.length - 1) && messageLoading)
                    const Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: CircularProgressIndicator()),
                ],
              );
            },
          );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  ContactSupportBloc get currentBloc =>
      BlocProvider.of<ContactSupportBloc>(context);

  bool get isNewChat => widget.chatUUID == null;

  void _getChatBootQuestionsApiEvent() {

    currentBloc.add(const GetChatBootQuestionsApiEvent());
  }

  void _getChatHistoryApiEvent() {
    currentBloc.add(GetChatHistoryApiEvent(widget.chatUUID!));
  }

  void _startNewChatApiEvent() {
    currentBloc.add(StartNewChatApiEvent(widget.unitUUID));
  }

  void _sendMessageApiEvent(ChatMessageSendModel chatMessageSendModel) {
    currentBloc.add(SendMessageApiEvent(chatMessageSendModel));
  }

  void _botQuestionClicked(ChatBootQuestionModel chatBootQuestionModel) {
    currentBloc.add(BotQuestionClickedEvent(chatBootQuestionModel));
  }

  void _addTextMessage(String message) {
    _sendMessageApiEvent(ChatMessageSendModel(
      chatID: chatUUID,
      msgText: message,
    ));
  }

  void _addAttachmentMessage(String attachment) {
    _sendMessageApiEvent(ChatMessageSendModel(
      chatID: chatUUID,
      attachment: attachment,
    ));
  }

  void _uploadAttachmentMessage(String attachmentUri) {
    currentBloc.add(UploadAttachmentApiEvent(attachmentUri));
  }

  void _createChatListFromQuestions() {
    _chatMessageBootList.clear();
    _chatMessageBootList.add(ChatMessageUiModel.startChatMessage(translate));
    for (var element in _chatBootQuestionsList) {
      _chatMessageBootList.add(
        ChatMessageUiModel.fromChatBootQuestionModel(element),
      );
    }
  }

  void _addAnswerToList(ChatBootQuestionModel chatBootQuestionModel) {
    _chatMessageBootList.add(
      ChatMessageUiModel.fromChatBootQuestionAnswer(chatBootQuestionModel),
    );
    _scrollToLasMessage();
  }

  void _scrollToLasMessage() {
    Future.delayed(const Duration(milliseconds: 300), () {
      controller.scrollToIndex(_chatMessageBootList.length,
          preferPosition: AutoScrollPosition.begin);
    });
  }

  void _openReportScreen() {
    SelectApartmentProblemScreen.open(context);
  }
}
