import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/complaints_api_manger.dart';
import 'package:vivas/apis/models/complaint/list/complaint_api_model.dart';
import 'package:vivas/feature/complaints/bloc/complaints_repository.dart';
import 'package:vivas/feature/complaints/bloc/complaints_bloc.dart';
import 'package:vivas/feature/complaints/screen/complaints_details_screen.dart';
import 'package:vivas/feature/complaints/screen/send_complaints_screen.dart';
import 'package:vivas/feature/complaints/widgets/complaints_item_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_list_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';

class ComplaintsListScreen extends StatelessWidget {
  ComplaintsListScreen({Key? key}) : super(key: key);
  static const routeName = '/complaints-screen';

  static open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ComplaintsBloc>(
      create: (context) => ComplaintsBloc(ComplaintsRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        complaintsApiManger: ComplaintsApiManger(dioApiManager , context),
      )),
      child: const ComplaintsScreenWithBloc(),
    );
  }
}

class ComplaintsScreenWithBloc extends BaseStatefulScreenWidget {
  const ComplaintsScreenWithBloc({super.key});

  @override
  BaseScreenState<ComplaintsScreenWithBloc> baseScreenCreateState() {
    return _ComplaintsScreenWithBloc();
  }
}

class _ComplaintsScreenWithBloc
    extends BaseScreenState<ComplaintsScreenWithBloc> {
  List<ComplaintApiModel> _complaintList = [];
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getComplaintsApiEvent());
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.complaints)!),
      ),
      body: BlocListener<ComplaintsBloc, ComplaintsState>(
        listener: (context, state) {
          if (state is ComplaintsLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is ComplaintsErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is ComplaintsListLoadedState) {
            _complaintList = state.list;
          }
        },
        child: Column(
          children: [
            Expanded(
              child: _complaintsWidget(),
            ),
            SubmitButtonWidget(
              title: translate(LocalizationKeys.sendComplaint)!,
              onClicked: _sendComplaintClicked,
            ),
          ],
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _complaintsWidget() {
    return BlocBuilder<ComplaintsBloc, ComplaintsState>(
      buildWhen: (previous, current) {
        if (current is ComplaintsListLoadedState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ComplaintsListLoadedState) {
          return _buildListLoaded();
        } else {
          return const LoaderWidget();
        }
      },
    );
  }

  Widget _buildListLoaded() {
    if (_complaintList.isEmpty) {
      return _noUnitData();
    }
    return PagingSwipeToRefreshListWidget(
      widgetAboveList: _titleWidget(),
      reachedEndOfScroll: () {},
      itemWidget: (int index) {
        return ComplaintItemWidget(
          complaintApiModel: _complaintList[index],
          seeDetailsClickCallBack: () =>
              _seeDetailsClicked(_complaintList[index]),
        );
      },
      listPadding: const EdgeInsets.symmetric(horizontal: 20),
      swipedToRefresh: _getComplaintsApiEvent,
      listLength: _complaintList.length,
      showPagingLoader: false,
      itemClickable: false,
    );
  }

  Widget _noUnitData() {
    return PagingSwipeToRefreshListWidget(
      reachedEndOfScroll: () {},
      itemClickable: false,
      itemWidget: (int index) {
        return NoResultFoundWidget();
      },
      swipedToRefresh: () {
        _getComplaintsApiEvent();
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            translate(LocalizationKeys.complaints)!,
            style: const TextStyle(
              color: Color(0xFF505050),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            translate(LocalizationKeys.followUpYourComplaintsFromHere)!,
            style: const TextStyle(
              color: Color(0xFF676767),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  ComplaintsBloc get currentBloc => BlocProvider.of<ComplaintsBloc>(context);

  void _getComplaintsApiEvent() {
    currentBloc.add(const GetComplaintsApiEvent());
  }

  Future<void> _seeDetailsClicked(ComplaintApiModel complaintList) async {
    await ComplaintsDetailsScreen.open(context, complaintList.ticketID);
  }

  Future<void> _sendComplaintClicked() async {
    await SendComplaintsScreen.open(context)
        .then((value) => _getComplaintsApiEvent());
  }
}
