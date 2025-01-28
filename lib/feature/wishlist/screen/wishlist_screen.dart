import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/models/apartments/wish_list/wish_item_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';
import 'package:vivas/feature/wishlist/bloc/wishlist_bloc.dart';
import 'package:vivas/feature/wishlist/bloc/wishlist_repository.dart';
import 'package:vivas/feature/wishlist/widget/wish_unit_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({Key? key}) : super(key: key);
  static const routeName = '/wishlist-screen';

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  static Future<void> open(
      BuildContext context,
      bool replacement,
      ) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(
        routeName,
      );
    } else {
      await Navigator.of(context).pushNamed(
        routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WishlistBloc>(
      create: (context) => WishlistBloc(WishlistRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentApiManger:ApartmentApiManger(dioApiManager,context),
      )),
      child: const WishlistScreenWithBloc(),
    );
  }
}

class WishlistScreenWithBloc extends BaseStatefulScreenWidget {
  const WishlistScreenWithBloc({super.key});

  @override
  BaseScreenState<WishlistScreenWithBloc> baseScreenCreateState() {
    return _WishlistScreenWithBloc();
  }
}

class _WishlistScreenWithBloc extends BaseScreenState<WishlistScreenWithBloc>
    with PaginationManager<WishItemApiModel> {
  late MetaModel _pagingInfo;
  bool isGuestMode = false;
  @override
  void initState() {
    _resetPaging();
    Future.microtask(() => _checkIsLoggedInEvent());

    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate(LocalizationKeys.wishlist)!),
      ),
      body: BlocListener<WishlistBloc, WishlistState>(
        listener: (context, state) {
          if (state is WishlistLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is WishlistErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is WishlistLoadedState) {
            _pagingInfo = state.pagingInfo;
            stopPaginationLoading();
            alignPaginationWithApi(_hasPrevious, _hasNext, state.list);
          } else if (state is WishlistLoadingAsPagingState) {
            startPaginationLoading();
          } else if (state is IsGuestModeState) {
            isGuestMode = true;
            AppBottomSheet.showLoginOrRegisterDialog(context);
          } else if (state is IsLoggedInState) {
            _getWishlistApiEvent(isSwipeToRefresh: false);
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
    return BlocBuilder<WishlistBloc, WishlistState>(
      builder: (context, state) {
        if (state is WishlistLoadedState) {
          return _buildListLoaded();
        } else if (state is WishlistLoadingAsPagingState) {
          return _buildListLoaded();
        } else {
          if (isGuestMode) return const EmptyWidget();
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

          _getWishlistApiEvent(isSwipeToRefresh: false);
        }
      },
      listPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemWidget: (int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: WishUintWidget(
            cardClickCallback: _unitClickCallback,
            wishItemApiModel: getUpdatedData[index],
          ),
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getWishlistApiEvent(isSwipeToRefresh: true);
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
        _getWishlistApiEvent(isSwipeToRefresh: true);
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  WishlistBloc get currentBloc => BlocProvider.of<WishlistBloc>(context);

  void _getWishlistApiEvent({required bool isSwipeToRefresh}) {
    currentBloc.add(
        GetWishlistApiEvent(_pagingInfo.currentPage + 1, isSwipeToRefresh));
  }

  void _checkIsLoggedInEvent() {
    currentBloc.add(CheckIsLoggedInEvent());
  }

  bool get _hasNext => _pagingInfo.currentPage < _pagingInfo.totalPages;

  bool get _hasPrevious => _pagingInfo.currentPage > 1;

  void _resetPaging() {
    _pagingInfo = MetaModel.getEmptyOne();
    resetPagination();
  }

  void _unitClickCallback(WishItemApiModel model) {
    UnitDetailsScreen.open(context, model.aptUuid);
  }
}
