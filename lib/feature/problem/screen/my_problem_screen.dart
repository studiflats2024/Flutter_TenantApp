import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/problems_api_manger.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/apis/models/my_problems/problem_api_model.dart';
import 'package:vivas/feature/problem/bloc/my_problem_bloc.dart';
import 'package:vivas/feature/problem/bloc/my_problem_repository.dart';
import 'package:vivas/feature/problem/model/filter_enum.dart';
import 'package:vivas/feature/problem/screen/problem_details_screen.dart';
import 'package:vivas/feature/problem/screen/select_apartment_problem_screen.dart';
import 'package:vivas/feature/problem/widgets/my_problem_item_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';

import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_lottie.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';
import 'package:vivas/utils/no_result/no_result_found_lottie.dart';

class MyProblemScreen extends StatelessWidget {
  MyProblemScreen({Key? key}) : super(key: key);
  static const routeName = '/my-problem-screen';

  static open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyProblemBloc>(
      create: (context) => MyProblemBloc(MyProblemRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        problemsApiManger: ProblemsApiManger(dioApiManager , context),
      )),
      child: const MyProblemScreenWithBloc(),
    );
  }
}

class MyProblemScreenWithBloc extends BaseStatefulScreenWidget {
  const MyProblemScreenWithBloc({super.key});

  @override
  BaseScreenState<MyProblemScreenWithBloc> baseScreenCreateState() {
    return _MyProblemScreenWithBloc();
  }
}

class _MyProblemScreenWithBloc extends BaseScreenState<MyProblemScreenWithBloc>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: ProblemFilter.values.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.problemList)!),
        bottom: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF1151B4),
            indicatorColor: const Color(0xFF1151B4),
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelColor: const Color(0xFF49454F),
            tabs: ProblemFilter.values
                .map((e) => Tab(child: Text(translate(e.getLocalizedKey)!)))
                .toList()),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                MyProblemFilterScreen(ProblemFilter.all),
                MyProblemFilterScreen(ProblemFilter.pending),
                MyProblemFilterScreen(ProblemFilter.completed),
              ],
            ),
          ),
          SubmitButtonWidget(
            title: translate(LocalizationKeys.reportProblem)!,
            onClicked: _reportProblemClicked,
          ),
        ],
      ),
    );
  }

  void _reportProblemClicked() {
    SelectApartmentProblemScreen.open(context);
  }
}

class MyProblemFilterScreen extends BaseStatefulScreenWidget {
  final ProblemFilter problemFilter;

  const MyProblemFilterScreen(this.problemFilter, {super.key});

  @override
  BaseScreenState<MyProblemFilterScreen> baseScreenCreateState() {
    return _MyProblemFilterScreen();
  }
}

class _MyProblemFilterScreen extends BaseScreenState<MyProblemFilterScreen>
    with PaginationManager<ProblemApiModel> {
  late MetaModel _pagingInfo;

  @override
  void initState() {
    _resetPaging();
    Future.microtask(() => _getMyProblemApiEvent(isSwipeToRefresh: false));
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocListener<MyProblemBloc, MyProblemState>(
      listener: (context, state) {
        if (state is MyProblemLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }

        if (state is MyProblemErrorState) {
          showFeedbackMessage(state.isLocalizationKey
              ? translate(state.errorMassage)!
              : state.errorMassage);
        } else if (state is MyProblemLoadedState) {
          _pagingInfo = state.pagingInfo;
          stopPaginationLoading();
          alignPaginationWithApi(_hasPrevious, _hasNext, state.list);
        } else if (state is MyProblemLoadingAsPagingState) {
          startPaginationLoading();
        }
      },
      child: _myProblemWidget(),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _myProblemWidget() {
    return BlocBuilder<MyProblemBloc, MyProblemState>(
      buildWhen: (previous, current) {
        if (current is MyProblemLoadedState) {
          return true;
        } else if (current is MyProblemLoadingAsPagingState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is MyProblemLoadedState) {
          return _buildListLoaded();
        } else if (state is MyProblemLoadingState) {
          return const LoaderWidget();
        } else if (state is MyProblemLoadingAsPagingState) {
          return _buildListLoaded();
        } else {
          return _buildListLoaded();
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

          _getMyProblemApiEvent(isSwipeToRefresh: false);
        }
      },
      itemWidget: (int index) {
        return MyProblemItemWidget(
          cardClickCallback: _myProblemClickCallback,
          problemApiModel: getUpdatedData[index],
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getMyProblemApiEvent(isSwipeToRefresh: true);
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
          message: translate(LocalizationKeys.youNotHaveAnyProblem)??"",
          asset: AppLottie.issueReportings,
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getMyProblemApiEvent(isSwipeToRefresh: true);
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  MyProblemBloc get currentBloc => BlocProvider.of<MyProblemBloc>(context);

  void _getMyProblemApiEvent({required bool isSwipeToRefresh}) {
    currentBloc.add(GetMyProblemApiEvent(
        _pagingInfo.currentPage + 1, isSwipeToRefresh, widget.problemFilter));
  }

  bool get _hasNext => _pagingInfo.currentPage < _pagingInfo.totalPages;

  bool get _hasPrevious => _pagingInfo.currentPage > 1;

  void _resetPaging() {
    _pagingInfo = MetaModel.getEmptyOne();
    resetPagination();
  }

  void _myProblemClickCallback(ProblemApiModel model) {
    ProblemDetailsScreen.open(context, model.issueId);
  }
}
