import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// HTTP请求
class HttpManager {
  final String baseSiteId;
  static String authorization;

  HttpManager(this.baseSiteId);

  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  static Dio _instance;

  static Dio get instance => _getInstance();

  static Dio _getInstance() {
    if (_instance == null) {
      BaseOptions options = BaseOptions(
          baseUrl: GlobalConfigs.BASE_URL,
          connectTimeout: 5000,
          receiveTimeout: 10000,
          headers: {'Authorization': authorization});
      _instance = Dio(options);

      (_instance.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (client) {
        // you can also create a new HttpClient to dio
        // return new HttpClient();
        // 忽略证书
        HttpClient httpClient = new HttpClient()
          ..badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
        return httpClient;
      };

      _instance.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        // 在请求被发送之前做一些事情
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          throw -1; // network error
        }
        options.headers['Authorization'] = authorization;
        // return options; //continue
        // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
        //
        // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      }, onResponse: (Response response) {
        // 在返回响应数据之前做一些预处理
        if (GlobalConfigs.DEBUG) {
          if (response != null) {
            print('返回结果: ' + response.toString());
          }
        }
        _clearContext();
        return response; // continue
      }, onError: (DioError e) {
        // 当请求失败时做一些预处理
        if (GlobalConfigs.DEBUG) {
          print(e.toString());
        }

        // unauthorized
        if (e.response != null && e.response.statusCode == 401) {
          BuildContext currentContext =
              _instance.options.extra[GlobalConfigs.CURRENT_CONTEXT_KEY];
          assert(currentContext != null);
          Navigator.pushNamed(currentContext, GlobalRoutes.ROUTE_LOGIN);
          return null;
        }

        _clearContext();

        return e; //continue
      }));
    }

    return _instance;
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
    return instance.get(path,
        queryParameters: data, options: options, cancelToken: cancelToken);
  }

  Future<Response<T>> post<T>(
    String path, {
    BuildContext context,
    data,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) {
    _setContext(context);
    path = path.replaceAll('{baseSiteId}', baseSiteId);
    return instance.post(path,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<T>> put<T>(
    String path, {
    BuildContext context,
    data,
    Options options,
    CancelToken cancelToken,
  }) {
    _setContext(context);
    path = path.replaceAll('{baseSiteId}', baseSiteId);
    return instance.put(path,
        data: data, options: options, cancelToken: cancelToken);
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
    return instance.delete(path,
        data: data, options: options, cancelToken: cancelToken);
  }

  static _setContext(BuildContext context) {
    if (context != null) {
      instance.options.extra[GlobalConfigs.CURRENT_CONTEXT_KEY] = context;
    }
  }

  static _clearContext() {
    instance.options.extra[GlobalConfigs.CURRENT_CONTEXT_KEY] = null;
  }

  ///清除授权
  static clearAuthorization() {
    LocalStorage.remove(GlobalConfigs.ACCESS_TOKEN_KEY);
  }

  // ///获取授权token
  // static getAuthorization() async {
  //   String token = await LocalStorage.get(GlobalConfigs.ACCESS_TOKEN_KEY);
  //   if (token == null) {
  //     String basic = await LocalStorage.get(GlobalConfigs.BASIC_AUTH_TOKEN_KEY);
  //     if (basic == null) {
  //       // 提示输入账号密码
  //     } else {
  //       // 通过 basic 去获取token，获取到设置，返回token
  //       return "Basic $basic";
  //     }
  //   } else {
  //     return "Bearer $token";
  //   }
  // }

  ///初始化，获取授权token记录
  Future<void> initAuthorization() async {
    String token = await LocalStorage.get(GlobalConfigs.ACCESS_TOKEN_KEY);
    if (token == null) {
      String basic = await LocalStorage.get(GlobalConfigs.BASIC_AUTH_TOKEN_KEY);
      if (basic == null) {
        // 提示输入账号密码
      } else {
        authorization = "Basic $basic";
      }
    } else {
      authorization = "Bearer $token";
    }
  }
}

var http$ = HttpManager(GlobalConfigs.APP_BASE_SITE_ID);
