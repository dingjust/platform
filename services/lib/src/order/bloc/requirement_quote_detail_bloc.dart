import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/response/order_response.dart';

class RequirementQuoteDetailBLoC extends BLoCBase {
  // 工厂模式
  factory RequirementQuoteDetailBLoC() => _getInstance();

  static RequirementQuoteDetailBLoC get instance => _getInstance();
  static RequirementQuoteDetailBLoC _instance;

  RequirementQuoteDetailBLoC._internal() {
    // 初始化
  }

  static RequirementQuoteDetailBLoC _getInstance() {
    if (_instance == null) {
      _instance = new RequirementQuoteDetailBLoC._internal();
    }
    return _instance;
  }

  /// 数据列
  static List<QuoteModel> quotes;

  /// 当前页数
  int currentPage = 0;

  /// 总页数
  int totalPages = 0;

  /// 显示数据条数
  int size = 10;

  /// 总条数
  int totalElements = 0;

  List<QuoteModel> get quotesList => quotes;

  var _controller = StreamController<List<QuoteModel>>.broadcast();

  Stream<List<QuoteModel>> get stream => _controller.stream;

  getData(String code) async {
    //重置当前页计数
    currentPage = 0;
    // TODO: 分页拿数据;
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(OrderApis.requirementOrderQuotes(code), data: {'page': currentPage, 'size': size});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      QuoteOrdersResponse ordersResponse = QuoteOrdersResponse.fromJson(response.data);
      quotes = ordersResponse.content;
      totalPages = ordersResponse.totalPages;
      totalElements = ordersResponse.totalElements;
    } else
      quotes = null;
    _controller.sink.add(this.quotesList);
  }

  loadingMore(code) async {
    //数据到底
    if (currentPage + 1 == totalPages) {
      //通知显示已经到底部
      bottomController.sink.add(true);
    } else {
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.get(OrderApis.requirementOrderQuotes(code), data: {'page': ++currentPage, 'size': size});
      } on DioError catch (e) {
        print(e);
      }
      if (response != null && response.statusCode == 200) {
        QuoteOrdersResponse ordersResponse = QuoteOrdersResponse.fromJson(response.data);
        quotes.addAll(ordersResponse.content);
      }
      loadingController.sink.add(false);
      _controller.sink.add(this.quotesList);
    }
  }

  //下拉刷新
  Future refreshData(code) async {
    quotes.clear();
    //重置当前页计数
    currentPage = 0;
    // TODO: 分页拿数据;
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(OrderApis.requirementOrderQuotes(code), data: {'page': currentPage, 'size': size});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      QuoteOrdersResponse ordersResponse = QuoteOrdersResponse.fromJson(response.data);
      quotes = ordersResponse.content;
      totalPages = ordersResponse.totalPages;
      totalElements = ordersResponse.totalElements;
    } else
      quotes = null;
    _controller.sink.add(this.quotesList);
  }

  dispose() {
    _controller.close();

    super.dispose();
  }
}
