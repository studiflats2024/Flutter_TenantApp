import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/chat_api_manger.dart';
import 'package:vivas/apis/managers/file_api_mangers.dart';
import 'package:vivas/apis/models/chat/chat_list/chat_item_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/contact_support/bloc/contact_support_bloc.dart';
import 'package:vivas/feature/contact_support/bloc/contact_support_repository.dart';
import 'package:vivas/feature/contact_support/screen/chat_screen.dart';
import 'package:vivas/feature/contact_support/widgets/chat_history_widget_widget.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';

class ChatHistoryScreen extends StatelessWidget {
  ChatHistoryScreen({Key? key}) : super(key: key);
  static const routeName = '/chat-history-screen';

  static open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactSupportBloc>(
      create: (context) => ContactSupportBloc(ContactSupportRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        chatApiManger: ChatApiManger(dioApiManager , context),
        uploadFileApiManager: UploadFileApiManager(dioApiManager , context),
      )),
      child: const ChatHistoryScreenWithBloc(),
    );
  }
}

class ChatHistoryScreenWithBloc extends BaseStatefulScreenWidget {
  const ChatHistoryScreenWithBloc({super.key});

  @override
  BaseScreenState<ChatHistoryScreenWithBloc> baseScreenCreateState() {
    return _ChatHistoryScreenWithBloc();
  }
}

class _ChatHistoryScreenWithBloc
    extends BaseScreenState<ChatHistoryScreenWithBloc>
    with PaginationManager<ChatItemModel> {
  late MetaModel _pagingInfo;

  @override
  void initState() {
    _resetPaging();
    Future.microtask(() => _getChatHistoryApiEvent(isSwipeToRefresh: false));
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate(LocalizationKeys.chatHistory)!),
      ),
      body: BlocListener<ContactSupportBloc, ContactSupportState>(
        listener: (context, state) {
          if (state is ContactSupportLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is ContactSupportErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is ChatHistoryLoadedState) {
            _pagingInfo = state.pagingInfo;
            stopPaginationLoading();
            alignPaginationWithApi(_hasPrevious, _hasNext, state.list);
          } else if (state is ContactSupportLoadingAsPagingState) {
            startPaginationLoading();
          }
        },
        child: _wishlistWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _wishlistWidget() {
    return BlocBuilder<ContactSupportBloc, ContactSupportState>(
      buildWhen: (previous, current) {
        if (current is ChatHistoryLoadedState) {
          return true;
        } else if (current is ContactSupportLoadingAsPagingState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ChatHistoryLoadedState) {
          return _buildListLoaded();
        } else if (state is ContactSupportLoadingAsPagingState) {
          return _buildListLoaded();
        } else {
          return const LoaderWidget();
        }
      },
    );
  }

  Widget _buildListLoaded() {
    if (getUpdatedData.isEmpty) {
      return _noUnitData();
    }
    return PagingSwipeToRefreshGridListWidget(
      reachedEndOfScroll: () {
        if (shouldLoadMore) {
          startPaginationLoading();

          _getChatHistoryApiEvent(isSwipeToRefresh: false);
        }
      },
      itemWidget: (int index) {
        return ChatHistoryWidgetWidget(
          cardClickCallback: _chatClickCallback,
          chatHistoryModel: getUpdatedData[index],
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getChatHistoryApiEvent(isSwipeToRefresh: true);
      },
      listLength: getUpdatedData.length,
      showPagingLoader: currentLoadingState,
    );
  }

  Widget _noUnitData() {
    return PagingSwipeToRefreshGridListWidget(
      reachedEndOfScroll: () {},
      itemWidget: (int index) {
        return NoResultFoundWidget();
      },
      swipedToRefresh: () {
        _resetPaging();
        _getChatHistoryApiEvent(isSwipeToRefresh: true);
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  ContactSupportBloc get currentBloc =>
      BlocProvider.of<ContactSupportBloc>(context);

  void _getChatHistoryApiEvent({required bool isSwipeToRefresh}) {
    currentBloc.add(
        GetChatListApiEvent(_pagingInfo.currentPage + 1, isSwipeToRefresh));
  }

  bool get _hasNext => _pagingInfo.currentPage < _pagingInfo.totalPages;

  bool get _hasPrevious => _pagingInfo.currentPage > 1;

  void _resetPaging() {
    _pagingInfo = MetaModel.getEmptyOne();
    resetPagination();
  }

  void _chatClickCallback(ChatItemModel model) {
    ChatScreen.open(context, chatUUID: model.chatID);
  }
}
