import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/api/user.dart';
import 'package:services/src/my/response/bank_card_response.dart';
import 'package:services/src/net/http_manager.dart';

class BankCardRepository {
  /// 列表
  static Future<BankCardResponse> list() async {
    Response response;
    BankCardResponse result;

    try {
      response = await http$.get(UserApis.bankCard);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BankCardResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  /// 查询公司银行卡
  static Future<BaseResponse> create(dynamic data) async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.post(UserApis.bankCard, data: data);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BaseResponse.fromJson(response.data);
    }
    return result;
  }

  /// 解绑银行卡
  static Future<BaseResponse> del(int id) async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.delete(UserApis.unbindBankCard(id));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BaseResponse.fromJson(response.data);
    }
    return result;
  }
}
