import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/order/response/order_response.dart';
import 'package:services/src/state/state.dart';

import '../PageEntry.dart';

///销售状态管理
class SaleOrdersState extends PageState {
  Map<String, PageEntry> _ordersMap = {
    'ALL': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesOrderModel>(),
        totalElements: -1),
    'PENDING_PAYMENT': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesOrderModel>(),
        totalElements: -1),
    'PENDING_DELIVERY': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesOrderModel>(),
        totalElements: -1),
    'PENDING_CONFIRM': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesOrderModel>(),
        totalElements: -1),
    'ON_RETURN': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesOrderModel>(),
        totalElements: -1),
    'COMPLETED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesOrderModel>(),
        totalElements: -1),
    'SEARCH': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesOrderModel>(),
        totalElements: -1),
  };

  PageEntry getEntry(String status, {String keyword}) {
    if (_ordersMap[status].totalElements < 0) {
      getOrders(status, keyword: keyword);
    }
    return _ordersMap[status];
  }

  List<SalesOrderModel> orders(String status, {String keyword}) {
    if (_ordersMap[status].totalElements < 0) {
      getOrders(status, keyword: keyword);
    }
    return _ordersMap[status].data;
  }

  void getOrders(String status, {String keyword}) async {
    //若没有数据则查询
    if (_ordersMap[status].totalElements < 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {};
      if (status != 'ALL' && status != 'SEARCH') {
        data = {
          'statuses': [status]
        };
      }

      if (status == 'ON_RETURN') {
        data = {'refunding': true};
      }

      if (status == 'SEARCH' && keyword != null) {
        data = {'keyword': keyword};
      }

      Response<Map<String, dynamic>> response;

      try {
        response = await http$
            .post(OrderApis.salesOrderList, data: data, queryParameters: {
          'page': _ordersMap[status].currentPage,
          'size': _ordersMap[status].size,
          'fields': SalesOptions.DEFAULT
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        SalesOrdersResponse ordersResponse =
        SalesOrdersResponse.fromJson(response.data);
        _ordersMap[status].totalPages = ordersResponse.totalPages;
        _ordersMap[status].totalElements = ordersResponse.totalElements;
        _ordersMap[status].data.clear();
        _ordersMap[status].data.addAll(ordersResponse.content);

        ///通知刷新
        notifyListeners();
      }
    }
  }

  void loadMoreOrders(String status, {String keyword}) async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (_ordersMap[status].currentPage + 1 != _ordersMap[status].totalPages) {
        Map data = {};
        if (status != 'ALL') {
          data = {
            'statuses': [status]
          };
        }
        if (status == 'ON_RETURN') {
          data = {'refunding': true};
        }

        if (status == 'SEARCH' && keyword != null) {
          data = {'keyword': keyword};
        }

        Response<Map<String, dynamic>> response;
        try {
          response = await http$
              .post(OrderApis.salesOrderList, data: data, queryParameters: {
            'page': ++_ordersMap[status].currentPage,
            'size': _ordersMap[status].size,
            'fields': SalesOptions.DEFAULT,
          });
        } on DioError catch (e) {
          print(e);
        }

        if (response.statusCode == 200) {
          SalesOrdersResponse ordersResponse =
          SalesOrdersResponse.fromJson(response.data);
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
      entry.data = List<SalesOrderModel>();
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
