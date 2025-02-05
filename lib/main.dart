import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_country_selector/flutter_country_selector.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:requests_inspector/requests_inspector.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/app_linking.dart';
import 'package:vivas/app_route.dart';
import 'package:vivas/feature/NewAppVersion/Presentations/ViewModel/app_version_bloc.dart';
import 'package:vivas/feature/NewAppVersion/Presentations/Views/version_checking_update.dart';
import 'package:vivas/feature/NewAppVersion/Presentations/Views/version_screen.dart';
import 'package:vivas/feature/add_or_remove_bookmark/bloc/add_remove_wish_bloc.dart';
import 'package:vivas/feature/add_or_remove_bookmark/bloc/add_remove_wish_repository.dart';
import 'package:vivas/feature/auth/login/screen/login_screen.dart';
import 'package:vivas/feature/splash/bloc/splash_repository.dart';
import 'package:vivas/feature/splash/splash_screen.dart';
import 'package:vivas/mangers/notification_manger.dart';
import 'package:vivas/mangers/search_manger.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/DeepLink/deep_link_bloc.dart';
import 'package:vivas/utils/bloc_observer/app_bloc_observer.dart';
import 'package:vivas/utils/build_type/build_type.dart';
import 'package:vivas/utils/locale/app_localization.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/locale/locale_cubit.dart';
import 'package:vivas/utils/locale/locale_repository.dart';
import 'package:vivas/utils/notification_handler/app_state.dart';
import 'package:vivas/utils/notification_handler/widget.dart';
import 'package:vivas/utils/theme/app_theme.dart';
import 'package:vivas/utils/theme/theme_cubit.dart';

import 'firebase_options.dart';

/*
 */

void main() async {
  // Ensure that the Flutter binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options for the current platform.
  if(Platform.isIOS){
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }else{
    await Firebase.initializeApp();
  }

  // Set up error handling for Flutter errors using Firebase Crashlytics.
  if (isReleaseMode()) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Set up error handling for platform errors using Firebase Crashlytics.
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Set the preferred device orientation to portrait up.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Register singletons for the PreferencesManager and DioApiManager using GetIt.
  GetIt.I.registerLazySingleton<PreferencesManager>(() => PreferencesManager());
  GetIt.I.registerLazySingleton<SearchManger>(() => SearchManger());
  GetIt.I.registerLazySingleton<DioApiManager>(() =>
      DioApiManager(GetIt.I<PreferencesManager>(), _failedToRefreshToken));
  GetIt.I.registerSingleton<NotificationManager>(NotificationManager());

  // Set the AppBlocObserver as the observer for all BLoCs.
  Bloc.observer = AppBlocObserver();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String version = packageInfo.version;
  // Run the application using the MyApp widget.

  runApp(BlocProvider(
    create: (context) => DeepLinkBloc(),
    child: isDevMode()
        ? RequestsInspector(
            enabled: true,
            showInspectorOn: ShowInspectorOn.Both,
            child: MyApp(
              packageInfo: packageInfo,
            ),
          )
        : MyApp(
            packageInfo: packageInfo,
          ),
  ));
}

void _failedToRefreshToken() {
  // Clear user data
  GetIt.I<PreferencesManager>().clearData();

  // Navigate to the login screen
  AppRoute.mainNavigatorKey.currentState?.pushNamedAndRemoveUntil(
    LoginScreen.routeName,
    (_) => false,
  );
}

class MyApp extends StatefulWidget {
  final PackageInfo? packageInfo;

  const MyApp({this.packageInfo, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  AppLinksDeepLink appLinksDeepLink = AppLinksDeepLink.instance;

  @override
  void initState() {
    Future.wait([appLinksDeepLink.init(context.read<DeepLinkBloc>())]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppVersionBloc(
            SplashRepository(
              preferencesManager: GetIt.I<PreferencesManager>(),
              generalApiManger:
                  GeneralApiManger(GetIt.I<DioApiManager>(), context),
            ),
          )..add(GetVersion(widget.packageInfo!.version)),
        ),
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(LocaleRepository(
              preferenceManager: GetIt.I<PreferencesManager>())),
        ),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<AddRemoveWishBloc>(
          create: (context) => AddRemoveWishBloc(
            AddRemoveWishRepository(
              preferencesManager: GetIt.I<PreferencesManager>(),
              apartmentApiManger:
                  ApartmentApiManger(GetIt.I<DioApiManager>(), context),
            ),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, BaseAppTheme>(
        builder: (context, appThemeState) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, state) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: appThemeState.themeDataLight.primaryColor,
                ),
                child: FirebaseNotificationsHandler(
                  onTap: _onNotificationClicked,
                  child: KeyboardDismisser(
                    gestures: Platform.isAndroid ? [] : [GestureType.onTap],
                    child: ScreenUtilInit(
                      designSize: const Size(375, 812),
                      builder: (context, child) => MaterialApp(
                        onGenerateTitle: (BuildContext context) =>
                            AppLocalizations.of(context)
                                ?.translate(LocalizationKeys.appName) ??
                            "Studi Flats",
                        debugShowCheckedModeBanner: isDevMode(),
                        theme: appThemeState.themeDataLight,
                        darkTheme: appThemeState.themeDataDark,
                        themeMode: ThemeMode.light,

                        /// the list of our supported locals for our app
                        /// currently we support only 2 English and Arabic ...
                        supportedLocales: AppLocalizations.supportedLocales,

                        /// these delegates make sure that the localization data
                        /// for the proper
                        /// language is loaded ...
                        localizationsDelegates: const [
                          /// A class which loads the translations from JSON files
                          AppLocalizations.delegate,

                          /// Built-in localization of basic text
                          ///  for Material widgets in Material
                          GlobalMaterialLocalizations.delegate,

                          /// Built-in localization for text direction LTR/RTL
                          GlobalWidgetsLocalizations.delegate,

                          /// Built-in localization for text direction LTR/RTL in Cupertino
                          GlobalCupertinoLocalizations.delegate,

                          DefaultCupertinoLocalizations.delegate,

                          /// A specific localization delegate for Country Picker
                          CountryLocalizations.delegate,

                          CountrySelectorLocalization.delegate,
                        ],
                        locale: state,
                        navigatorKey: AppRoute.mainNavigatorKey,
                        routes: AppRoute.routes,
                        home: BlocConsumer<AppVersionBloc, AppVersionState>(
                          listener: (context, state){
                          },
                          builder: (context, state) {
                            return state is AppVersionNeedToUpdate
                                ? VersionScreen(
                                    packageName:
                                        widget.packageInfo!.packageName,
                                  )
                                : state is AppVersionReadyForUse
                                    // ? WelcomeAuthScreen()
                                    ? SplashScreen(appLinksDeepLink: appLinksDeepLink,)
                                    : VersionChecking(
                                        version: widget.packageInfo!.version);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _onNotificationClicked(GlobalKey<NavigatorState> navigatorKey,
      AppState appState, Map payload) async {
    try {
      GetIt.I<NotificationManager>().notificationDataInfo(
          NotificationData.fromJson(payload as Map<String, dynamic>));
    } catch (e) {
      return;
    }
    if (appState != AppState.closed) {
      await GetIt.I<NotificationManager>().openNotification();
    }
  }
}
