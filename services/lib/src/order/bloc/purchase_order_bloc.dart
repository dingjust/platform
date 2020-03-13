import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/order/response/order_response.dart';

class PurchaseOrderBLoC extends BLoCBase {
  // 工厂模式
  factory PurchaseOrderBLoC() => _getInstance();

  static PurchaseOrderBLoC get instance => _getInstance();
  static PurchaseOrderBLoC _instance;

  PurchaseOrdersResponse purchaseOrdersResponse;
  List<PurchaseOrderModel> purchaseOrderModels = [];

  bool lock = false;

  PurchaseOrderBLoC._internal() {}

  static PurchaseOrderBLoC _getInstance() {
    if (_instance == null) {
      _instance = PurchaseOrderBLoC._internal();
    }
    return _instance;
  }

  static final Map<String, PageEntry> _ordersMap = {
    'ALL':
        PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'PENDING_PAYMENT':
        PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'PENDING_CONFIRM':
        PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'IN_PRODUCTION':
        PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'WAIT_FOR_OUT_OF_STORE':
        PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'OUT_OF_STORE':
        PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'COMPLETED':
        PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'CANCELLED':
        PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'SEARCH':
        PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
  };

  List<PurchaseOrderModel> orders(String status) => _ordersMap[status].data;

  var _controller = StreamController<PurchaseData>.broadcast();

  Stream<PurchaseData> get stream => _controller.stream;

//  var _purchaseController = StreamController<List<PurchaseOrderModel>>.broadcast();
//
//  Stream<List<PurchaseOrderModel>> get purchasestream => _controller.stream;

  var _purchaseController =
      StreamController<List<PurchaseOrderModel>>.broadcast();

  Stream<List<PurchaseOrderModel>> get purchaseStream =>
      _purchaseController.stream;

