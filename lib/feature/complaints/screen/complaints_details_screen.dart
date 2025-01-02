import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/complaints_api_manger.dart';
import 'package:vivas/apis/models/complaint/details/details.api.model.dart';
import 'package:vivas/apis/models/complaint/reply/reply_complaint_send_model.dart';
import 'package:vivas/feature/complaints/bloc/complaints_repository.dart';
import 'package:vivas/feature/complaints/bloc/complaints_bloc.dart';
import 'package:vivas/feature/complaints/widgets/complaints_details_widget.dart';
import 'package:vivas/feature/complaints/widgets/send_replay_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_list_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ComplaintsDetailsScreen extends StatelessWidget {
  ComplaintsDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/complaints-details-screen';
  static const argumentTicketId = 'ticketId';

  static open(BuildContext context, String ticketId) async {
    await Navigator.of(context)
        .pushNamed(routeName, arguments: {argumentTicketId: ticketId});
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ComplaintsBloc>(
      create: (context) => ComplaintsBloc(ComplaintsRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        complaintsApiManger: ComplaintsApiManger(dioApiManager , context),
      )),
      child: ComplaintsDetailsScreenWithBloc(ticketId(context)),
    );
  }

  String ticketId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentTicketId]
          as String;
}

class ComplaintsDetailsScreenWithBloc extends BaseStatefulScreenWidget {
  final String ticketId;
  const ComplaintsDetailsScreenWithBloc(this.ticketId, {super.key});

  @override
  BaseScreenState<ComplaintsDetailsScreenWithBloc> baseScreenCreateState() {
    return _ComplaintsDetailsScreenWithBloc();
  }
}

class _ComplaintsDetailsScreenWithBloc
    extends BaseScreenState<ComplaintsDetailsScreenWithBloc> {
  ComplaintDetailsApiModel? _complaintDetailsApiModel;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getComplaintsApiEvent());
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.complaintDetails)!),
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
          } else if (state is ComplaintsDetailsLoadedState) {
            _complaintDetailsApiModel = state.complaintDetailsApiModel;
          } else if (state is ComplaintsAddSuccessfullyState) {
            showFeedbackMessage(state.message);
            _getComplaintsApiEvent();
          }
        },
        child: Column(
          children: [
            Expanded(
                child: PagingSwipeToRefreshListWidget(
              reachedEndOfScroll: () {},
              itemClickable: false,
              itemWidget: (int index) {
                return _complaintsWidget();
              },
              swipedToRefresh: () {
                _getComplaintsApiEvent();
              },
              listLength: 1,
              showPagingLoader: false,
            )),
            SubmitButtonWidget(
              title: translate(LocalizationKeys.sendMessage)!,
              onClicked: _sendMessageClicked,
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
        if (current is ComplaintsDetailsLoadedState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ComplaintsLoadingState) {
          return const LoaderWidget();
        } else if (state is ComplaintsDetailsLoadedState) {
          return ComplaintsDetailsWidget(
              complaintDetailsApiModel: state.complaintDetailsApiModel);
        } else {
          if (_complaintDetailsApiModel == null) {
            return const EmptyWidget();
          } else {
            return ComplaintsDetailsWidget(
                complaintDetailsApiModel: _complaintDetailsApiModel!);
          }
        }
      },
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  ComplaintsBloc get currentBloc => BlocProvider.of<ComplaintsBloc>(context);

  void _getComplaintsApiEvent() {
    currentBloc.add(GetComplaintDetailsApiEvent(widget.ticketId));
  }

  void _replyComplaintApiEvent(String message, String uploadedImagePath) {
    currentBloc.add(ReplyComplaintApiEvent(ReplyComplaintSendModel(
      attach: uploadedImagePath,
      replyDesc: message,
      ticketID: widget.ticketId,
    )));
  }

  void _sendMessageClicked() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: SendReplayWidget(saveCallBack: _replyComplaintApiEvent),
        title: translate(LocalizationKeys.sendMessage)!);
  }
}
