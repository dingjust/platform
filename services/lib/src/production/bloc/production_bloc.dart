import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/order/response/order_response.dart';

class ProductionBLoC extends BLoCBase {
  // 工厂模式
  factory ProductionBLoC() => _getInstance();

  static ProductionBLoC get instance => _getInstance();
  static ProductionBLoC _instance;

  ProductionBLoC._internal() {
    // 初始化
  }

  static ProductionBLoC _getInstance() {
    if (_instance == null) {
      _instance = new ProductionBLoC._internal();
    }
    return _instance;
  }

  static final List<PurchaseOrderModel> _purchaseOrders = [];

  static final Map<String, PageEntry> _ordersMap = {
    'IN_PRODUCTION':
    PageEntry(currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
  };

  //维护筛选条件
  List<FilterConditionEntry> _orderType = [
    FilterConditionEntry(label: '全部', value: 'ALL', checked: true),
    FilterConditionEntry(label: '线上订单', value: 'ONLINE'),
    FilterConditionEntry(label: '线下订单', value: 'BELOW_THE_LINE'),
  ];

  List<FilterConditionEntry> _currentStatus = [
    FilterConditionEntry(label: '全部', value: 'ALL', checked: true),
    FilterConditionEntry(label: '备料', value: 'MATERIAL_PREPARATION'),
    FilterConditionEntry(label: '裁剪', value: 'CUTTING'),
    FilterConditionEntry(label: '车缝', value: 'STITCHING'),
    FilterConditionEntry(label: '后整', value: 'AFTER_FINISHING'),
    FilterConditionEntry(label: '验货', value: 'INSPECTION'),
  ];

  DateTime _startDate;
  DateTime _endDate;

  String _status;

//  List<PurchaseOrderModel> orders() => _purchaseOrders;

  List<PurchaseOrderModel> orders(String status) => _ordersMap['IN_PRODUCTION'].data;

  List<FilterConditionEntry> get orderType => _orderType;

  List<FilterConditionEntry> get currentStatus => _currentStatus;

  List<String> typeList = new List();
  List<String> phasesList = new List();

  String get status => _status;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  void setOrderType(List<FilterConditionEntry> conditions) {
    _orderType = conditions;
  }

  void setCurrentStatus(List<FilterConditionEntry> conditions) {
    _currentStatus = conditions;
  }

  void setStartDate(DateTime date) {
    _startDate = date;
  }

  void setEndDate(DateTime date) {
    _endDate = date;
  }

  void setStatus(String status) {
    _status = status;
  }

  var _controller = StreamController<List<PurchaseOrderModel>>.broadcast();

  Stream<List<PurchaseOrderModel>> get stream => _controller.stream;

  var conditionController = StreamController<FilterConditionEntry>.broadcast();

  Stream<FilterConditionEntry> get conditionStream => conditionController.stream;

  getData(String keyword) async {

    //若没有数据则查询
    if (_ordersMap['IN_PRODUCTION'].data.length == 0) {
      //  分页拿数据，response.data;
      if (orderType != null && orderType.length > 0) {
        typeList.clear();
        for (int i = 0; i < orderType.length; i++) {
          if (orderType[i].checked && orderType[i].value != 'ALL') {
            typeList.add(orderType[i].value);
          }
        }
      }
      if (currentStatus != null && currentStatus.length > 0) {
        phasesList.clear();
        for (int i = 0; i < currentStatus.length; i++) {
          if (currentStatus[i].checked && currentStatus[i].value != 'ALL') {
            phasesList.add(currentStatus[i].value);
          }
        }
      }
      //请求参数
      Map data = {
        'keyword': keyword,
        'salesApplications': typeList,
        'phases': phasesList,
        'expectedDeliveryDateFrom': startDate == null ? null : startDate
            .millisecondsSinceEpoch,
        'expectedDeliveryDateTo': endDate == null ? null : endDate
            .millisecondsSinceEpoch,
        'statuses': 'IN_PRODUCTION',
      };

      Response<Map<String, dynamic>> response;

      try {
        response = await http$.post(OrderApis.purchaseOrders, data: data,
            queryParameters: {
              'page': _ordersMap['IN_PRODUCTION'].currentPage,
              'size': _ordersMap['IN_PRODUCTION'].size,
              'fields': PurchaseOrderOptions.BASIC,
            }
        );
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        PurchaseOrdersResponse ordersResponse = PurchaseOrdersResponse.fromJson(
            response.data);
//        _purchaseOrders.clear();
//        _purchaseOrders.addAll(ordersResponse.content);

        _ordersMap['IN_PRODUCTION'].totalPages = ordersResponse.totalPages;
        _ordersMap['IN_PRODUCTION'].totalElements =
            ordersResponse.totalElements;
        _ordersMap['IN_PRODUCTION'].data.clear();
        _ordersMap['IN_PRODUCTION'].data.addAll(ordersResponse.content);
      }
    }
    if (status == 'delayWarning') {
      List<PurchaseOrderModel> orders = [];
      for (int i = 0; i < _ordersMap['IN_PRODUCTION'].data.length; i++) {
        if (_ordersMap['IN_PRODUCTION'].data[i].delayedDays > 0) {
          orders.add(_ordersMap['IN_PRODUCTION'].data[i]);
        }
      }
      _controller.sink.add(orders);
    } else {
      _controller.sink.add(_ordersMap['IN_PRODUCTION'].data);
    }
  }


  getDataMore(String keyword) async {

    //若没有数据则查询
    if (_ordersMap['IN_PRODUCTION'].currentPage + 1 == _ordersMap['IN_PRODUCTION'].totalPages) {
      //通知显示已经到底部
      bottomController.sink.add(true);
    } else {
      //  分页拿数据，response.data;
      if (orderType != null && orderType.length > 0) {
        typeList.clear();
        for (int i = 0; i < orderType.length; i++) {
          if (orderType[i].checked && orderType[i].value != 'ALL') {
            typeList.add(orderType[i].value);
          }
        }
      }
      if (currentStatus != null && currentStatus.length > 0) {
        phasesList.clear();
        for (int i = 0; i < currentStatus.length; i++) {
          if (currentStatus[i].checked && currentStatus[i].value != 'ALL') {
            phasesList.add(currentStatus[i].value);
          }
        }
      }
      //请求参数
      Map data = {
        'keyword': keyword,
        'salesApplications': typeList,
        'phases': phasesList,
        'expectedDeliveryDateFrom': startDate == null ? null : startDate
            .millisecondsSinceEpoch,
        'expectedDeliveryDateTo': endDate == null ? null : endDate
            .millisecondsSinceEpoch,
        'statuses': 'IN_PRODUCTION',
      };

      Response<Map<String, dynamic>> response;

      try {
        response = await http$.post(OrderApis.purchaseOrders, data: data,
            queryParameters: {
              'page': ++_ordersMap['IN_PRODUCTION'].currentPage,
              'size': _ordersMap['IN_PRODUCTION'].size,
              'fields': PurchaseOrderOptions.BASIC,
            }
        );
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        PurchaseOrdersResponse ordersResponse = PurchaseOrdersResponse.fromJson(
            response.data);
//        _purchaseOrders.clear();
//        _purchaseOrders.addAll(ordersResponse.content);

        _ordersMap['IN_PRODUCTION'].totalPages = ordersResponse.totalPages;
        _ordersMap['IN_PRODUCTION'].totalElements =
            ordersResponse.totalElements;
        _ordersMap['IN_PRODUCTION'].data.addAll(ordersResponse.content);
      }
    }
    if (status == 'delayWarning') {
      List<PurchaseOrderModel> orders = [];
      for (int i = 0; i < _ordersMap['IN_PRODUCTION'].data.length; i++) {
        if (_ordersMap['IN_PRODUCTION'].data[i].delayedDays > 0) {
          orders.add(_ordersMap['IN_PRODUCTION'].data[i]);
        }
      }
      _controller.sink.add(orders);
    } else {
      _controller.sink.add(_ordersMap['IN_PRODUCTION'].data);
    }
    loadingController.sink.add(false);
  }


  clear() async {
    //清空
    _purchaseOrders.clear();
    _controller.sink.add(null);
  }

  //下拉刷新
  Future refreshData(String keyword) async {
    _purchaseOrders.clear();

    if (orderType != null && orderType.length > 0) {
      typeList.clear();
      for (int i = 0; i < orderType.length; i++) {
        if (orderType[i].checked && orderType[i].value != 'ALL') {
          typeList.add(orderType[i].value);
        }
      }
    }
    if (currentStatus != null && currentStatus.length > 0) {
      phasesList.clear();
      for (int i = 0; i < currentStatus.length; i++) {
        if (currentStatus[i].checked && currentStatus[i].value != 'ALL') {
          phasesList.add(currentStatus[i].value);
        }
      }
    }
    //请求参数
    Map data = {
      'keyword': keyword,
      'salesApplications': typeList,
      'phases': phasesList,
      'expectedDeliveryDateFrom': startDate == null ? null : startDate.millisecondsSinceEpoch,
      'expectedDeliveryDateTo': endDate == null ? null : endDate.millisecondsSinceEpoch,
      'statuses': 'IN_PRODUCTION',
    };
    Response<Map<String, dynamic>> response;

    try {
      response = await http$.post(OrderApis.purchaseOrders, data: data,
          queryParameters: {
            'page': 0,
            'size': 10,
            'fields': PurchaseOrderOptions.BASIC
          }
          );
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      PurchaseOrdersResponse ordersResponse = PurchaseOrdersResponse.fromJson(response.data);
//      _purchaseOrders.clear();
//      _purchaseOrders.addAll(ordersResponse.content);

      _ordersMap['IN_PRODUCTION'].totalPages = ordersResponse.totalPages;
      _ordersMap['IN_PRODUCTION'].totalElements = ordersResponse.totalElements;
      _ordersMap['IN_PRODUCTION'].data.clear();
      _ordersMap['IN_PRODUCTION'].data.addAll(ordersResponse.content);
    }
    if (status == 'delayWarning') {
      List<PurchaseOrderModel> orders = [];
      for (int i = 0; i < _ordersMap['IN_PRODUCTION'].data.length; i++) {
        if (_ordersMap['IN_PRODUCTION'].data[i].delayedDays > 0) {
          orders.add(_ordersMap['IN_PRODUCTION'].data[i]);
        }
      }
      _controller.sink.add(orders);
    } else {
      _controller.sink.add(_ordersMap['IN_PRODUCTION'].data);
    }
  }

  void reset() {
    _purchaseOrders.clear();
  }

  dispose() {
    _controller.close();
    conditionController.close();

    super.dispose();
  }
}
