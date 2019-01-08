import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/user/bloc/login.dart';

class LoginBLoC {
  UserModel _user = UserModel(name: '未登录用户', uid: '123');

  UserModel get currentUser => _user;

  var _controller = StreamController<UserModel>.broadcast();

  var _errorController = StreamController<bool>();

  Stream<UserModel> get stream => _controller.stream;

  login({String username, String password}) async {
    // // TODO: call login service
    //拼接请求地址
    String client_id = 'asm';
    String client_secret = 'password';
    String loginRequestUrl = GlobalConfigs.AUTH_TOKEN_URL +
        '?client_id=' +
        client_id +
        '&client_secret=' +
        client_secret +
        '&grant_type=' +
        GlobalConfigs.GRANT_TYPE_PASSWORD +
        '&username=' +
        username +
        '&password=' +
        password;

    Response loginRequest = await http$.post(loginRequestUrl);

    if (loginRequest.statusCode == 200) {
      LoginResponse _response = LoginResponse.fromJson(loginRequest.data);
      LocalStorage.save(GlobalConfigs.ACCESS_TOKEN_KEY, _response.accessToken);

      // TODO: GET USER INFO
      // http$.get('');
      _user.name = '衣加衣管理员';
      _user.uid = 'nbyjy';
      _controller.sink.add(_user);
    } else {
      _errorController.sink.add(false);
    }
  }

  dispose() {
    _controller.close();
    _errorController.close();
  }
}
