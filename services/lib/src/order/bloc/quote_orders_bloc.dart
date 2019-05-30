import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/order/response/order_response.dart';

class QuoteOrdersBLoC extends BLoCBase {
  // 工厂模式
  factory QuoteOrdersBLoC() => _getInstance();

  static QuoteOrdersBLoC get instance => _getInstance();
  static QuoteOrdersBLoC _instance;

  QuoteOrdersResponse quoteResponse;
  List<QuoteModel> quoteModels = [];

  //锁
  bool lock = false;

  QuoteOrdersBLoC._internal() {
    // 初始化
  }

  static QuoteOrdersBLoC _getInstance() {
    if (_instance == null) {
      _instance = new QuoteOrdersBLoC._internal();
    }
    return _instance;
  }

  static final Map<String, PageEntry> _quotesMap = {
    'ALL': PageEntry(currentPage: 0, size: 10, data: List<QuoteModel>()),
    'SELLER_SUBMITTED':
        PageEntry(currentPage: 0, size: 10, data: List<QuoteModel>()),
    'BUYER_APPROVED':
        PageEntry(currentPage: 0, size: 10, data: List<QuoteModel>()),
    'BUYER_REJECTED':
        PageEntry(currentPage: 0, size: 10, data: List<QuoteModel>()),
    'SEARCH': PageEntry(currentPage: 0, size: 10, data: List<QuoteModel>()),
  };

  List<QuoteModel> quotes(String status) => _quotesMap[status].data;

  var _controller = StreamController<QuoteData>.broadcast();

  Stream<QuoteData> get stream => _controller.stream;

  var _quoteController = StreamController<List<QuoteModel>>.broadcast();

  Stream<List<QuoteModel>> get quoteStream => _quoteController.stream;

  filterByStatuses(String status) async {
    if (!lock) {
      lock = true;
      //若没有数据则查询
      if (_quotesMap[status].data.isEmpty) {
        //  分页拿数据，response.data;
        //请求参数
        Map data = {};
        if (status != 'ALL') {
          data = {
            'states': [status]
          };
        }
        Response<Map<String, dynamic>> response;
        try {
          response = await http$.post(OrderApis.quotes,
              data: data,
              queryParameters: {
                'page': _quotesMap[status].currentPage,
                'size': _quotesMap[status].size
              });
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          QuoteOrdersResponse ordersResponse =
              QuoteOrdersResponse.fromJson(response.data);
          _quotesMap[status].totalPages = ordersResponse.totalPages;
          _quotesMap[status].totalElements = ordersResponse.totalElements;
          _quotesMap[status].data.clear();
          _quotesMap[status].data.addAll(ordersResponse.content);
        }
      }
      _controller.sink
          .add(QuoteData(status: status, data: _quotesMap[status].data));
      lock = false;
    }
  }

  filterByKeyword(String keyword) async {
    //若没有数据则查询
    if (!lock) {
      lock = true;
      //请求参数
      Map data = {
        'keyword': keyword,
      };
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.post(OrderApis.quotes,
            data: data,
            queryParameters: {
              'page': _quotesMap['SEARCH'].currentPage,
              'size': _quotesMap['SEARCH'].size
            });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        QuoteOrdersResponse ordersResponse =
        QuoteOrdersResponse.fromJson(response.data);
        _quotesMap['SEARCH'].totalPages = ordersResponse.totalPages;
        _quotesMap['SEARCH'].totalElements = ordersResponse.totalElements;
        _quotesMap['SEARCH'].data.clear();
        _quotesMap['SEARCH'].data.addAll(ordersResponse.content);
      }
      lock = false;
    }
    _quoteController.sink.add(_quotesMap['SEARCH'].data);
  }

  loadingMoreByStatuses(String status) async {
    if (!lock) {
      lock = true;
      //数据到底
      if (_quotesMap[status].currentPage + 1 == _quotesMap[status].totalPages) {
        //通知显示已经到底部
        bottomController.sink.add(true);
      } else {
        Map data = {};
        if (status != 'ALL') {
          data = {
            'states': [status]
          };
        }
        Response<Map<String, dynamic>> response;
        try {
          response = await http$.post(OrderApis.quotes,
              data: data,
              queryParameters: {
                'page': ++_quotesMap[status].currentPage,
                'size': _quotesMap[status].size
              });
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          QuoteOrdersResponse ordersResponse =
              QuoteOrdersResponse.fromJson(response.data);
          _quotesMap[status].totalPages = ordersResponse.totalPages;
          _quotesMap[status].totalElements = ordersResponse.totalElements;
          _quotesMap[status].data.addAll(ordersResponse.content);
        }
      }
      loadingController.sink.add(false);
      _controller.sink
          .add(QuoteData(status: status, data: _quotesMap[status].data));
      lock = false;
    }
  }

  loadingMoreByKeyword(String keyword) async {
    if (!lock) {
      lock = true;
      //数据到底
      Map data = {
        'keyword': keyword,
      };
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.post(OrderApis.quotes,
            data: data,
            queryParameters: {
              'page': ++_quotesMap['ALL'].currentPage,
              'size': _quotesMap['ALL'].size
            });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        QuoteOrdersResponse ordersResponse =
            QuoteOrdersResponse.fromJson(response.data);
        _quotesMap['ALL'].totalPages = ordersResponse.totalPages;
        _quotesMap['ALL'].totalElements = ordersResponse.totalElements;
        _quotesMap['ALL'].data.addAll(ordersResponse.content);
      }
      loadingController.sink.add(false);
      _controller.sink
          .add(QuoteData(status: 'ALL', data: _quotesMap['ALL'].data));
      lock = false;
    }
  }

  //下拉刷新
  Future refreshData(String status) async {
    _quotesMap[status].data.clear();
    _quotesMap[status].currentPage = 0;
    await filterByStatuses(status);
  }

  //获取供应商的相关全部报价
  getQuoteDataByCompany(String companyUid) async {
    quoteModels.clear();
    if (!lock) {
      lock = true;
      if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
        //获取与该工厂全部的报价单
        quoteResponse =
            await QuoteOrderRepository().getQuotesByFactory(companyUid, {});
      } else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
        //获取与该品牌全部的报价单
        quoteResponse =
            await QuoteOrderRepository().getQuotesByBrand(companyUid, {});
      }

      quoteModels.addAll(quoteResponse.content);
      _quoteController.sink.add(quoteModels);
      lock = false;
    }
  }

  //获取供应商的相关全部报价
  lodingMoreByCompany(String companyUid) async {
    if (!lock) {
      lock = true;
      //获取与该工厂全部的报价单
      if (quoteResponse.number < quoteResponse.totalPages - 1) {
        if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
          //获取与该工厂全部的报价单
          quoteResponse = await QuoteOrderRepository().getQuotesByFactory(
              companyUid, {'page': quoteResponse.number + 1});
        } else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
          //获取与该品牌全部的报价单
          quoteResponse = await QuoteOrderRepository()
              .getQuotesByBrand(companyUid, {'page': quoteResponse.number + 1});
        }
        quoteModels.addAll(quoteResponse.content);
      } else {
        bottomController.sink.add(true);
      }
      loadingController.sink.add(false);
      _quoteController.sink.add(quoteModels);
      lock = false;
    }
  }

  ///重置数据
  void reset() {
    _quotesMap.forEach((statu, entry) {
      entry.data.clear();
      entry.currentPage = 0;
    });
  }

  dispose() {
    _controller.close();

    super.dispose();
  }
}

class QuoteData {
  String status;

  List<QuoteModel> data;

  QuoteData({this.status, this.data});
}
