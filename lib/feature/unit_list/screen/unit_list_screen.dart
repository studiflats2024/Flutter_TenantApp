import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/models/apartments/apartment_list/apartment_item_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/uint_widget/unit_widget.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';
import 'package:vivas/feature/unit_list/bloc/unit_list_bloc.dart';
import 'package:vivas/feature/unit_list/bloc/unit_list_repository.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';

class UnitListScreen extends StatelessWidget {
  UnitListScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/unit-list-screen';

  static open(BuildContext context, String title) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UnitListBloc>(
      create: (context) => UnitListBloc(UnitListRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentApiManger:ApartmentApiManger(dioApiManager,context),
      )),
      child: const UnitListScreenWithBloc(),
    );
  }
}

class UnitListScreenWithBloc extends BaseStatefulScreenWidget {
  const UnitListScreenWithBloc({super.key});

  @override
  BaseScreenState<UnitListScreenWithBloc> baseScreenCreateState() {
    return _UnitListScreenWithBloc();
  }
}

class _UnitListScreenWithBloc extends BaseScreenState<UnitListScreenWithBloc>
    with PaginationManager<ApartmentItemApiV2Model> {
  late MetaModel _pagingInfo;

  @override
  void initState() {
    _resetPaging();
    Future.microtask(() => _getUnitListApiEvent(isSwipeToRefresh: false));
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.bestOffer)!),
      ),
      body: BlocListener<UnitListBloc, UnitListState>(
        listener: (context, state) {
          if (state is UnitListLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is UnitListErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is UnitListLoadedStateV2) {
            _pagingInfo = state.pagingInfo;
            stopPaginationLoading();
            alignPaginationWithApi(_hasPrevious, _hasNext, state.list);
          } else if (state is UnitListLoadingAsPagingState) {
            startPaginationLoading();
          }
        },
        child: _unitListWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _unitListWidget() {
    return BlocBuilder<UnitListBloc, UnitListState>(
      buildWhen: (previous, current) {
        if (current is UnitListLoadedStateV2) {
          return true;
        } else if (current is UnitListLoadingAsPagingState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is UnitListLoadedStateV2) {
          return _buildListLoaded();
        } else if (state is UnitListLoadingAsPagingState) {
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
          _getUnitListApiEvent(isSwipeToRefresh: false);
        }
      },
      // itemClickable: false,

      listPadding: EdgeInsets.symmetric(horizontal: 8.w),
      itemWidget: (int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: UintWidgetV2(
            cardClickCallback: _unitClickCallback,
            apartmentItemApiV2Model: getUpdatedData[index],
          ),
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getUnitListApiEvent(isSwipeToRefresh: true);
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
        _getUnitListApiEvent(isSwipeToRefresh: true);
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  UnitListBloc get currentBloc => BlocProvider.of<UnitListBloc>(context);

  void _getUnitListApiEvent({required bool isSwipeToRefresh}) {
    currentBloc
        .add(GetUniListApiEvent(_pagingInfo.currentPage + 1, isSwipeToRefresh));
  }

  bool get _hasNext => _pagingInfo.currentPage < _pagingInfo.totalPages;

  bool get _hasPrevious => _pagingInfo.currentPage > 1;

  void _resetPaging() {
    _pagingInfo = MetaModel.getEmptyOne();
    resetPagination();
  }

  void _unitClickCallback(ApartmentItemApiV2Model model) {
    UnitDetailsScreen.open(context, model.apartmentId ?? "",
        maxPerson: model.apartmentPersonsNo ?? 0);
  }
}
