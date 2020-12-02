import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:core/core.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:services/src/message/message_bloc.dart';
import 'package:services/src/net/net_state.dart';
import 'package:services/src/system/bloc/app_bloc.dart';
import 'package:services/src/user/bloc/user_bloc.dart';

/// HTTP请求
class HttpManager {
  final String baseSiteId;
  static String authorization;
  static String _token;

  HttpManager(this.baseSiteId);

  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  static Dio _instance;

  static Dio get instance => _getInstance();

  static Dio _getInstance() {
    if (_instance == null) {
      _updateInstance();
    }

    return _instance;
  }

  // 更新实列
  static void _updateInstance() {
    BaseOptions options = BaseOptions(
        baseUrl: GlobalConfigs.BASE_URL,
        connectTimeout: 10000,
        receiveTimeout: 10000,
        headers: authorization != null ? {'Authorization': authorization} : {});

    _instance = Dio(options);

    (_instance.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (client) {
      // 忽略证书
      HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      return httpClient;
    };

    _instance.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      print('***${DateTime.now()}***');
      options.headers['Authorization'] = authorization;

      // 所属信息
      options.headers['company'] = UserBLoC.instance.currentUser.companyCode;
      // if (GlobalConfigs.DEBUG) {
      //   print("REQUEST[${options?.method}] => PATH: ${options?.path}");
      // }
    }, onResponse: (Response response) {
      print('***${DateTime.now()}***');
      //更改网络状态
      if (NetState.instance != null) {
        NetState.instance.setConnectivityResult(ConnectivityResult.mobile);
      }
      AppBLoC.instance.setConnectivityResult(ConnectivityResult.mobile);
      _clearContext();
      // if (GlobalConfigs.DEBUG) {
      //   if (response != null) {
      //     print(
      //         "RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}>>>返回结果:${response?.data.toString()}");
      //   }
      // }
      return response; // continue
    }, onError: (DioError e) {
      print('***${DateTime.now()}***');
      //未登录或token失效
      if (e?.response != null && e.response.statusCode == 401) {
        //已登录，token失效
        if (UserBLoC.instance.currentUser.status == UserStatus.ONLINE) {
          //记录当前用户类型
          UserType userType = UserBLoC.instance.currentUser.type;
          //token过期，用户记录清空
          UserBLoC.instance.logout();
          UserBLoC.instance.changeUserType(userType);
        }
        UserBLoC.instance.loginJumpController.add(true);
        return e;
      } else if (e.type == DioErrorType.DEFAULT) {
        //更改网络状态
        if (NetState.instance != null) {
          NetState.instance.setConnectivityResult(ConnectivityResult.none);
        }
        AppBLoC.instance.setConnectivityResult(ConnectivityResult.none);
        // MessageBLoC.instance.snackMessageController.add('网络链接不可用');
        throw -1; // network error
      } else {
        // 消息流推送
        // ErrorResponse errorResponse = ErrorResponse.fromJson(e.response.data);
        // if (errorResponse.errors!= null) {
        //   MessageBLoC.instance.errorMessageController
        //       .add('${errorResponse.errors[0].message}');
        // }
        if (e.request.headers['ignoreAlert'] != 1) {
          StreamController streamController =
              MessageBLoC.instance.errorMessageController;
          // streamController.onResume;
          streamController.sink.add('网络异常');
        }
        _clearContext();
      }
      // if (GlobalConfigs.DEBUG) {
      //   print(
      //       "ERROR[${e?.response?.statusCode}] => PATH: ${e?.request?.path}>>>${e?.response?.data.toString()}");
      // }
      return e; //continue
    }));

    if (GlobalConfigs.DEBUG) {
      _instance.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    BuildContext context,
    data,
    Options options,
    CancelToken cancelToken,
  }) {
    _setContext(context);
    path = path.replaceAll('{baseSiteId}', baseSiteId);
    return instance.get(
      path,
      queryParameters: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    BuildContext context,
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) {
    _setContext(context);
    path = path.replaceAll('{baseSiteId}', baseSiteId);
    return instance.post(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    BuildContext context,
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) {
    _setContext(context);
    path = path.replaceAll('{baseSiteId}', baseSiteId);
    return instance.put(path,
        data: data,
        options: options,
        cancelToken: cancelToken,
        queryParameters: queryParameters);
  }

  Future<Response<T>> delete<T>(
    String path, {
    BuildContext context,
    data,
    Options options,
    CancelToken cancelToken,
  }) {
    _setContext(context);
    path = path.replaceAll('{baseSiteId}', baseSiteId);
    return instance.delete(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> download<T>(
    String path,
    String savePath, {
    BuildContext context,
    data,
    Options options,
    CancelToken cancelToken,
  }) {
    _setContext(context);
    path = path.replaceAll('{baseSiteId}', baseSiteId);
    return instance.download(
      path,
      savePath,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static _setContext(BuildContext context) {
    if (context != null) {
      instance.options.extra[GlobalConfigs.CURRENT_CONTEXT_KEY] = context;
    }
  }

  static _clearContext() {
    instance.options.extra[GlobalConfigs.CURRENT_CONTEXT_KEY] = null;
  }

  void initContext(BuildContext context) {
    context = context;
  }

  ///清除授权
  static clearAuthorization() {
    LocalStorage.remove(GlobalConfigs.ACCESS_TOKEN_KEY);
  }

  void updateAuthorization(token) {
    _token = '$token';
    authorization = "Bearer $_token";
    _updateInstance();
  }

  void removeAuthorization() {
    authorization = null;
    _token = null;
    _updateInstance();
  }

  String getToken() => _token;
}

var http$ = HttpManager(GlobalConfigs.B2B_API_PREFIX);
