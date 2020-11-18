import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';

///生产进度工单
class ProgressWorkSheetRepository {
  ///获取明细
  Future<ProgressWorkSheetModel> detail(String code) async {
    Response response;
    try {
      response = await http$.get(OrderApis.progressWorkSheetDetail(code),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }

    ProgressWorkSheetModel model;
    if(response != null && response.statusCode == 200){
      BaseMsg msg =  BaseMsg.fromJson(json.decode(response.data));
      if(msg!= null && msg.code == 1 && msg.data != null){
        model = ProgressWorkSheetModel.fromJson(msg.data);
      }
    }
    return model;
  }

  ///修改生产进度预计完成时间
  Future<BaseMsg> updateProgressesEstimatedDate(ProgressWorkSheetModel form) async {
    Response response;
    try {
      response = await http$.put(OrderApis.updateProgressesEstimatedDate(),
          data: ProgressWorkSheetModel.toJson(form),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }

    if(response != null && response.statusCode == 200){
      return BaseMsg.fromJson(json.decode(response.data));
    }else{
      return null;
    }
  }

  ///生产进度节点完成
  Future<BaseMsg> finishProgress(String code,int id) async {
    Response response;
    try {
      response = await http$.put(OrderApis.finishProgress(code,id),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }

    if(response != null && response.statusCode == 200){
      return BaseMsg.fromJson(json.decode(response.data));
    }else{
      return null;
    }
  }

}
