import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/user.dart';
import 'package:services/src/net/http_manager.dart';

class WalletRepository {
  /// 查询帮助信息详情
  Future<CompanyWalletModel> getWallet() async {
    Response response;
    try {
      response = await http$.get(UserApis.getCompanyWallet);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      CompanyWalletModel model = CompanyWalletModel.fromJson(response.data);
      return model;
    } else {
      return null;
    }
  }
}
