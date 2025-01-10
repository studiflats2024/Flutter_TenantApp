import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/app_linking.dart';
import 'package:vivas/app_route.dart';
import 'package:vivas/feature/auth/login/screen/login_screen.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/feature/splash/bloc/splash_bloc.dart';
import 'package:vivas/feature/splash/bloc/splash_repository.dart';
import 'package:vivas/feature/widgets/MaintenanceApp/maintenance_app.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/empty_result/status_widget.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';
  final AppLinksDeepLink? appLinksDeepLink;
  SplashScreen({Key? key, this.appLinksDeepLink}) : super(key: key);

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(SplashRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        generalApiManger: GeneralApiManger(dioApiManager, context),
      )),
      child:  SplashScreenWithBloc(appLinksDeepLink: appLinksDeepLink,),
    );
  }
}

class SplashScreenWithBloc extends BaseStatefulScreenWidget {
  final AppLinksDeepLink? appLinksDeepLink;

  const SplashScreenWithBloc({this.appLinksDeepLink, Key? key})
      : super(key: key);

  @override
  BaseScreenState<SplashScreenWithBloc> baseScreenCreateState() =>
      _SplashScreenWithBlocState();
}

class _SplashScreenWithBlocState extends BaseScreenState<SplashScreenWithBloc> {
  var preferencesManager = GetIt.I<PreferencesManager>();

  @override
  void initState() {
    _getAreaList();
    _getCityList();
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is AreaLoadedState) {
          /// to start time to switch to another screen
          _startTime();
        }
      },
      child: Scaffold(
        body: _backgroundImage(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _backgroundImage() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(AppAssetPaths.splashBackground, fit: BoxFit.cover),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  /// time to switch with dummy screen
  Future<Timer> _startTime() async {
    var duration = const Duration(milliseconds: 1500);
    return Timer(duration, _navigationPage);
  }

  SplashBloc get currentBloc => BlocProvider.of<SplashBloc>(context);

  void _getAreaList() {
    currentBloc.add(GetAreaListApi());
  }

  void _getCityList() {
    currentBloc.add(GetCityListApi());
  }

  /// navigate to next screen
  Future<void> _navigationPage() async {
    try {
      bool isDown = await preferencesManager.isDown();
      if (isDown) {
        _openMaintenanceScreen();
        //_openMaintenance();
      } else {
        bool isLogged = await preferencesManager.isLoggedIn();

          if (isLogged) {
            _openHomeScreen();
          } else {
            _openLoginScreen();
        }
      }
    } catch (error) {
      _openMaintenanceScreen();
    }
  }

  void _openLoginScreen() async {
    LoginScreen.open(context, appLinksDeepLink: widget.appLinksDeepLink, isRoute: true);

  }

  void _openMaintenanceScreen() async {
    MaintenanceApp.open(context);
  }

  void _openHomeScreen() async {
    BottomNavigationScreen.open(context, 0,
        appLinksDeepLink: widget.appLinksDeepLink);
    // await Navigator.of(context).pushNamedAndRemoveUntil(
    //      BottomNavigationScreen.routeName, ((route) => false));
  }

  Widget _noUnitData() {
    return StatusWidget.lostConnection(onAction: () {
      _getAreaList();
      _getCityList();
    });
  }
}
