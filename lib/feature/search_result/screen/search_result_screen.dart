import 'package:flutter/gestures.dart';
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
import 'package:vivas/feature/filter/model/filter_model.dart';
import 'package:vivas/feature/make_request/model/request_ui_model.dart';
import 'package:vivas/feature/make_waiting_request/screen/make_waiting_request_screen.dart';
import 'package:vivas/feature/search/model/search_model.dart';
import 'package:vivas/feature/search_result/bloc/search_result_bloc.dart';
import 'package:vivas/feature/search_result/bloc/search_result_repository.dart';
import 'package:vivas/feature/search_result/widgets/waiting_list_widget.dart';
import 'package:vivas/feature/uint_widget/unit_widget.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';
import 'package:vivas/feature/widgets/search/search_bar_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/empty_result/status_widget.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class SearchResultScreen extends StatelessWidget {
  final FilterModel filterModel;
  final SearchModel searchModel;

  SearchResultScreen(
      {Key? key, required this.filterModel, required this.searchModel})
      : super(key: key);

  static open(
    BuildContext context, {
    bool withReplacement = false,
    required FilterModel filterModel,
    required SearchModel searchModel,
  }) async {
    if (withReplacement) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(
            filterModel: filterModel,
            searchModel: searchModel,
          ),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(
            filterModel: filterModel,
            searchModel: searchModel,
          ),
        ),
      );
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchResultBloc>(
      create: (context) => SearchResultBloc(SearchResultRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentApiManger: ApartmentApiManger(dioApiManager, context),
      )),
      child: SearchResultScreenWithBloc(
          filterModel: filterModel, searchModel: searchModel),
    );
  }
}

class SearchResultScreenWithBloc extends BaseStatefulScreenWidget {
  final FilterModel filterModel;
  final SearchModel searchModel;

  const SearchResultScreenWithBloc(
      {required this.filterModel, required this.searchModel, super.key});

  @override
  BaseScreenState<SearchResultScreenWithBloc> baseScreenCreateState() {
    return _SearchResultScreenWithBloc();
  }
}