  filterByStatuses(String status) async {
    //若没有数据则查询
    if (_ordersMap[status].data.length == 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {};
      if (status != 'ALL' && status != 'PENDING_PAYMENT') {
        data = {
          'statuses': [status]
        };
      }
      if (status == 'PENDING_PAYMENT') {
        data = {
          'balancePaid': false,
          'depositPaid': false,
          'statuses': [status],
        };
      }
      Response<Map<String, dynamic>> response;

      try {
        response = await http$
            .post(OrderApis.purchaseOrders, data: data, queryParameters: {
          'page': _ordersMap[status].currentPage,
          'size': _ordersMap[status].size,
          'fields': PurchaseOrderOptions.DEFAULT
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        PurchaseOrdersResponse ordersResponse =
            PurchaseOrdersResponse.fromJson(response.data);
        _ordersMap[status].totalPages = ordersResponse.totalPages;
        _ordersMap[status].totalElements = ordersResponse.totalElements;
        _ordersMap[status].data.clear();
        _ordersMap[status].data.addAll(ordersResponse.content);
      }
    }
    _controller.sink
        .add(PurchaseData(status: status, data: _ordersMap[status].data));
  }

  filterByKeyword(String keyword) async {
    print(keyword);
    if (!lock) {
      lock = true;
      _ordersMap['SEARCH'].data.clear();
      //若没有数据则查询
      if (_ordersMap['SEARCH'].data.length == 0) {
        //请求参数
        Map data = {
          'keyword': keyword,
        };
        Response<Map<String, dynamic>> response;
        try {
          response = await http$
              .post(OrderApis.purchaseOrders, data: data, queryParameters: {
            'page': _ordersMap['SEARCH'].currentPage,
            'size': _ordersMap['SEARCH'].size,
            'fields': PurchaseOrderOptions.DEFAULT,
          });
        } on DioError catch (e) {
          print(e);
        }

        if (response.statusCode == 200) {
          PurchaseOrdersResponse ordersResponse =
              PurchaseOrdersResponse.fromJson(response.data);
          _ordersMap['SEARCH'].totalPages = ordersResponse.totalPages;
          _ordersMap['SEARCH'].totalElements = ordersResponse.totalElements;
          _ordersMap['SEARCH'].data.addAll(ordersResponse.content);
        }
      }
      lock = false;
    }
    _purchaseController.sink.add(_ordersMap['SEARCH'].data);
  }

  loadingMoreByStatuses(String status) async {
    //数据到底
    if (_ordersMap[status].currentPage + 1 == _ordersMap[status].totalPages) {
      //通知显示已经到底部
      bottomController.sink.add(true);
    } else {
      Map data = {};
      if (status != 'ALL') {
        data = {
          'statuses': [status]
        };
      }
      Response<Map<String, dynamic>> response;
      try {
        response = await http$
            .post(OrderApis.purchaseOrders, data: data, queryParameters: {
          'page': ++_ordersMap[status].currentPage,
          'size': _ordersMap[status].size,
          'fields': PurchaseOrderOptions.DEFAULT,
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response.statusCode == 200) {
        PurchaseOrdersResponse ordersResponse =
            PurchaseOrdersResponse.fromJson(response.data);
        _ordersMap[status].totalPages = ordersResponse.totalPages;
        _ordersMap[status].totalElements = ordersResponse.totalElements;
        _ordersMap[status].data.addAll(ordersResponse.content);
      }
    }

    bottomController.sink.add(false);
    _controller.sink
        .add(PurchaseData(status: status, data: _ordersMap[status].data));
  }

  loadingMoreByKeyword(String keyword) async {
    //若没有数据则查询
    if (_ordersMap['SEARCH'].currentPage + 1 == _ordersMap['SEARCH'].totalPages) {
      //通知显示已经到底部
      loadingController.sink.add(true);
    } else {
      //数据到底
      Map data = {
        'keyword': keyword,
      };
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.post(OrderApis.purchaseOrders, data: data,
            queryParameters: {
              'page': ++_ordersMap['SEARCH'].currentPage,
              'size': _ordersMap['SEARCH'].size,
              'fields': PurchaseOrderOptions.BASIC,
            }
        );
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        PurchaseOrdersResponse ordersResponse =
            PurchaseOrdersResponse.fromJson(response.data);
        _ordersMap['SEARCH'].totalPages = ordersResponse.totalPages;
        _ordersMap['SEARCH'].totalElements = ordersResponse.totalElements;
        _ordersMap['SEARCH'].data.addAll(ordersResponse.content);
      }
      loadingController.sink.add(false);
      _purchaseController.sink.add(_ordersMap['SEARCH'].data);
    }
  }

  // 获取订单明细
  Future<PurchaseOrderModel> getPurchaseOrderDetail(String code) async {
    Response<Map<String, dynamic>> response =
        await http$.get(OrderApis.purchaseOrderDetail(code));

    if (response.statusCode == 200) {
      PurchaseOrderModel model = PurchaseOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }

  //下拉刷新
  Future refreshData(String status) async {
    //重置信息
    _ordersMap[status].data.clear();
    _ordersMap[status].currentPage = 0;
    //  分页拿数据，response.data;
    //请求参数
    Map data = {};
    if (status != 'ALL') {
      data = {
        'statuses': [status]
      };
    }
    Response<Map<String, dynamic>> response = await http$
        .post(OrderApis.purchaseOrders, data: data, queryParameters: {
      'page': _ordersMap[status].currentPage,
      'size': _ordersMap[status].size,
      'fields': PurchaseOrderOptions.DEFAULT,
    });

    if (response.statusCode == 200) {
      PurchaseOrdersResponse ordersResponse =
          PurchaseOrdersResponse.fromJson(response.data);
      _ordersMap[status].totalPages = ordersResponse.totalPages;
      _ordersMap[status].totalElements = ordersResponse.totalElements;
      _ordersMap[status].data.addAll(ordersResponse.content);
    }
    _controller.sink
        .add(PurchaseData(status: status, data: _ordersMap[status].data));
  }

  //获取供应商的相关全部生产单
  getPurchaseDataByCompany(String companyUid) async {
    if (!lock) {
      lock = true;
      if (purchaseOrderModels.isEmpty) {
        if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
          purchaseOrdersResponse = await PurchaseOrderRepository()
              .getPurchaseOrdersByFactory(companyUid, {
            'fields': PurchaseOrderOptions.DEFAULT,
          });
        } else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
          purchaseOrdersResponse = await PurchaseOrderRepository()
              .getPurchaseOrdersByBrand(companyUid, {
            'fields': PurchaseOrderOptions.DEFAULT,
          });
        }
        purchaseOrderModels.addAll(purchaseOrdersResponse.content);
      }

      _controller.sink.add(PurchaseData(data: purchaseOrderModels));
      lock = false;
    }
  }

  //获取供应商的相关全部生产单
  lodingMoreByCompany(String companyUid) async {
    if (!lock) {
      lock = true;
      if (purchaseOrdersResponse.number <
          purchaseOrdersResponse.totalPages - 1) {
        if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
          purchaseOrdersResponse = await PurchaseOrderRepository()
              .getPurchaseOrdersByFactory(companyUid, {
            'page': purchaseOrdersResponse.number + 1,
            'fields': PurchaseOrderOptions.DEFAULT
          });
        } else if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
          purchaseOrdersResponse = await PurchaseOrderRepository()
              .getPurchaseOrdersByBrand(companyUid, {
            'page': purchaseOrdersResponse.number + 1,
            'fields': QuoteOrderOptions.DEFAULT,
          });
        }
        purchaseOrderModels.addAll(purchaseOrdersResponse.content);
      } else {
        bottomController.sink.add(true);
      }

      loadingController.sink.add(false);

      _controller.sink.add(PurchaseData(data: purchaseOrderModels));
      lock = false;
    }
  }

  ///重置数据
  void reset() {
    purchaseOrderModels.clear();
    _ordersMap.forEach((status, entry) {
      entry.data.clear();
      entry.currentPage = 0;
    });
  }

  ///刷新修改后的列表价格
  updateAmountResetData(String status,PurchaseOrderModel model){
    _ordersMap[status].data.forEach((item){
      if(item.code == model.code){
        item.totalPrice = model.totalPrice;
        item.deposit = model.deposit;
        item.deductionAmount = model.deductionAmount;
      }
    });
    _controller.sink.add(PurchaseData(status: status, data: _ordersMap[status].data));
  }

  dispose() {
    _controller.close();

    super.dispose();
  }
}

class PurchaseData {
  String status;

  List<PurchaseOrderModel> data;

  PurchaseData({this.status, this.data});
}
