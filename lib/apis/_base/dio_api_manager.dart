import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:requests_inspector/requests_inspector.dart';
import 'package:vivas/_core/platform_manager.dart';
import 'package:vivas/apis/models/refresh_token/refresh_token_send_model_api.dart';
import 'package:dio/dio.dart';
import 'package:vivas/apis/_base/refresh_token_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/build_type/build_type.dart';
import 'package:flutter/foundation.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

class DioApiManager with PlatformManager {
  final PreferencesManager preferenceManager;
  final VoidCallback failToRefreshTokenCallback;

  //  dio instance to request token
  DioApiManager(this.preferenceManager, this.failToRefreshTokenCallback);

  bool canRefreshToken = true;
  final _requestsInspectorInterceptor = RequestsInspectorInterceptor();
  final _logInterceptor = LogInterceptor(
    responseBody: true,
    requestBody: true,
    error: true,
    logPrint: (object) => log(object.toString()),
  );

  Dio get dioUnauthorized {
    return DioOptions.dioInstance(optionsUnauthorized)
      ..interceptors.clear()
      ..interceptors.addAll(
        [
          _queuedInterceptorsWrapperUnauthorized,
          if (isDevMode()) _requestsInspectorInterceptor,
          if (isDebugMode()) ...[
            _logInterceptor,
          ]
        ],
      );
  }

  Dio get dio {
    return DioOptions.dioInstance(options)
      ..interceptors.clear()
      ..interceptors.addAll(
        [
          _queuedInterceptorsWrapper,
          if (isDevMode()) _requestsInspectorInterceptor,
          if (isDebugMode()) ...[
            _logInterceptor,
          ]
        ],
      );
  }

  // todo --> handle this in a different class ...
  QueuedInterceptorsWrapper get _queuedInterceptorsWrapper {
    return QueuedInterceptorsWrapper(
      onRequest: (request, handler) async {
        String language = await preferenceManager.getLocale() ?? "ar";
        if (request.headers[ApiKeys.locale] != language) {
          request.headers[ApiKeys.locale] = language;
        }
        String? token = await preferenceManager.getAccessToken();
        String deviceToken = await (Platform.isIOS && isDebugMode()
                ?FirebaseMessaging.instance.getAPNSToken()
                :FirebaseMessaging.instance.getToken() ) ??
            "";
        request.headers[ApiKeys.keyType] = type;
        if (!token.isNullOrEmpty) {
          if (request.headers[ApiKeys.authorization] == null) {
            request.headers[ApiKeys.authorization] =
                '${ApiKeys.keyBearer} $token';
            request.headers[ApiKeys.devToken] = deviceToken;
          } else {
            request.headers[ApiKeys.devToken] = deviceToken;
          }
        } else {
          if (request.headers[ApiKeys.guestToken] == null) {
            request.headers[ApiKeys.guestToken] =
            await (Platform.isIOS && isDebugMode()
                ?FirebaseMessaging.instance.getAPNSToken()
                :FirebaseMessaging.instance.getToken() );
          }
        }
        return handler.next(request);
      },
      onResponse: (e, handler) {
        if (e.statusCode == 200) {
          canRefreshToken = true;
        }
        return handler.next(e);
      },
      onError: (error, handler) async {
        // Assume 401 stands for token expired
        if (error.response?.statusCode == 401 && canRefreshToken) {
          canRefreshToken = false;
          var options = error.response!.requestOptions;
          String? refreshToken = (await preferenceManager.getRefreshToken());
          String? accessToken = (await preferenceManager.getAccessToken());
          if (refreshToken == null) {
            handler.reject(error);
            return;
          }
          await RefreshTokenApiManager(dioUnauthorized).refreshTokenApi(
              RefreshTokenSendModelApi(refreshToken, accessToken!),
              (refreshTokenWrapper) async {
            // update token
            await preferenceManager
                .setAccessToken(refreshTokenWrapper.accessToken);
            options.headers[ApiKeys.authorization] =
                '${ApiKeys.keyBearer} ${refreshTokenWrapper.accessToken}';
            await dio.fetch(options).then(
              (r) => handler.resolve(r),
              onError: (e) {
                handler.reject(e);
              },
            );
          }, (errorApiModel) {
            handler.reject(error);
            failToRefreshTokenCallback();
          });
          return;
        }
        return handler.next(error);
      },
    );
  }

  QueuedInterceptorsWrapper get _queuedInterceptorsWrapperUnauthorized {
    return QueuedInterceptorsWrapper(
      onRequest: (request, handler) async {
        String? language = await preferenceManager.getLocale();
        if (request.headers[ApiKeys.locale] != language) {
          request.headers[ApiKeys.locale] = language ?? "ar";
        }
        request.headers[ApiKeys.keyType] = type;
        if (request.headers[ApiKeys.guestToken] == null) {
          request.headers[ApiKeys.guestToken] =
          await (Platform.isIOS && isDebugMode()
              ?FirebaseMessaging.instance.getAPNSToken()
              :FirebaseMessaging.instance.getToken());
        }
        return handler.next(request);
      },
    );
  }

  DioOptions options = DioOptions();
  DioOptions optionsUnauthorized = DioOptions();
}

class DioOptions extends BaseOptions {
  @override
  Map<String, dynamic> get headers {
    Map<String, dynamic> header = {};

    header.putIfAbsent(ApiKeys.accept, () => ApiKeys.applicationJson);
    header.putIfAbsent(ApiKeys.contentType, () => ApiKeys.applicationJson);

    return header;
  }

  @override
  String get baseUrl => ApiKeys.currentEnvironment;

  static Dio? dio;

  static Dio dioInstance(BaseOptions options) {
    dio ??= Dio(options);

    return dio!;
  }
}
