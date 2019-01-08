import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/net/http_util.dart';
import 'package:services/src/user/bloc/login.dart';

class LoginBLoC {
  UserModel _user = UserModel(name: '未登录用户', uid: '123');

  UserModel get currentUser => _user;

  var _controller = StreamController<UserModel>.broadcast();

  var _errorController = StreamController<bool>();

  Stream<UserModel> get stream => _controller.stream;

  login({String username, String password}) async {
    // // TODO: call login service

    Response loginRequest = await http$
        .post(HttpUtil.generateUrl(url: GlobalConfigs.AUTH_TOKEN_URL, data: {
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
