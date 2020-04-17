import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/state/state.dart';

///工厂产能状态管理
class RequirementOrderSelectState extends PageState {
  String factoryUid;

  RequirementOrderSelectState({this.factoryUid});

  Map<String, Object> _queryFormData = {};

  List<RequirementOrderModel> _requiremenOrderModels;
  bool _showTopBtn = false;

  List<RequirementOrderModel> get requiremenOrderModels {
    if (_requiremenOrderModels == null) {
      getData();
    }
    return _requiremenOrderModels;
  }

  bool get showTopBtn => _showTopBtn;

  set showTopBtn(bool value) {
    _showTopBtn = value;
    notifyListeners();
  }

  Map<String, Object> get queryFormData => _queryFormData;

  set queryFormData(Map<String, Object> value) {
    _queryFormData = value;
  }

  @override
  void getData() async {
    print(_queryFormData);
    isDownEnd = false;

    Response<Map<String, dynamic>> response;
    try {
      response = await http$.post(OrderApis.requirementOrders,
          data: _queryFormData,
          queryParameters: {
            'page': currentPage,
            'size': pageSize,
          });
    } on DioError catch (e) {
      print(e);
    }

    if (response != null) {
      RequirementOrdersResponse ordersResponse =
      RequirementOrdersResponse.fromJson(response.data);
      _requiremenOrderModels = ordersResponse.content;
      pageSize = ordersResponse.size;
      currentPage = ordersResponse.number;
      totalPages = ordersResponse.totalPages;
      totalElements = ordersResponse.totalElements;

      ///通知刷新
      notifyListeners();
    }
  }

  @override
  void loadMore() async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        isDownEnd = false;
        Response<Map<String, dynamic>> response;
        try {
          response = await http$.post(OrderApis.requirementOrders,
              data: _queryFormData,
              queryParameters: {
                'page': currentPage + 1,
                'size': pageSize,
              });
        } on DioError catch (e) {
          print(e);
        }

        if (response != null) {
          RequirementOrdersResponse ordersResponse =
          RequirementOrdersResponse.fromJson(response.data);
          _requiremenOrderModels.addAll(ordersResponse.content);
          pageSize = ordersResponse.size;
          currentPage = ordersResponse.number;
          totalPages = ordersResponse.totalPages;
          totalElements = ordersResponse.totalElements;
        }
      } else {
        isDownEnd = true;
      }
      //异步调用结束，通知加载组件
      workingEnd();
    }
  }

  @override
  void clear() {
    _requiremenOrderModels = null;
    reset();
    notifyListeners();
  }
}