class _SearchResultScreenWithBloc
    extends BaseScreenState<SearchResultScreenWithBloc>
    with PaginationManager<ApartmentItemApiModel> {
  late MetaModel _pagingInfo;

  late FilterModel _filterModel;
  late SearchModel _searchModel;
  bool _useAreaFromFlitter = false;

  @override
  void initState() {
    _filterModel = widget.filterModel;

    if (_filterModel.selectedAreaModel != null) {
      _useAreaFromFlitter = true;
    }
    _searchModel = widget.searchModel;
    _filterModel.selectedBedNumber = _searchModel.personNumber;
    Future.microtask(() => _getSearchResultApiAndRest());
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocListener<SearchResultBloc, SearchResultState>(
          listener: (context, state) {
            if (state is SearchResultLoadingState) {
              showLoading();
            } else {
              hideLoading();
            }
            if (state is SearchResultErrorState) {
              showFeedbackMessage(state.isLocalizationKey
                  ? translate(state.errorMassage)!
                  : state.errorMassage);
            } else if (state is SearchResultLoadedState) {
              _pagingInfo = state.pagingInfo;
              stopPaginationLoading();
              alignPaginationWithApi(_hasPrevious, _hasNext, state.list);
            } else if (state is SearchResultLoadingAsPagingState) {
              startPaginationLoading();
            }
          },
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SearchBarWidget(
                  filterModel: widget.filterModel,
                  searchModel: widget.searchModel,
                  filterSearchClicked: _searchClickedOnFilterScreen,
                  searchScreenClicked: _searchClickedOnSearchScreen,
                  fromHome: false,
                ),
              ),
              Expanded(child: _searchResultWidget()),
            ],
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _searchResultWidget() {
    return BlocBuilder<SearchResultBloc, SearchResultState>(
      builder: (context, state) {
        if (state is SearchResultLoadedState) {
          return _buildListLoaded();
        } else if (state is SearchResultLoadingAsPagingState) {
          return _buildListLoaded();
        } else {
          if (getUpdatedData.isNotEmpty) {
            return _noUnitData();
          } else {
            return const LoaderWidget();
          }
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
          _getSearchResultApiEvent(isSwipeToRefresh: false);
        }
      },
      itemWidget: (int index) {
        return UintWidget(
          cardClickCallback: _unitClickCallbackV2,
          apartmentItemApiModel: getUpdatedData[index],
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getSearchResultApiEvent(isSwipeToRefresh: true);
      },
      listLength: getUpdatedData.length,
      showPagingLoader: currentLoadingState,
      bottomOfList: WaitingListWidget(),
    );
  }

  Widget _noUnitData() {
    return PagingSwipeToRefreshGridListWidget(
      reachedEndOfScroll: () {},
      itemWidget: (int index) {
        return Center(
          child: StatusWidget.searchNotFound(
            onAction: _openSendWaitingRequestScreen,
            bottomWidget: Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${translate(LocalizationKeys.or)}\n",
                        style: const TextStyle(
                          color: Color(0xFF605D62),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text:
                            "${translate(LocalizationKeys.changeYourSearchCriteria)} ",
                        style: const TextStyle(
                          color: Color(0xFF605D62),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                          text: translate(LocalizationKeys.searchAgain),
                          style: const TextStyle(
                            height: 1.5,
                            color: Color(0xFF1151B4),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _resetPaging();
                              _getSearchResultApiEvent(isSwipeToRefresh: false);
                            }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getSearchResultApiEvent(isSwipeToRefresh: true);
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  SearchResultBloc get currentBloc =>
      BlocProvider.of<SearchResultBloc>(context);

  void _getSearchResultApiEvent({required bool isSwipeToRefresh}) {
    currentBloc.add(GetUniListWithSearchApiEvent(
      pageNumber: _pagingInfo.currentPage + 1,
      isSwipeToRefresh: isSwipeToRefresh,
      filterModel: _filterModel,
      searchModel: _searchModel,
      useAreaFromFlitter: _useAreaFromFlitter,
    ));
  }

  void _getSearchResultApiAndRest() {
    _resetPaging();
    _getSearchResultApiEvent(isSwipeToRefresh: false);
  }

  bool get _hasNext => _pagingInfo.currentPage < _pagingInfo.totalPages;

  bool get _hasPrevious => _pagingInfo.currentPage > 1;

  void _resetPaging() {
    _pagingInfo = MetaModel.getEmptyOne();
    resetPagination();
  }

  void _unitClickCallback(ApartmentItemApiModel model) {
    UnitDetailsScreen.open(context, model.aptUuid);
  }

  void _unitClickCallbackV2(ApartmentItemApiModel model) {
    UnitDetailsScreen.open(
      context,
      model.aptUuid ?? '',
      maxPerson: model.aptMaxGuest,
      requestUiModel: RequestUiModel(
        aptUUID: model.aptUuid ?? '',
        startDate: _searchModel.startDate,
        endDate: _searchModel.endDate,
        numberOfGuests: _searchModel.personNumber ?? 0,
      ),
    );
  }

  void _searchClickedOnFilterScreen(FilterModel filterModel) {
    _filterModel = filterModel;
    _searchModel.personNumber = _filterModel.selectedBedNumber??_searchModel.personNumber;
    _useAreaFromFlitter = filterModel.selectedAreaModel != null;

    _getSearchResultApiAndRest();
  }

  Future<void> _searchClickedOnSearchScreen(SearchModel searchModel) async {
    _searchModel = searchModel;
    _useAreaFromFlitter = searchModel.city == null;
    Navigator.pop(context);
    _getSearchResultApiAndRest();
  }

  void _openSendWaitingRequestScreen() {
    MakeWaitingRequestScreen.open(context);
  }
}
