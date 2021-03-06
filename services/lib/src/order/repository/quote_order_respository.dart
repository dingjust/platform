import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';

class QuoteOrderRepository {
  /// 根据报价单编号获取明细
  Future<QuoteModel> getQuoteDetails(String code) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(OrderApis.quoteDetail(code),data: {'fields':QuoteOrderOptions.DEFAULT});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      QuoteModel model = QuoteModel.fromJson(response.data);
      return model;
    } else
      return null;
  }

  /// 确认报价
  Future<int> quoteApprove(String code) async {
    Response response;
    try {
      response = await http$.put(OrderApis.quoteApprove(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null) {
      return response.statusCode;
    }
  }

  /// 拒绝报价
  Future<int> quoteReject(String code, String reason) async {
    Response response;
    try {
      response = await http$.put(OrderApis.quoteReject(code), data: reason);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null) {
      return response.statusCode;
    }
  }

  ///创建报价
  Future<String> quoteCreate(QuoteModel model) async {
    Response response;
    try {
      response = await http$.post(OrderApis.quoteCreate,
          data: QuoteModel.toJson(model));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    }
  }

  ///更新报价
  Future<String> quoteUpdate(QuoteModel model) async {
    Response response;
    try {
      response = await http$.put(OrderApis.quoteUpdate(model.code),
          data: QuoteModel.toJson(model));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  //工厂获取与该品牌的报价单列表
  Future<QuoteOrdersResponse> getQuotesByBrand(
      String uid, Map<String, Object> params) async {
    Response response = await http$.post(
      OrderApis.quotes,
      data: {
        "requirementOrderBelongTos": uid,
      },
      queryParameters: params,
    );

    QuoteOrdersResponse quoteResponse =
        QuoteOrdersResponse.fromJson(response.data);
    return quoteResponse;
  }

  //品牌获取与该工厂的报价单列表
  Future<QuoteOrdersResponse> getQuotesByFactory(
      String uid, Map<String, Object> params) async {
    Response response = await http$.post(
      OrderApis.quotes,
      data: {
        "belongTos": uid,
      },
      queryParameters: params,
    );

    QuoteOrdersResponse quoteResponse =
        QuoteOrdersResponse.fromJson(response.data);
    return quoteResponse;
  }
}
