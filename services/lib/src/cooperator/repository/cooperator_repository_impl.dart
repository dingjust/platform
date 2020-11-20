import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/response/cooperator_response.dart';

import 'package:services/src/cooperator/repository/cooperator_repository.dart';

///合作商
class CooperatorRepositoryImpl implements CooperatorRepository {
  /// 获取合作商列表
  Future<CooperatorResponse> list(
      {Map<String, dynamic> data, Map<String, dynamic> params}) async {
    if (data == null) {
      data = {};
    }
    if (params == null) {
      params = {};
    }
    Response response;
    CooperatorResponse result;
    try {
      response = await http$.post(UserApis.cooperators,
          data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = CooperatorResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  @override
  Future<CooperatorModel> getDetail(int id) async {
    Response<Map<String, dynamic>> response =
        await http$.get(UserApis.cooperatorDetail(id));

    if (response.statusCode == 200) {
      CooperatorModel model = CooperatorModel.fromJson(response.data);
      return model;
    } else {
      return null;
    }
  }

  @override
  Future<BaseResponse> appendCooperator(CooperatorModel form) async {
    try {
      Response<Map<String, dynamic>> response = await http$.post(
        UserApis.appendCooperator,
        data: CooperatorModel.toJson(form),
        queryParameters: {},
      );

      if (response.statusCode == 200 && response.data != null) {
        return BaseResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        String msg = getErrorMessage(e);
        if (msg != null) {
          return BaseResponse(0, msg, 0, msg);
        }
      }
      return null;
    }
  }

  String getErrorMessage(DioError e) {
    try {
      String msg = e.response.data['errors'][0]['message'];
      return msg;
    } catch (e) {
      return null;
    }
  }
}
