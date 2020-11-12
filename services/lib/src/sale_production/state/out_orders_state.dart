import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/sale_production.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/sale_production/response/out_order_response.dart';
import 'package:services/src/state/state.dart';

///外发订单状态管理
class OutOrdersState extends PageState {
  Map<String, PageEntry> _ordersMap = {
    'TO_BE_ACCEPTED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesProductionOrderModel>(),
        totalElements: -1),
    'TO_BE_SUBMITTED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesProductionOrderModel>(),
        totalElements: -1),
    'AUDITING': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesProductionOrderModel>(),
        totalElements: -1),
    'AUDIT_REJECTED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesProductionOrderModel>(),
        totalElements: -1),
    'AUDIT_PASSED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesProductionOrderModel>(),
        totalElements: -1),
    'COMPLETED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesProductionOrderModel>(),
        totalElements: -1),
    'CANCELED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<SalesProductionOrderModel>(),
        totalElements: -1),
  };

  String _keyword = '';

  String get getKeyword => _keyword;

  void setKeyword(String keywords) {
    _keyword = keywords;
    // 清空数据
    this.clear();
  }

  PageEntry getEntry(String status, {String keyword}) {
    if (_ordersMap[status].totalElements < 0) {
      getOrders(status);
    }
    return _ordersMap[status];
  }

  List<SalesProductionOrderModel> orders(String status, {String keyword}) {
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
      Map data = {
        'depts': [0],
        'users': [],
        'name': _keyword != '' ? _keyword : null
      };
      if (status != '' && status != 'SEARCH') {
        data['state'] = status;
      }

      Response<Map<String, dynamic>> response;

      try {
        response = await http$.post(SaleProductionApis.outOrderList,
            data: data,
            queryParameters: {
              'page': _ordersMap[status].currentPage,
              'size': _ordersMap[status].size,
            });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        OutOrdersResponse ordersResponse =
            OutOrdersResponse.fromJson(response.data);
        _ordersMap[status].totalPages = ordersResponse.totalPages;
        _ordersMap[status].totalElements = ordersResponse.totalElements;
        _ordersMap[status].data.clear();
        _ordersMap[status].data.addAll(ordersResponse.content);

        ///通知刷新
        notifyListeners();
      }
    }
  }

  void loadMoreOrders(String status) async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (_ordersMap[status].currentPage + 1 != _ordersMap[status].totalPages) {
        Map data = {
          'depts': [0],
          'users': [],
          'name': _keyword != '' ? _keyword : null
        };
        if (status != 'ALL') {
          data['state'] = status;
        }

        Response<Map<String, dynamic>> response;
        try {
          response = await http$.post(SaleProductionApis.outOrderList,
              data: data,
              queryParameters: {
                'page': ++_ordersMap[status].currentPage,
                'size': _ordersMap[status].size,
              });
        } on DioError catch (e) {
          print(e);
        }

        if (response.statusCode == 200) {
          OutOrdersResponse ordersResponse =
          OutOrdersResponse.fromJson(response.data);
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
      entry.data = List<SalesProductionOrderModel>();
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
