import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/api/user.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/net/http_utils.dart';
import 'package:services/src/user/bloc/login.dart';

class UserBLoC extends BLoCBase {
  UserModel _user;

  // 工厂模式
  factory UserBLoC() => _getInstance();

  static UserBLoC get instance => _getInstance();
  static UserBLoC _instance;

  UserBLoC._internal() {
    // 初始化
    _user = UserModel.empty();
  }

  static UserBLoC _getInstance() {
    if (_instance == null) {
      _instance = UserBLoC._internal();
    }
    return _instance;
  }

  UserModel get currentUser {
    return _user;
  }

  bool get isBrandUser => _user.type == UserType.BRAND;

  bool get isFactoryUser => _user.type == UserType.FACTORY;

  bool get isAnonymousUser => !isBrandUser && !isFactoryUser;

  var _controller = StreamController<UserModel>.broadcast();

  Stream<UserModel> get stream => _controller.stream;

  StreamController _loginResultController =
      StreamController<DioError>.broadcast();

  Stream<DioError> get loginStream => _loginResultController.stream;

  Future<bool> login({String username, String password, bool remember}) async {
    // // login service
    Response loginResponse;
    try {
      loginResponse = await http$
          .post(HttpUtils.generateUrl(url: GlobalConfigs.AUTH_TOKEN_URL, data: {
        'username': username,
        'password': password,
        'grant_type': GlobalConfigs.GRANT_TYPE_PASSWORD,
        'client_id': 'asm', // TODO:
        'client_secret': 'password' // TODO:
      }));
    } on DioError catch (e) {
      print(e);
      //登陆错误回调
      _loginResultController.sink.add(e);
    }

    if (loginResponse != null && loginResponse.statusCode == 200) {
      LoginResponse _response = LoginResponse.fromJson(loginResponse.data);

      // 记录http token 信息
      http$.updateAuthorization(_response.accessToken);

      // 获取用户信息
      Response infoResponse;
      try {
        infoResponse = await http$.get(UserApis.userInfo);
      } on DioError catch (e) {
        print(e);
      }

      if (infoResponse != null && infoResponse.statusCode == 200) {
        _user = UserModel.fromJson(infoResponse.data);
        _user.name = infoResponse.data['username'];
      }

      //  记录登陆用户信息
      if (remember) {
        LocalStorage.save(
            GlobalConfigs.REFRESH_TOKEN_KEY, _response.refreshToken);
        LocalStorage.save(GlobalConfigs.USER_KEY, username);
      }
      _controller.sink.add(_user);
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    _user = UserModel.empty();
    //  清理本地记录
    LocalStorage.remove(GlobalConfigs.REFRESH_TOKEN_KEY);
    // 清除授权
    http$.removeAuthorization();
    _controller.sink.add(_user);
  }

  //检测本地用户记录
  Future<void> checkLocalUser() async {
    // 检测本地是否有refresh_token
    String local_refresh_token =
        await LocalStorage.get(GlobalConfigs.REFRESH_TOKEN_KEY);

    if (local_refresh_token != null && local_refresh_token != '') {
      //调用刷新token接口
      Response loginResponse;
      try {
        loginResponse = await http$.post(
            HttpUtils.generateUrl(url: GlobalConfigs.AUTH_TOKEN_URL, data: {
          'grant_type': GlobalConfigs.GRANT_TYPE_REFRESH_TOKEN,
          'client_id': 'asm',
          'client_secret': 'password',
          'refresh_token': local_refresh_token
        }));
      } on DioError catch (e) {
        print(e);
      }

      if (loginResponse != null && loginResponse.statusCode == 200) {
        LoginResponse _response = LoginResponse.fromJson(loginResponse.data);

        // 记录http token 信息
        http$.updateAuthorization(_response.accessToken);

        // 获取用户信息
        Response infoResponse;
        try {
          infoResponse = await http$.get(UserApis.userInfo);
        } on DioError catch (e) {
          print(e);
        }

        if (infoResponse != null && infoResponse.statusCode == 200) {
          _user = UserModel.fromJson(infoResponse.data);
          _user.name = infoResponse.data['username'];
        }

        //  记录refresh_token
        LocalStorage.save(
            GlobalConfigs.REFRESH_TOKEN_KEY, _response.refreshToken);
      }
    }
  }

  @override
  dispose() {
    _controller.close();
  }
}
