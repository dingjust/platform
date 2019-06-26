import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/response/order_response.dart';

class RequirementPoolBLoC extends BLoCBase {
  // 工厂模式
  factory RequirementPoolBLoC() => _getInstance();

  static RequirementPoolBLoC get instance => _getInstance();
  static RequirementPoolBLoC _instance;

  RequirementPoolBLoC._internal() {
    // 初始化
  }

  static RequirementPoolBLoC _getInstance() {
    if (_instance == null) {
      _instance = new RequirementPoolBLoC._internal();
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

  filterByCondition(
      RequirementFilterCondition conditions, bool isRecommend) async {
    if (!lock) {
      lock = true;
      //重置参数
      reset();
      Map data = generateConditionsMap(conditions, isRecommend);
      Response<Map<String, dynamic>> response;
      try {
        if (isRecommend) {
          response = await http$.post(OrderApis.allRecommendedOrders,
              data: data,
              queryParameters: {'page': currentPage, 'size': pageSize,'fields':RequirementOrderOptions.DEFAULT});
        } else {
          response = await http$.post(OrderApis.allOrdersForFactory,
              data: data,
              queryParameters: {'page': currentPage, 'size': pageSize,'fields':RequirementOrderOptions.DEFAULT});
        }
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

  loadingMoreByCondition(
      RequirementFilterCondition conditions, bool isRecommend) async {
    if (!lock) {
      lock = true;

      //数据到底
      if (currentPage + 1 == totalPages) {
        //通知显示已经到底部
        _bottomController.sink.add(true);
      } else {
        Map data = generateConditionsMap(conditions, isRecommend);
        Response<Map<String, dynamic>> response;
        try {
          currentPage++;
          if (isRecommend) {
            response = await http$.post(OrderApis.allRecommendedOrders,
                data: data,
                queryParameters: {'page': currentPage, 'size': pageSize});
          } else {
            response = await http$.post(OrderApis.allOrdersForFactory,
                data: data,
                queryParameters: {'page': currentPage, 'size': pageSize});
          }
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

  clear() async {
    //清空
    _requirementOrders.clear();
    _controller.sink.add(null);
  }

  void reset() {
    _requirementOrders = [];
    currentPage = 0;
    totalPages = 0;
    totalElements = 0;
  }

  //页面控制

  var _loadingController = StreamController<bool>.broadcast();
  var _bottomController = StreamController<bool>.broadcast();
  var _toTopBtnController = StreamController<bool>.broadcast();
  var _returnToTopController = StreamController<bool>.broadcast();

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

  dispose() {
    _controller.close();
  }

  /// 生成查询条件信息
  Map generateConditionsMap(
      RequirementFilterCondition conditions, bool isRecommend) {
    Map data = new Map();
    if (isRecommend) {
      data = {"private": 1};
    }
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

    if (conditions.keyword != null) {
      data['keyword'] = conditions.keyword;
    }

    if (conditions.productiveOrientations != null) {
      data['productiveOrientations'] = conditions.productiveOrientations
          .map((region) => region.isocode)
          .toList();
    }

    return data;
  }
}

const MachiningTYpeMap = {
  MachiningType.LABOR_AND_MATERIAL: 'LABOR_AND_MATERIAL',
  MachiningType.LIGHT_PROCESSING: 'LIGHT_PROCESSING',
};

class RequirementFilterCondition {
  RequirementOrderDateRange dateRange;

  MachiningType machiningType;

  List<CategoryModel> categories;

  List<RegionModel> productiveOrientations;

  String keyword;

  RequirementFilterCondition({
    this.dateRange,
    this.machiningType,
    this.categories,
    this.keyword,
    this.productiveOrientations,
  });
}

enum RequirementOrderDateRange {
  ALL,

  /// 3天内
  RANGE_3,

  /// 一周内
  RANGE_7,

  /// 15天内
  RANGE_15
}
