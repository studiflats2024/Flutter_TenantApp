import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/problems_api_manger.dart';
import 'package:vivas/apis/models/my_problems/problem_details_api_model.dart';
import 'package:vivas/feature/problem/bloc/my_problem_bloc.dart';
import 'package:vivas/feature/problem/bloc/my_problem_repository.dart';
import 'package:vivas/feature/problem/widgets/edit_problem_widget.dart';
import 'package:vivas/feature/problem/widgets/problem_details_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ProblemDetailsScreen extends StatelessWidget {
  ProblemDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/problem-details-screen';
  static const argumentProblemId = 'problemId';

  static open(BuildContext context, String problemId) async {
    await Navigator.of(context)
        .pushNamed(routeName, arguments: {argumentProblemId: problemId});
  }

  String problemId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentProblemId]
          as String;

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyProblemBloc>(
      create: (context) => MyProblemBloc(MyProblemRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        problemsApiManger: ProblemsApiManger(dioApiManager , context),
      )),
      child: ProblemDetailsWithBlocScreen(problemId(context)),
    );
  }
}

class ProblemDetailsWithBlocScreen extends BaseStatefulScreenWidget {
  final String problemId;
  const ProblemDetailsWithBlocScreen(this.problemId, {super.key});

  @override
  BaseScreenState<ProblemDetailsWithBlocScreen> baseScreenCreateState() {
    return _ProblemDetailsWithBlocScreen();
  }
}

class _ProblemDetailsWithBlocScreen
    extends BaseScreenState<ProblemDetailsWithBlocScreen> {
  ProblemDetailsApiModel? problemDetailsApiModel;
  @override
  void initState() {
    Future.microtask(_getProblemDetailsApiEvent);
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.problemDetails)!),
      ),
      body: BlocListener<MyProblemBloc, MyProblemState>(
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
          } else if (state is ProblemDetailsLoadedState) {
            problemDetailsApiModel = state.problemDetailsApiModel;
          } else if (state is EditProblemSuccessfullyState) {
            showFeedbackMessage(state.addProblemResponse.message);
            _getProblemDetailsApiEvent();
          }
        },
        child: _problemDetailsWidget(),
      ),
    );
  }
  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _problemDetailsWidget() {
    return BlocBuilder<MyProblemBloc, MyProblemState>(
      builder: (context, state) {
        if (state is ProblemDetailsLoadedState) {
          return ProblemDetailsWidget(
            problemDetailsApiModel: state.problemDetailsApiModel,
            editClickedCallBack: _openEditWidget,
          );
        } else if (state is MyProblemLoadingState) {
          return const LoaderWidget();
        } else {
          if (problemDetailsApiModel != null) {
            return ProblemDetailsWidget(
              problemDetailsApiModel: problemDetailsApiModel!,
              editClickedCallBack: _openEditWidget,
            );
          }
          return const EmptyWidget();
        }
      },
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  MyProblemBloc get currentBloc => BlocProvider.of<MyProblemBloc>(context);

  void _getProblemDetailsApiEvent() {
    currentBloc.add(GetProblemDetailsApiEvent(widget.problemId));
  }

  void _openEditWidget() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: EditProblemWidget(
            description: problemDetailsApiModel!.issueDesc,
            sendCallBack: editDescriptionApi),
        title: translate(LocalizationKeys.editProblemDescription)!);
  }

  void editDescriptionApi(String newDescription) {
    currentBloc.add(EditDescriptionApiEvent(widget.problemId, newDescription));
  }
}
