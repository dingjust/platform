import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/order/response/delivery_order_response.dart';
import 'package:services/src/state/state.dart';

///外接订单状态管理
class DeliveryOrdersState extends PageState {
  Map<String, PageEntry> _ordersMap = {
    'ALL': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<FastShippingSheetModel>(),
        totalElements: -1),
    'PENDING_RECONCILED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<FastShippingSheetModel>(),
        totalElements: -1),
    'IN_RECONCILED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<FastShippingSheetModel>(),
        totalElements: -1),
    'COMPLETED': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<FastShippingSheetModel>(),
        totalElements: -1),
  };

  String _keyword = '';

  String get getKeyword => _keyword;

  void setKeyword(String keywords) {
    _keyword = keywords;
    //清空数据
    this.clear();
  }

  PageEntry getEntry(String status, {String keyword}) {
    if (_ordersMap[status].totalElements < 0) {
      getOrders(status);
    }
    return _ordersMap[status];
  }

  List<FastShippingSheetModel> orders(String status, {String keyword}) {
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
        'keyword': _keyword != '' ? _keyword : null,
      };
      if (status != '' && status != 'ALL') {
        data['states'] = [status];
      }

      Response<Map<String, dynamic>> response;

      try {
        response = await http$
            .post(OrderApis.deliveryOrderList, data: data, queryParameters: {
          'page': _ordersMap[status].currentPage,
          'size': _ordersMap[status].size,
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        DeliveryOrderResponse ordersResponse =
            DeliveryOrderResponse.fromJson(response.data);
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
          'keyword': _keyword != '' ? _keyword : null,
        };
        if (status != '' && status != 'ALL') {
          data['states'] = [status];
        }

        Response<Map<String, dynamic>> response;
        try {
          response = await http$
              .post(OrderApis.deliveryOrderList, data: data, queryParameters: {
            'page': ++_ordersMap[status].currentPage,
            'size': _ordersMap[status].size,
          });
        } on DioError catch (e) {
          print(e);
        }

        if (response.statusCode == 200) {
          DeliveryOrderResponse ordersResponse =
          DeliveryOrderResponse.fromJson(response.data);
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
      entry.data = List<FastShippingSheetModel>();
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
