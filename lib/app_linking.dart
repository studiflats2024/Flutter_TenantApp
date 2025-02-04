import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/models/auth/login/login_successful_response.dart';
import 'package:vivas/feature/auth/login/screen/login_screen.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/DeepLink/deep_link_bloc.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

import 'app_route.dart';

enum AppLinkStatus { login, apartment }

class AppLinksDeepLink {
  AppLinksDeepLink._privateConstructor();

  static final AppLinksDeepLink _instance =
      AppLinksDeepLink._privateConstructor();

  static AppLinksDeepLink get instance => _instance;

  late AppLinks _appLinks;
  AppLinkStatus? status;
  String? id;
  StreamSubscription<Uri>? _linkSubscription;
  late DeepLinkBloc _deepLinkBloc;

  Future<void> init(deepLinkBloc) async {
    _deepLinkBloc = deepLinkBloc;
    _appLinks = AppLinks();
    await initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    // Check initial link if app was in cold state (terminated)

    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      var uri = Uri.parse(appLink.toString());
      await onGetLink(uri);
    }
    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uriValue) async {
        await onGetLink(uriValue);
      },
      onError: (err) {
      },
      onDone: () {
        _linkSubscription?.cancel();
      },
    );
  }

  onGetLink(Uri uri) async {
    // PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();
    // final token = await preferencesManager.getAccessToken();
    // if (uri.path == ApiKeys.ssoLoginUrl && token == null) {
    //   if (AppRoute.mainNavigatorKey.currentContext != null) {
    //     _deepLinkBloc.add(
    //       LogInEvent(
    //         token: token,
    //         loginSuccessfulResponse: LoginSuccessfulResponse(
    //             "Fast Login Successfully",
    //             uri.queryParameters["token"] ?? "",
    //             uri.queryParameters["refresh"] ?? "",
    //             uri.queryParameters["expire"] ?? "",
    //             uri.queryParameters["uuid"] ?? "",
    //             true),
    //       ),
    //     );
    //     LoginScreen.open(AppRoute.mainNavigatorKey.currentContext!);
    //   }
    // } else if (uri.path == ApiKeys.ssoLoginUrl && token != null) {
    //   showFeedbackMessage("You can't use this link because you are login");
    // } else
      if (uri.path.contains("Share") || uri.toString().contains("apartment") || uri.toString().contains("Apartment") ) {
      if (AppRoute.mainNavigatorKey.currentContext != null) {
        UnitDetailsScreen.open(AppRoute.mainNavigatorKey.currentContext!,
            uri.path.split("/").last);
      } else {
        // onGetLink(uri);
        id = uri.path.split("/").last;
        status = AppLinkStatus.apartment;
      }
    }
  }
}

// studiflats://apartment/5fb93250-34b3-405c-a5ac-420bf9817dc6
