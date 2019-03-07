import 'dart:async';
import 'dart:convert';

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
    // // TODO: call login service
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

      if (infoResponse.statusCode == 200) {
        _user = UserModel.fromJson(infoResponse.data);
        _user.name = infoResponse.data['username'];
      }

      _user.type = UserType.BRAND;

      //  记录登陆用户信息
      if (remember) {
        LocalStorage.save(
            GlobalConfigs.ACCESS_TOKEN_KEY, _response.accessToken);
        LocalStorage.save(
            GlobalConfigs.USER_KEY, json.encode(UserModel.toJson(_user)));
      }
      _controller.sink.add(_user);
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    _user = UserModel.empty();
    //  清理本地记录
    LocalStorage.remove(GlobalConfigs.USER_KEY);
    LocalStorage.remove(GlobalConfigs.ACCESS_TOKEN_KEY);
    _controller.sink.add(_user);
  }

  //检测本地用户记录
  Future<void> checkLocalUser() async {
    String jsonStr = await LocalStorage.get(GlobalConfigs.USER_KEY);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      Map<String, dynamic> userJson =
          json.decode(jsonStr) as Map<String, dynamic>;
      print(jsonStr);
      UserModel localUser = UserModel.fromJson(userJson);
      _user.type = localUser.type;
      _user.name = localUser.name;
    }
  }

  @override
  dispose() {
    _controller.close();
  }
}
