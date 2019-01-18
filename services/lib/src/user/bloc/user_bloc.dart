import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/net/http_utils.dart';
import 'package:services/src/user/bloc/login.dart';

class UserBLoC {
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
      _instance = new UserBLoC._internal();
    }
    return _instance;
  }

  UserModel get currentUser => _user;

  bool get isBrandUser => _user.userType == UserType.BRAND;

  bool get isFactoryUser => _user.userType == UserType.FACTORY;

  bool get isAnonymousUser => !isBrandUser && !isFactoryUser;

  var _controller = StreamController<UserModel>.broadcast();

  Stream<UserModel> get stream => _controller.stream;

  Future<bool> login({String username, String password}) async {
    // // TODO: call login service
    Response loginRequest = await http$
        .post(HttpUtils.generateUrl(url: GlobalConfigs.AUTH_TOKEN_URL, data: {
      'username': username,
      'password': password,
      'grant_type': GlobalConfigs.GRANT_TYPE_PASSWORD,
      'client_id': 'asm', // TODO:
      'client_secret': 'password' // TODO:
    }));

    if (loginRequest.statusCode == 200) {
      LoginResponse _response = LoginResponse.fromJson(loginRequest.data);
      LocalStorage.save(GlobalConfigs.ACCESS_TOKEN_KEY, _response.accessToken);

      // TODO: GET USER INFO
      // http$.get('');
      _user.name = '衣加衣管理员';
      _user.uid = 'nbyjy';

      /// 品牌用户
      _user.userType = UserType.BRAND;
      _controller.sink.add(_user);

      return true;
    }

    return false;
  }

  dispose() {
    _controller.close();
  }
}
