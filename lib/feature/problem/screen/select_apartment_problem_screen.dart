import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/problems_api_manger.dart';
import 'package:vivas/apis/models/my_problems/user_apartments_api_model.dart';
import 'package:vivas/feature/contact_support/screen/chat_screen.dart';
import 'package:vivas/feature/problem/bloc/my_problem_bloc.dart';
import 'package:vivas/feature/problem/bloc/my_problem_repository.dart';
import 'package:vivas/feature/problem/screen/report_apartment_screen.dart';
import 'package:vivas/feature/problem/widgets/problem_uint_info_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';

class SelectApartmentProblemScreen extends StatelessWidget {
  SelectApartmentProblemScreen({Key? key}) : super(key: key);
  static const routeName = '/select_apartment_problem_screen';
  static const argumentOpenChat = 'argumentOpenChatScreen';

  static open(BuildContext context, {bool openChatScreen = false}) async {
    await Navigator.of(context).pushNamed(
      routeName,
      arguments: {argumentOpenChat: openChatScreen},
    );
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyProblemBloc>(
      create: (context) => MyProblemBloc(MyProblemRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        problemsApiManger: ProblemsApiManger(dioApiManager , context),
      )),
      child:
          SelectApartmentProblemScreenWithBloc(argumentOpenChatScreen(context)),
    );
  }

  bool argumentOpenChatScreen(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentOpenChat]
          as bool;
}

class SelectApartmentProblemScreenWithBloc extends BaseStatefulScreenWidget {
  final bool openChatScreen;

  const SelectApartmentProblemScreenWithBloc(this.openChatScreen, {super.key});

  @override
  BaseScreenState<SelectApartmentProblemScreenWithBloc>
      baseScreenCreateState() {
    return _SelectApartmentProblemScreenWithBloc();
  }
}

class _SelectApartmentProblemScreenWithBloc
    extends BaseScreenState<SelectApartmentProblemScreenWithBloc> {
  List<UserApartmentsApiModel> _listApartment = [];

  @override
  void initState() {
    Future.microtask(() => _getUserApartmentsApiEvent());
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.selectApartment)!),
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
          } else if (state is UserApartmentsLoadedState) {
            _listApartment = state.list;
            _checkIfOnlyOneItem();
          }
        },
        child: _myProblemWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _myProblemWidget() {
    return BlocBuilder<MyProblemBloc, MyProblemState>(
      buildWhen: (previous, current) {
        if (current is UserApartmentsLoadedState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is UserApartmentsLoadedState) {
          return _buildListLoaded();
        } else {
          return const LoaderWidget();
        }
      },
    );
  }

  Widget _buildListLoaded() {
    if (_listApartment.isEmpty) {
      return NoResultFoundWidget();
    }
    return ListView.builder(
      itemBuilder: (context, index) => ProblemUintInfoWidget(
        title: _listApartment[index].aptName,
        address: _listApartment[index].aptAddress,
        imageUrl: _listApartment[index].imageUrl,
        cardClickCallback: () => _unitClicked(_listApartment[index]),
      ),
      itemCount: _listApartment.length,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  MyProblemBloc get currentBloc => BlocProvider.of<MyProblemBloc>(context);

  void _getUserApartmentsApiEvent() {
    currentBloc.add(GetUserApartmentsApiEvent());
  }

  Future<void> _unitClicked(
    UserApartmentsApiModel userApartmentsApiModel,
  ) async {
    if (widget.openChatScreen) {
      await ChatScreen.open(context, unitUUID: userApartmentsApiModel.aptUUID);
    } else {
      await ReportApartmentScreen.open(context, userApartmentsApiModel.aptUUID);
    }
  }

  Future<void> _checkIfOnlyOneItem() async {
    if (widget.openChatScreen) {
      if (_listApartment.isEmpty) {
        await ChatScreen.open(context,
            unitUUID: null, openWithReplacement: true);
      } else if (_listApartment.length == 1) {
        await ChatScreen.open(context,
            unitUUID: _listApartment.first.aptUUID, openWithReplacement: true);
      }
    }
  }
}
