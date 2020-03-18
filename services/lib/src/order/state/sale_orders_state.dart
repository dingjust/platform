import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/order/response/order_response.dart';
import 'package:services/src/state/state.dart';

import '../PageEntry.dart';

///销售状态管理
class SaleOrdersState extends PageState {
  static Map<String, PageEntry> _ordersMap = {
    'ALL': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<PurchaseOrderModel>(),
        totalElements: -1),
    'PENDING_PAYMENT': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<PurchaseOrderModel>(),
        totalElements: -1),
    'PENDING_CONFIRM': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<PurchaseOrderModel>(),
        totalElements: -1),
    'IN_PRODUCTION': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<PurchaseOrderModel>(),
        totalElements: -1),
    'WAIT_FOR_OUT_OF_STORE': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<PurchaseOrderModel>(),
        totalElements: -1),
    'OUT_OF_STORE': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<PurchaseOrderModel>(),
        totalElements: -1),
    'COMPLETED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<PurchaseOrderModel>(),
        totalElements: -1),
    'CANCELLED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<PurchaseOrderModel>(),
        totalElements: -1),
    'SEARCH': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<PurchaseOrderModel>(),
        totalElements: -1),
  };

  PageEntry getEntry(String status) {
    if (_ordersMap[status].totalElements < 0) {
      getOrders(status);
    }
    return _ordersMap[status];
  }

  List<PurchaseOrderModel> orders(String status) {
    if (_ordersMap[status].totalElements < 0) {
      getOrders(status);
    }
    return _ordersMap[status].data;
  }

  void getOrders(String status) async {
    //若没有数据则查询
    if (_ordersMap[status].totalElements < 0) {
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

      ///通知刷新
      notifyListeners();
    }
  }

  void loadMoreOrders(String status) async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      Map params = {};
      //接口调用：
      if (_ordersMap[status].currentPage + 1 != _ordersMap[status].totalPages) {
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

      //异步调用结束，通知加载组件
      workingEnd();
    }
  }

  @override
  void clear() {
    _ordersMap.forEach((key, entry) {
      entry.currentPage = 0;
      entry.size = 10;
      entry.data = List<PurchaseOrderModel>();
      entry.totalElements = -1;
    });
    notifyListeners();
  }

  @override
  getData() {
    // TODO: implement getData
    return null;
  }

  @override
  loadMore() {
    // TODO: implement loadMore
    return null;
  }
}
