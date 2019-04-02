import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/response/order_response.dart';

class RequirementRecommendBloc extends BLoCBase{
  // 工厂模式
  factory RequirementRecommendBloc() => _getInstance();

  static RequirementRecommendBloc get instance => _getInstance();
  static RequirementRecommendBloc _instance;

  RequirementRecommendBloc._internal() {
    // 初始化
  }

  static RequirementRecommendBloc _getInstance() {
    if (_instance == null) {
      _instance = new RequirementRecommendBloc._internal();
    }
    return _instance;
  }

  List<RequirementOrderModel> _requirementOrders = [];

  int pageSize = 10;
  int currentPage = 0;
  int totalPages = 0;
  int totalElements = 0;

  //锁
  bool lock = false;

  List<RequirementOrderModel> get requirementOrders => _requirementOrders;

  var _controller = StreamController<List<RequirementOrderModel>>.broadcast();

  Stream<List<RequirementOrderModel>> get stream => _controller.stream;

  var conditionController = StreamController<FilterConditionEntry>.broadcast();

  Stream<FilterConditionEntry> get conditionStream =>
      conditionController.stream;

  void reset() {
    _requirementOrders = [];
    currentPage = 0;
    totalPages = 0;
    totalElements = 0;
  }

  filterByCondition(RequirementFilter conditions) async {
    if (!lock) {
      lock = true;
      //重置参数
      reset();
      Map data = generateConditionsMap(conditions);
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.post(OrderApis.allRecommendedOrders,
            data: data,
            queryParameters: {'page': currentPage, 'size': pageSize});
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        RequirementOrdersResponse ordersResponse =
        RequirementOrdersResponse.fromJson(response.data);
        totalPages = ordersResponse.totalPages;
        totalElements = ordersResponse.totalElements;
        _requirementOrders.clear();
        _requirementOrders.addAll(ordersResponse.content);
      }
      _controller.sink.add(_requirementOrders);
      lock = false;
    }
  }

  loadingMoreByCondition(RequirementFilter conditions) async {
    if (!lock) {
      lock = true;

      //数据到底
      if (currentPage + 1 == totalPages) {
        //通知显示已经到底部
        _bottomController.sink.add(true);
      } else {
        Map data = generateConditionsMap(conditions);
        Response<Map<String, dynamic>> response;
        try {
          currentPage++;
          response = await http$.post(OrderApis.requirementOrdersAll,
              data: data,
              queryParameters: {'page': currentPage, 'size': pageSize});
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          RequirementOrdersResponse ordersResponse =
          RequirementOrdersResponse.fromJson(response.data);
          totalPages = ordersResponse.totalPages;
          totalElements = ordersResponse.totalElements;
          _requirementOrders.addAll(ordersResponse.content);
        }
      }
      _loadingController.sink.add(false);
      _controller.sink.add(_requirementOrders);
      lock = false;
    }
  }


  var _loadingController = StreamController<bool>.broadcast();
  var _bottomController = StreamController<bool>.broadcast();
  var _toTopBtnController = StreamController<bool>.broadcast();
  var _returnToTopController = StreamController<bool>.broadcast();

  /// 生成查询条件信息
  Map generateConditionsMap(RequirementFilter conditions) {
    Map data = {"private": 0};
    // 计算时间范围
    DateTime expectedDeliveryDateTo = DateTime.now();
    DateTime expectedDeliveryDateFrom;
    switch (conditions.dateRange) {
      case RequirementOrderDateRange.RANGE_3:
        expectedDeliveryDateFrom =
            expectedDeliveryDateTo.subtract(Duration(days: 3));
        break;
      case RequirementOrderDateRange.RANGE_7:
        expectedDeliveryDateFrom =
            expectedDeliveryDateTo.subtract(Duration(days: 7));
        break;
      case RequirementOrderDateRange.RANGE_15:
        expectedDeliveryDateFrom =
            expectedDeliveryDateTo.subtract(Duration(days: 15));
        break;
      default:
        expectedDeliveryDateFrom = null;
    }

    if (expectedDeliveryDateFrom != null) {
      data['expectedDeliveryDateFrom'] =
          expectedDeliveryDateFrom.millisecondsSinceEpoch;
      data['expectedDeliveryDateTo'] =
          expectedDeliveryDateTo.millisecondsSinceEpoch;
    }

    if (conditions.machiningType != null) {
      data['machiningTypes'] = [MachiningTYpeMap[conditions.machiningType]];
    }

    if (conditions.categories != null) {
      data['majorCategories'] =
          conditions.categories.map((category) => category.code).toList();
    }

    return data;
  }

  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<bool> get bottomStream => _bottomController.stream;

  Stream<bool> get toTopBtnStream => _toTopBtnController.stream;

  Stream<bool> get returnToTopStream => _returnToTopController.stream;

  loadingStart() async {
    _loadingController.sink.add(true);
  }

  loadingEnd() async {
    _loadingController.sink.add(false);
  }

  showToTopBtn() async {
    _toTopBtnController.sink.add(true);
  }

  hideToTopBtn() async {
    _toTopBtnController.sink.add(false);
  }

  returnToTop() async {
    _returnToTopController.sink.add(true);
  }



  clear() async {
    //清空
    _requirementOrders.clear();
    _controller.sink.add(null);
  }

  @override
  void dispose() {
  }

  /// 生成查询条件信息
  Map generateConditions(RequirementFilter conditions) {
    Map data = {"private": 0};
    // 计算时间范围
    DateTime expectedDeliveryDateTo = DateTime.now();
    DateTime expectedDeliveryDateFrom;
    switch (conditions.dateRange) {
      case RequirementOrderDateRange.RANGE_3:
        expectedDeliveryDateFrom =
            expectedDeliveryDateTo.subtract(Duration(days: 3));
        break;
      case RequirementOrderDateRange.RANGE_7:
        expectedDeliveryDateFrom =
            expectedDeliveryDateTo.subtract(Duration(days: 7));
        break;
      case RequirementOrderDateRange.RANGE_15:
        expectedDeliveryDateFrom =
            expectedDeliveryDateTo.subtract(Duration(days: 15));
        break;
      default:
        expectedDeliveryDateFrom = null;
    }

    if (expectedDeliveryDateFrom != null) {
      data['expectedDeliveryDateFrom'] =
          expectedDeliveryDateFrom.millisecondsSinceEpoch;
      data['expectedDeliveryDateTo'] =
          expectedDeliveryDateTo.millisecondsSinceEpoch;
    }

    if (conditions.machiningType != null) {
      data['machiningTypes'] = [MachiningTYpeMap[conditions.machiningType]];
    }

    if (conditions.categories != null) {
      data['majorCategories'] =
          conditions.categories.map((category) => category.code).toList();
    }

    return data;
  }

}

const MachiningTypeMap = {
  MachiningType.LABOR_AND_MATERIAL: 'LABOR_AND_MATERIAL',
  MachiningType.LIGHT_PROCESSING: 'LIGHT_PROCESSING',
};

class RequirementFilter {
  RequirementOrderDateRange dateRange;

  MachiningType machiningType;

  List<CategoryModel> categories;

  RequirementFilter(
      {this.dateRange, this.machiningType, this.categories});
}

enum orderDateRange {
  ALL,

  /// 3天内
  RANGE_3,

  /// 一周内
  RANGE_7,

  /// 15天内
  RANGE_15
}