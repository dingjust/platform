import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';

class ProofingOrderRepository {
  ///创建打样单
  Future<String> proofingCreate(String quoteCode, ProofingModel model) async {
    Response response;
    try {
      response = await http$.post(OrderApis.proofingCreate(quoteCode),
          data: ProofingModel.toJson(model));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  ///获取打样单明细
  Future<ProofingModel> proofingDetail(String code) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(
        OrderApis.proofingDetail(code),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      ProofingModel model = ProofingModel.fromJson(response.data);
      return model;
    } else {
      return null;
    }
  }

  ///取消订单
  Future<String> proofingCancelling(String code) async {
    Response response;
    try {
      response = await http$.put(
        OrderApis.proofingCancelling(code),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return 'successful';
    } else {
      return null;
    }
  }

  ///更新订单
  Future<String> proofingUpdate(ProofingModel model) async {
    Response response;
    try {
      response = await http$.put(OrderApis.proofingUpdate(model.code),
          data: ProofingModel.toJson(model));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  //确认发货
  Future<bool> proofingDelivering(String code , ProofingModel form) async {
    Response response;
    try{
      response =  await http$.put(
        OrderApis.proofingDelivering(code),
        data: ProofingModel.toJson(form),
      );
    }on DioError catch(e){
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateAddress(String code , ProofingModel form) async {
    Response<String> response;
    try{
      response =  await http$.put(
          OrderApis.updateProofAddress(code),
          data: ProofingModel.toJson(form),
          options: Options(responseType: ResponseType.plain));
    }on DioError catch(e){
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //确认收货
  Future<bool> shipped(String code) async {
    Response response;
    try {
      response = await http$.put(
        OrderApis.shipped(code),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //确认打样订单
  Future<bool> proofingConfirm(String code , ProofingModel form) async {
    Response response;
    try{
      response =  await http$.put(
        OrderApis.proofingConfirm(code),
        data: ProofingModel.toJson(form),
      );
    }on DioError catch(e){
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


}
