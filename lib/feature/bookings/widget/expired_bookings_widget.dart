import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/bookings/bloc/bookings_bloc.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';
import 'package:vivas/feature/bookings/widget/booking_uint_widget.dart';
import 'package:vivas/feature/request_details/request_details/screen/request_details_screen.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';

class ExpiredBookingsWidget extends StatelessWidget {
  ExpiredBookingsWidget({Key? key}) : super(key: key);

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingsBloc>(
      create: (context) => BookingsBloc(BookingsRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentRequestsApiManger: ApartmentRequestsApiManger(dioApiManager, context),
      )),
      child: const BookingsScreenWithBloc(),
    );
  }
}

class BookingsScreenWithBloc extends BaseStatefulScreenWidget {
  const BookingsScreenWithBloc({super.key});

  @override
  BaseScreenState<BookingsScreenWithBloc> baseScreenCreateState() {
    return _BookingsScreenWithBloc();
  }
}

class _BookingsScreenWithBloc extends BaseScreenState<BookingsScreenWithBloc>
    with PaginationManager<ApartmentRequestsApiModel> {
  late MetaModel _pagingInfo;

  @override
  void initState() {
    super.initState();
    _resetPaging();
    Future.microtask(() => _getExpiredBookingsEvent(isSwipeToRefresh: false));
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      body: BlocListener<BookingsBloc, BookingsState>(
        listener: (context, state) {
          if (state is BookingsExpiredLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is BookingsErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is BookingsExpiredLoadedState) {
            _pagingInfo = state.pagingInfo;
            stopPaginationLoading();
            alignPaginationWithApi(_hasPrevious, _hasNext, state.list);
          } else if (state is BookingsExpiredLoadingAsPagingState) {
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
    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        if (state is BookingsExpiredLoadedState) {
          return _buildListLoaded();
        } else if (state is BookingsExpiredLoadingAsPagingState) {
          return _buildListLoaded();
        } else if (state is BookingsExpiredLoadingState) {
          return const LoaderWidget();
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

          _getExpiredBookingsEvent(isSwipeToRefresh: false);
        }
      },
      itemWidget: (int index) {
        return BookingUintWidget(
          cardClickCallback: _unitClickCallback,
          apartmentBookingModel: getUpdatedData[index],
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getExpiredBookingsEvent(isSwipeToRefresh: true);
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
        _getExpiredBookingsEvent(isSwipeToRefresh: true);
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  BookingsBloc get currentBloc => BlocProvider.of<BookingsBloc>(context);

  void _getExpiredBookingsEvent({required bool isSwipeToRefresh}) {
    currentBloc.add(
        GetExpiredBookingsEvent(_pagingInfo.currentPage + 1, isSwipeToRefresh));
  }

  bool get _hasNext => _pagingInfo.currentPage < _pagingInfo.totalPages;

  bool get _hasPrevious => _pagingInfo.currentPage > 1;

  void _resetPaging() {
    _pagingInfo = MetaModel.getEmptyOne();
    resetPagination();
  }

  void _unitClickCallback(ApartmentRequestsApiModel model) {
    RequestDetailsScreen.open(context, model.requestId);
  }
}
