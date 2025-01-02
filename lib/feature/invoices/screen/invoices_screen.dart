import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/invoices_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/invoices/bloc/invoices_bloc.dart';
import 'package:vivas/feature/invoices/bloc/invoices_repository.dart';
import 'package:vivas/feature/invoices/helper/filter_enum.dart';
import 'package:vivas/feature/invoices/screen/invoices_details_screen.dart';
import 'package:vivas/feature/invoices/widgets/invoices_item_widget.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found_lottie.dart';

class InvoicesScreen extends StatelessWidget {
  InvoicesScreen({Key? key}) : super(key: key);
  static const routeName = '/invoices-screen';

  static open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoicesBloc>(
      create: (context) => InvoicesBloc(InvoicesRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        invoicesApiManger: InvoicesApiManger(dioApiManager, context),
        paymentApiManger: PaymentApiManger(dioApiManager, context),
      )),
      child: const InvoiceWithFilterScreen(),
    );
  }
}

class InvoiceWithFilterScreen extends BaseStatefulScreenWidget {
  const InvoiceWithFilterScreen({super.key});

  @override
  BaseScreenState<InvoiceWithFilterScreen> baseScreenCreateState() {
    return _InvoiceWithFilterScreen();
  }
}

class _InvoiceWithFilterScreen extends BaseScreenState<InvoiceWithFilterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: InvoicesFilter.values.length);
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
        title: Text(translate(LocalizationKeys.invoices)!),
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
            tabs: InvoicesFilter.values
                .map((e) => Tab(child: Text(translate(e.getLocalizedKey)!)))
                .toList()),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          InvoicesFilterScreen(InvoicesFilter.all),
          InvoicesFilterScreen(InvoicesFilter.paid),
          InvoicesFilterScreen(InvoicesFilter.unpaid),
        ],
      ),
    );
  }
}

class InvoicesFilterScreen extends BaseStatefulScreenWidget {
  final InvoicesFilter invoicesFilter;

  const InvoicesFilterScreen(this.invoicesFilter, {super.key});

  @override
  BaseScreenState<InvoicesFilterScreen> baseScreenCreateState() {
    return _InvoicesFilterScreen();
  }
}

class _InvoicesFilterScreen extends BaseScreenState<InvoicesFilterScreen>
    with PaginationManager<InvoiceApiModel> {
  late MetaModel _pagingAllInfo;
  late MetaModel _pagingPaidInfo;
  late MetaModel _pagingUnPaidInfo;

  @override
  void initState() {
    _resetPaging();
    Future.microtask(() => _getInvoicesApiEvent(isSwipeToRefresh: false));
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocListener<InvoicesBloc, InvoicesState>(
      listener: (context, state) {
        if (state is InvoicesLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is InvoicesErrorState) {
          showFeedbackMessage(state.isLocalizationKey
              ? translate(state.errorMassage)!
              : state.errorMassage);
        } else if (state is InvoicesLoadedState) {
          if (widget.invoicesFilter == InvoicesFilter.all) {
            _pagingAllInfo = state.pagingInfo;
          } else if (widget.invoicesFilter == InvoicesFilter.paid) {
            _pagingPaidInfo = state.pagingInfo;
          } else {
            _pagingUnPaidInfo = state.pagingInfo;
          }
          stopPaginationLoading();
          alignPaginationWithApi(_hasPrevious, _hasNext, state.list);
        } else if (state is InvoicesLoadingAsPagingState) {
          startPaginationLoading();
        }
      },
      child: _invoicesWidget(),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _invoicesWidget() {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) {
        if (current is InvoicesLoadedState) {
          return true;
        } else if (current is InvoicesLoadingAsPagingState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is InvoicesLoadedState) {
          return _buildListLoaded();
        } else if (state is InvoicesLoadingAsPagingState) {
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
          _getInvoicesApiEvent(isSwipeToRefresh: false);
        }
      },
      itemWidget: (int index) {
        return InvoicesItemWidget(
          cardClickCallback: _invoiceClickCallback,
          invoiceApiModel: getUpdatedData[index],
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getInvoicesApiEvent(isSwipeToRefresh: true);
      },
      listLength: getUpdatedData.length,
      showPagingLoader: currentLoadingState,
    );
  }

  Widget _noUnitData() {
    return PagingSwipeToRefreshGridListWidget(
      reachedEndOfScroll: () {},
      itemWidget: (int index) {
        return Container(
          width: 300.r,
          margin: EdgeInsets.symmetric(vertical: 20.r),
          child:
            Align(
              alignment: Alignment.center,
              child: NoResultFoundLottieWidget(
              asset: AppAssetPaths.invoice,
              message: widget.invoicesFilter == InvoicesFilter.all
                  ? LocalizationKeys.noAllInvoices
                  : widget.invoicesFilter == InvoicesFilter.paid
                  ? LocalizationKeys.noPaidInvoicesHere
                  : LocalizationKeys.noUnPaidInvoicesHere,
              multiLan: true,

            ),)
           ,
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getInvoicesApiEvent(isSwipeToRefresh: true);
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  InvoicesBloc get currentBloc => BlocProvider.of<InvoicesBloc>(context);

  void _getInvoicesApiEvent({required bool isSwipeToRefresh}) {
    currentBloc.add(GetInvoicesApiEvent(
        (widget.invoicesFilter == InvoicesFilter.all
                ? _pagingAllInfo.currentPage
                : widget.invoicesFilter == InvoicesFilter.paid
                    ? _pagingPaidInfo.currentPage
                    : _pagingUnPaidInfo.currentPage) +
            1,
        isSwipeToRefresh,
        widget.invoicesFilter));
  }

  bool get _hasNext =>
      (widget.invoicesFilter == InvoicesFilter.all
          ? _pagingAllInfo.currentPage
          : widget.invoicesFilter == InvoicesFilter.paid
              ? _pagingPaidInfo.currentPage
              : _pagingUnPaidInfo.currentPage) <
      (widget.invoicesFilter == InvoicesFilter.all
          ? _pagingAllInfo.totalPages
          : widget.invoicesFilter == InvoicesFilter.paid
              ? _pagingPaidInfo.totalPages
              : _pagingUnPaidInfo.totalPages);

  bool get _hasPrevious =>
      (widget.invoicesFilter == InvoicesFilter.all
          ? _pagingAllInfo.currentPage
          : widget.invoicesFilter == InvoicesFilter.paid
              ? _pagingPaidInfo.currentPage
              : _pagingUnPaidInfo.currentPage) >
      1;

  void _resetPaging() {
    if (widget.invoicesFilter == InvoicesFilter.all) {
      _pagingAllInfo = MetaModel.getEmptyOne();
    } else if (widget.invoicesFilter == InvoicesFilter.paid) {
      _pagingPaidInfo = MetaModel.getEmptyOne();
    } else {
      _pagingUnPaidInfo = MetaModel.getEmptyOne();
    }

    resetPagination();
  }

  void _invoiceClickCallback(InvoiceApiModel model) {
    InvoicesDetailsScreen.open(context, model.invId);
  }
}
