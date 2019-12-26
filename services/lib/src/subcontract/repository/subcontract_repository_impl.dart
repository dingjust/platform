import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/subcontract.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/subcontract/repository/subcontract_repository.dart';
import 'package:services/src/subcontract/response/subcontract_response.dart';

///转包
class SubContractRepositoryImpl implements SubContractRepository {
  /// 获取全部工厂的转包
  Future<SubContractResponse> getSubcontractsByAllFactory({Map<String,dynamic> data, Map<String,dynamic> params}) async {
    if(data == null){
      data = {};
    }
    if(params == null){
      params = {};
    }
    Response response;
    SubContractResponse result;
    try {
      response = await http$.post(SubContractApis.subcontractsByAllFactory, data: data,queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200 && response.data != null) {
      result = SubContractResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  /// 获取我的转包
  Future<SubContractResponse> getSubcontracts({Map<String,dynamic> data, Map<String,dynamic> params}) async {
    if(data == null){
      data = {};
    }
    if(params == null){
      params = {};
    }
    Response response;
    SubContractResponse result;
    try {
      response = await http$.post(SubContractApis.subcontracts, data: data,queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200 && response.data != null) {
      result = SubContractResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  @override
  Future<SubContractModel> getSubContract(String code) async{
    Response response;
    SubContractModel result;
    try {
      response = await http$.get(SubContractApis.subcontractDetail(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200 && response.data != null) {
      result = SubContractModel.fromJson(response.data);
    } else {
      result = null;
    }
    print('${result}-=-=-=-=-=-=-=');
    return result;
  }

  ///创建转包
  @override
  Future<String> createSubContract(SubContractModel form)async {
    Response response;
    try {
      response = await http$.post(SubContractApis.subcontractsCreate, data: SubContractModel.toJson(form),);
    } on DioError catch (e) {
      print(e);
    }
    print('${response.data}-=-=-=-=-=-');
    if (response != null && response.statusCode == 200 && response.data != null) {
      return response.data;
    }else{
      return null;
    }
  }

  /// 订单关闭
  Future<String> cancleSubContract(String code) async {
    Response response;
    try {
      response = await http$.delete(SubContractApis.subcontractCancelled(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else{
      return null;
    }
  }
}
