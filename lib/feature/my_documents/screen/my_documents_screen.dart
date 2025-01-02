import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/my_documents_api_manger.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/apis/models/my_documents/document_api_model.dart';
import 'package:vivas/feature/my_documents/bloc/my_documents_repository.dart';
import 'package:vivas/feature/my_documents/bloc/my_documents_bloc.dart';
import 'package:vivas/feature/my_documents/widgets/my_document_item_widget.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_lottie.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';
import 'package:vivas/utils/no_result/no_result_found_lottie.dart';

class MyDocumentsScreen extends StatelessWidget {
  MyDocumentsScreen({Key? key}) : super(key: key);
  static const routeName = '/my-documents-screen';

  static open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyDocumentsBloc>(
      create: (context) => MyDocumentsBloc(MyDocumentsRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        myDocumentsApiManger: MyDocumentsApiManger(dioApiManager , context),
      )),
      child: const MyDocumentsScreenWithBloc(),
    );
  }
}

class MyDocumentsScreenWithBloc extends BaseStatefulScreenWidget {
  const MyDocumentsScreenWithBloc({super.key});

  @override
  BaseScreenState<MyDocumentsScreenWithBloc> baseScreenCreateState() {
    return _MyDocumentsScreenWithBloc();
  }
}

class _MyDocumentsScreenWithBloc
    extends BaseScreenState<MyDocumentsScreenWithBloc>
    with PaginationManager<DocumentApiModel> {
  late MetaModel _pagingInfo;

  @override
  void initState() {
    _resetPaging();
    Future.microtask(() => _getMyDocumentsApiEvent(isSwipeToRefresh: false));
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.myDocuments)!),
      ),
      body: BlocListener<MyDocumentsBloc, MyDocumentsState>(
        listener: (context, state) {
          if (state is MyDocumentsLoadingState) {
            showLottieFileLoading(
                message: translate(LocalizationKeys.documentsLoading)!,
                lottieFile: AppLottie.documentLoading);
          } else {
            hideLottieFileLoading();
          }

          if (state is MyDocumentsErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is MyDocumentsLoadedState) {
            _pagingInfo = state.pagingInfo;
            stopPaginationLoading();
            alignPaginationWithApi(_hasPrevious, _hasNext, state.list);
          } else if (state is MyDocumentsLoadingAsPagingState) {
            startPaginationLoading();
          }
        },
        child: _myDocumentsWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _myDocumentsWidget() {
    return BlocBuilder<MyDocumentsBloc, MyDocumentsState>(
      buildWhen: (previous, current) {
        if (current is MyDocumentsLoadedState) {
          return true;
        } else if (current is MyDocumentsLoadingAsPagingState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is MyDocumentsLoadedState) {
          return _buildListLoaded();
        } else if (state is MyDocumentsLoadingAsPagingState) {
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

          _getMyDocumentsApiEvent(isSwipeToRefresh: false);
        }
      },
      itemWidget: (int index) {
        return MyDocumentItemWidget(
          documentApiModel: getUpdatedData[index],
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getMyDocumentsApiEvent(isSwipeToRefresh: true);
      },
      listLength: getUpdatedData.length,
      showPagingLoader: currentLoadingState,
    );
  }

  Widget _noUnitData() {
    return PagingSwipeToRefreshGridListWidget(
      reachedEndOfScroll: () {},
      itemWidget: (int index) {
        return NoResultFoundLottieWidget(
          message: translate(LocalizationKeys.documentsNotFound)??"",
          asset: AppLottie.noDocuments,
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getMyDocumentsApiEvent(isSwipeToRefresh: true);
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  MyDocumentsBloc get currentBloc => BlocProvider.of<MyDocumentsBloc>(context);

  void _getMyDocumentsApiEvent({required bool isSwipeToRefresh}) {
    currentBloc.add(
        GetMyDocumentsApiEvent(_pagingInfo.currentPage + 1, isSwipeToRefresh));
  }

  bool get _hasNext => _pagingInfo.currentPage < _pagingInfo.totalPages;

  bool get _hasPrevious => _pagingInfo.currentPage > 1;

  void _resetPaging() {
    _pagingInfo = MetaModel.getEmptyOne();
    resetPagination();
  }
}
