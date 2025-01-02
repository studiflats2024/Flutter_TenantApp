import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/apis/models/general/terms_conditions_model.dart';
import 'package:vivas/feature/app_pages/bloc/app_pages_bloc.dart';
import 'package:vivas/feature/app_pages/bloc/app_pages_repository.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class TermsConditionsScreen extends StatelessWidget {
  TermsConditionsScreen({Key? key}) : super(key: key);
  static const routeName = '/terms-conditions-screen';

  static Future<void> open(BuildContext context) async {
    Navigator.of(context).pushNamed(routeName);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppPagesBloc>(
      create: (context) => AppPagesBloc(AppPagesRepository(
        generalApiManger:GeneralApiManger(dioApiManager,context),
      )),
      child: const TermsConditionsScreenWithBloc(),
    );
  }
}

class TermsConditionsScreenWithBloc extends BaseStatefulScreenWidget {
  const TermsConditionsScreenWithBloc({super.key});

  @override
  BaseScreenState<TermsConditionsScreenWithBloc> baseScreenCreateState() {
    return _TermsConditionsScreenWithBloc();
  }
}

class _TermsConditionsScreenWithBloc
    extends BaseScreenState<TermsConditionsScreenWithBloc> {
  TermsConditionsModel? _termsConditionsModel;

  @override
  void initState() {
    Future.microtask(_getTermsConditionsApiEvent);
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate(LocalizationKeys.terms)!)),
      body: BlocListener<AppPagesBloc, AppPagesState>(
        listener: (context, state) {
          if (state is AppPageLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is AppPageErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is TermsConditionsLoadedState) {
            _termsConditionsModel = state.termsConditions;
          }
        },
        child: _detailsWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _detailsWidget() {
    return BlocBuilder<AppPagesBloc, AppPagesState>(
      builder: (context, state) {
        if (state is AppPageLoadingState) {
          return const LoaderWidget();
        } else if (state is TermsConditionsLoadedState) {
          return _contentPage();
        } else {
          return const EmptyWidget();
        }
      },
    );
  }

  Widget _contentPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [Text(_termsConditionsModel?.content ?? "")],
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  AppPagesBloc get currentBloc => BlocProvider.of<AppPagesBloc>(context);

  void _getTermsConditionsApiEvent() {
    currentBloc.add(const GetTermsConditionsApiEvent());
  }
}
