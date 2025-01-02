import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_dialog_widget.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/complaints_api_manger.dart';
import 'package:vivas/apis/models/complaint/create/create_ticket_send_model.dart';
import 'package:vivas/feature/complaints/bloc/complaints_repository.dart';
import 'package:vivas/feature/complaints/bloc/complaints_bloc.dart';
import 'package:vivas/feature/complaints/widgets/send_complaints_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_field/custom_drop_down_form_filed_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class SendComplaintsScreen extends StatelessWidget {
  SendComplaintsScreen({Key? key}) : super(key: key);
  static const routeName = '/send-complaints-screen';

  static Future<void> open(BuildContext context) async {
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
      child: const ComplaintsDetailsScreenWithBloc(),
    );
  }
}

class ComplaintsDetailsScreenWithBloc extends BaseStatefulScreenWidget {
  const ComplaintsDetailsScreenWithBloc({super.key});

  @override
  BaseScreenState<ComplaintsDetailsScreenWithBloc> baseScreenCreateState() {
    return _ComplaintsDetailsScreenWithBloc();
  }
}

class _ComplaintsDetailsScreenWithBloc
    extends BaseScreenState<ComplaintsDetailsScreenWithBloc> {
  List<String> _listType = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String _type = "";
  String _details = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getComplaintsTypeApiEvent());
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
          } else if (state is FormNotValidatedState) {
            autovalidateMode = AutovalidateMode.always;
          } else if (state is FormValidatedState) {
            _createTicketApiEvent();
          } else if (state is ComplaintsTypeLoadedState) {
            _listType = state.list;
          } else if (state is ComplaintsAddSuccessfullyState) {
            showSuccessDialog(state.message);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: _complaintsWidget()),
            ),
            SubmitButtonWidget(
              title: translate(LocalizationKeys.send)!,
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
        if (current is ComplaintsTypeLoadedState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ComplaintsLoadingState) {
          return const LoaderWidget();
        } else if (state is ComplaintsTypeLoadedState) {
          return SendComplaintsWidget(
            listType: state.list,
            typeSaved: _typeSaved,
            detailSaved: _detailSaved,
          );
        } else {
          return SendComplaintsWidget(
            listType: _listType,
            typeSaved: _typeSaved,
            detailSaved: _detailSaved,
          );
        }
      },
    );
  }

  void showSuccessDialog(String description) {
    showAppDialog(
      context: context,
      dialogWidget: _buildEditSuccessfullyWidget(description),
      shouldPop: true,
    );
  }

  Widget _buildEditSuccessfullyWidget(String description) {
    return Wrap(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 21, right: 19, bottom: 41),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate(LocalizationKeys.done)!,
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 24.spMin,
                          color: AppColors.lisTileTitle,
                        )),
                    SizedBox(height: 16.h),
                    SvgPicture.asset(AppAssetPaths.successIcon),
                    SizedBox(height: 16.h),
                    Text(description,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.editTitle,
                            fontSize: 16.spMin,
                            fontWeight: FontWeight.w500,
                            height: 2)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 19.0.h),
                child: SizedBox(
                  width: double.infinity,
                  child: AppElevatedButton.withTitle(
                    padding:
                        REdgeInsets.symmetric(vertical: 17, horizontal: 29),
                    onPressed: goBackClicked,
                    title: translate(LocalizationKeys.goBack)!,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  ComplaintsBloc get currentBloc => BlocProvider.of<ComplaintsBloc>(context);

  void _getComplaintsTypeApiEvent() {
    currentBloc.add(GetComplaintsTypeApiEvent());
  }

  void _createTicketApiEvent() {
    currentBloc.add(CreateTicketApiEvent(
        CreateTicketSendModel(ticketDesc: _details, ticketType: _type)));
  }

  void _typeSaved(CustomDropDownItem? value) {
    _type = value!.key;
  }

  void _detailSaved(String? value) {
    _details = value!;
  }

  void _sendMessageClicked() {
    currentBloc.add(ValidateFormEvent(formKey));
  }

  void goBackClicked() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
