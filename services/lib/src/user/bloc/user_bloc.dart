import 'dart:async';

import 'package:b2b_commerce/b2b_commerce.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  //是否忽略更新提示
  bool ignoreVersionNotification;

  UserBLoC._internal() {
    // 初始化
    _user = UserModel.empty();
    ignoreVersionNotification = false;
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

  void setIgnoreVersionNotification(bool value) {
    ignoreVersionNotification = value;
  }

  bool get isBrandUser => _user.type == UserType.BRAND;

  bool get isFactoryUser => _user.type == UserType.FACTORY;

  bool get isAnonymousUser => !isBrandUser && !isFactoryUser;

  var _controller = StreamController<UserModel>.broadcast();

  Stream<UserModel> get stream => _controller.stream;

  StreamController _loginResultController =
      StreamController<String>.broadcast();

  StreamController get loginStreamController => _loginResultController;

  Stream<String> get loginStream => _loginResultController.stream;

  ///跳转登录
  StreamController loginJumpController = StreamController<bool>.broadcast();

  Stream<bool> get loginJumpStream => loginJumpController.stream;

  Future<LoginResult> login(
      {String username, String password, bool remember}) async {
    Response loginResponse;
    http$.removeAuthorization();
    try {
      loginResponse = await http$
          .post(HttpUtils.generateUrl(url: GlobalConfigs.AUTH_TOKEN_URL, data: {
        'username': username,
        'password': password,
        'grant_type': GlobalConfigs.GRANT_TYPE_PASSWORD,
        'client_id': GlobalConfigs.B2B_CLIENT_ID,
        'client_secret': GlobalConfigs.B2B_CLIENT_SECRET
      }));
    } catch (e) {
      print(e);
      //登录错误回调
      _loginResultController.sink.add('密码错误请输入正确的密码');
      return LoginResult.DIO_ERROR;
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
        return LoginResult.DIO_ERROR;
      }

      if (infoResponse != null && infoResponse.statusCode == 200) {
        print(infoResponse.data);
        _user = UserModel.fromJson(infoResponse.data);
        _user
          ..name = infoResponse.data['username']
          ..status = UserStatus.ONLINE;
      } else {
        _user = UserModel.empty();
        // 清除授权
        http$.removeAuthorization();
        _controller.sink.add(_user);
      }

      // 获取公司信息
      if (_user.type == UserType.BRAND) {
        BrandModel brand =
            await UserRepositoryImpl().getBrand(_user.companyCode);
        if (brand != null) {
          _user.b2bUnit = brand;
        }
      } else if (_user.type == UserType.FACTORY) {
        FactoryModel factoryModel =
            await UserRepositoryImpl().getFactory(_user.companyCode);
        if (factoryModel != null) {
          _user.b2bUnit = factoryModel;
        }
      }

      //  记录登录用户信息
      if (remember) {
        LocalStorage.save(
            GlobalConfigs.REFRESH_TOKEN_KEY, _response.refreshToken);
        LocalStorage.save(GlobalConfigs.USER_KEY, username);
      }

      //设置JPUSH别名
      // jpush$.setAlias(currentUser.mobileNumber);
      //友盟设置用户账号
      // UmengPlugin.onProfileSignIn(_user.mobileNumber);

      _controller.sink.add(_user);
      return LoginResult.SUCCESS;
    }

    return LoginResult.FAIL;
  }

  //授权码登录 传入username则校验账号存在
  Future<LoginResult> loginByAuthorizationCode(
      {String code, bool remember}) async {
    print(code);
    Response loginResponse;
    http$.removeAuthorization();
    try {
      loginResponse = await http$
          .post(HttpUtils.generateUrl(url: GlobalConfigs.AUTH_TOKEN_URL, data: {
        'grant_type': GlobalConfigs.GRANT_TYPE_AUTHORIZATION_CODE,
        'client_id': GlobalConfigs.B2B_CLIENT_ID,
        'client_secret': GlobalConfigs.B2B_CLIENT_SECRET,
        'code': code,
      }));
    } on DioError catch (e) {
      print(e);
      //登录错误回调
      _loginResultController.sink.add('验证码错误请输入正确的验证码');
      return LoginResult.DIO_ERROR;
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
        //  清理本地记录
        LocalStorage.remove(GlobalConfigs.REFRESH_TOKEN_KEY);
        // 清除授权
        http$.removeAuthorization();
        //登录错误回调
        _loginResultController.sink.add('获取用户信息失败');
        return LoginResult.DIO_ERROR;
      }

      if (infoResponse != null && infoResponse.statusCode == 200) {
        _user = UserModel.fromJson(infoResponse.data);
        _user.name = infoResponse.data['username'];
        _user.status = UserStatus.ONLINE;
      }

      // 获取公司信息
      if (_user.type == UserType.BRAND) {
        BrandModel brand =
            await UserRepositoryImpl().getBrand(_user.companyCode);
        if (brand != null) {
          _user.b2bUnit = brand;
        }
      } else if (_user.type == UserType.FACTORY) {
        FactoryModel factoryModel =
            await UserRepositoryImpl().getFactory(_user.companyCode);
        if (factoryModel != null) {
          _user.b2bUnit = factoryModel;
        }
      }

      //  记录登录用户信息
      if (remember) {
        LocalStorage.save(
            GlobalConfigs.REFRESH_TOKEN_KEY, _response.refreshToken);
        LocalStorage.save(GlobalConfigs.USER_KEY, _user.mobileNumber);
      }

      //设置JPUSH别名
      // jpush$.setAlias(currentUser.mobileNumber);
      //友盟设置用户账号
      // UmengPlugin.onProfileSignIn(_user.mobileNumber);

      _controller.sink.add(_user);
      return LoginResult.SUCCESS;
    }

    return LoginResult.FAIL;
  }

  Future<void> logout({UserType type, BuildContext context}) async {
    _user = UserModel.empty();

    if (type != null) {
      _user.type = type;
    }

    //  清理本地记录
    LocalStorage.remove(GlobalConfigs.REFRESH_TOKEN_KEY);
    // 清除授权
    http$.removeAuthorization();
    //所有Bloc重置
    BLocBus.systemBlocReset();

    //JPUSH删除别名
    // jpush$.deleteAlias();
    //友盟取消用户账号
    // UmengPlugin.onProfileSignOff();

    _controller.sink.add(_user);

    //清除用户State数据
    if (context != null) {
      AppProvider.clearUserData(context);
    }
  }

  ///改变用户类型
  void changeUserType(UserType userType) {
    _user.type = userType;
    _controller.sink.add(_user);
  }

  //检测本地用户记录
  Future<void> checkLocalUser() async {
    // 检测本地是否有refresh_token
    String localRefreshToken =
        await LocalStorage.get(GlobalConfigs.REFRESH_TOKEN_KEY);

    if (localRefreshToken != null && localRefreshToken != '') {
      //调用刷新token接口
      Response loginResponse;
      try {
        loginResponse = await http$.post(
            HttpUtils.generateUrl(url: GlobalConfigs.AUTH_TOKEN_URL, data: {
          'grant_type': GlobalConfigs.GRANT_TYPE_REFRESH_TOKEN,
          'client_id': GlobalConfigs.B2B_CLIENT_ID,
          'client_secret': GlobalConfigs.B2B_CLIENT_SECRET,
          'refresh_token': localRefreshToken
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
          String username = await LocalStorage.get(GlobalConfigs.USER_KEY);
          infoResponse = await http$.get(UserApis.userInfo);
        } on DioError catch (e) {
          print(e);
        }

        if (infoResponse != null && infoResponse.statusCode == 200) {
          _user = UserModel.fromJson(infoResponse.data);
          _user.name = infoResponse.data['username'];
          _user.status = UserStatus.ONLINE;
        }
        // 获取公司信息
        if (_user.type == UserType.BRAND) {
          BrandModel brand =
          await UserRepositoryImpl().getBrand(_user.companyCode);
          if (brand != null) {
            _user.b2bUnit = brand;
          }
        } else if (_user.type == UserType.FACTORY) {
          FactoryModel factoryModel =
          await UserRepositoryImpl().getFactory(_user.companyCode);
          if (factoryModel != null) {
            _user.b2bUnit = factoryModel;
          }
        }

        // jpush$.setAlias(currentUser.mobileNumber);
        //友盟设置用户账号
        // UmengPlugin.onProfileSignIn(_user.mobileNumber);

        //  记录refresh_token
        LocalStorage.save(
            GlobalConfigs.REFRESH_TOKEN_KEY, _response.refreshToken);
      }
    }
  }

  ///检测用户存在性
  Future<UserType> checkUserExist(String username) async {
    try {
      //校验账号存在
      UserType type = await UserRepositoryImpl().phoneExist(username);
      return type;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///刷新用户信息
  Future<UserModel> refreshUser() async {
    // 获取用户信息
    Response infoResponse;
    try {
      infoResponse = await http$.get(UserApis.userInfo);
    } on DioError catch (e) {
      print(e);
    }
    if (infoResponse != null && infoResponse.statusCode == 200) {
      _user = UserModel.fromJson(infoResponse.data);
      _user
        ..name = infoResponse.data['username']
        ..status = UserStatus.ONLINE;
    }

    // 获取公司信息
    if (_user.type == UserType.BRAND) {
      BrandModel brand = await UserRepositoryImpl().getBrand(_user.companyCode);
      if (brand != null) {
        _user.b2bUnit = brand;
      }
    } else if (_user.type == UserType.FACTORY) {
      FactoryModel factoryModel =
      await UserRepositoryImpl().getFactory(_user.companyCode);
      if (factoryModel != null) {
        _user.b2bUnit = factoryModel;
      }
    }

    return _user;
  }

  @override
  dispose() {
    _controller.close();
    _loginResultController.close();
    loginJumpController.close();
  }
}

enum LoginResult {
  ///登录成功
  SUCCESS,

  ///失败
  FAIL,

  ///接口调用失败
  DIO_ERROR
}
