import 'package:connectivity/connectivity.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';

/// HTTP请求
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  static Dio _instance;

  static Dio get instance => _getInstance();

  static Dio _getInstance() {
    if (_instance == null) {
      Options options = Options(
        baseUrl: AppConfig.BASE_URL,
        connectTimeout: 5000,
        receiveTimeout: 10000,
      );
      _instance = Dio(options);

      _instance.interceptor.request.onSend = (Options options) async {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          throw -1; // network error
        }

        // 在请求被发送之前做一些事情
        options.headers['Authorization'] = getAuthorization();
        return options; //continue
        // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
        //
        // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      };

      _instance.interceptor.response.onSuccess = (Response response) {
        if (AppConfig.DEBUG) {
          if (response != null) {
            print('返回参数: ' + response.toString());
          }
        }

        // 在返回响应数据之前做一些预处理
        return response; // continue
      };

      _instance.interceptor.response.onError = (DioError e) {
        // 当请求失败时做一些预处理
        if (AppConfig.DEBUG) {
          print(e.toString());
        }

        return e; //continue
      };
    }

    return _instance;
  }

  ///清除授权
  static clearAuthorization() {
    LocalStorage.remove(AppConfig.ACCESS_TOKEN_KEY);
  }

  ///获取授权token
  static getAuthorization() async {
    String token = await LocalStorage.get(AppConfig.ACCESS_TOKEN_KEY);
    if (token == null) {
      String basic = await LocalStorage.get(AppConfig.BASIC_AUTH_TOKEN_KEY);
      if (basic == null) {
        // 提示输入账号密码
      } else {
        // 通过 basic 去获取token，获取到设置，返回token
        return "Basic $basic";
      }
    } else {
      return "Bearer $token";
    }
  }
}
