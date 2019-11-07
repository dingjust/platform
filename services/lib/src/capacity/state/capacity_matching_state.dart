import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/src/capacity/repository/capacity_repository.dart';
import 'package:services/src/state/state.dart';

///匹配产能状态管理
class CapacityMatchingState extends PageState {
  List<FactoryCapacityModel> _factoryCapacityModels;

  ///关键字
  String keyword;

  ///时间起
  DateTime dateStartPoint;

  ///时间止
  DateTime dateEndPoint;

  List<FactoryCapacityModel> get factoryCapacityModels {
    if (_factoryCapacityModels == null) {
      getData();
    }
    return _factoryCapacityModels;
  }

  @override
  void getData() {
    Map params = {};
    generateQueryParams(params);
    CapacityRepository().search(params, {
      'page': 0,
      'size': pageSize,
    }).then((response) {
      if (response != null) {
        _factoryCapacityModels = response.content;
        pageSize = response.size;
        currentPage = response.number;
        totalPages = response.totalPages;
        totalElements = response.totalElements;
      }

      ///通知刷新
      notifyListeners();
    });
  }

  @override
  void loadMore() async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      Map params = {};
      generateQueryParams(params);
      //接口调用：
      if (currentPage + 1 != totalPages) {
        await CapacityRepository().search(params, {
          'page': ++currentPage,
          'size': pageSize,
        }).then((response) {
          if (response != null) {
            _factoryCapacityModels.addAll(response.content);
            pageSize = response.size;
            currentPage = response.number;
            totalPages = response.totalPages;
            totalElements = response.totalElements;
          }
        });
      }
      //异步调用结束，通知加载组件
      workingEnd();
    }
  }

  @override
  void clear() {
    _factoryCapacityModels = null;
    reset();
    notifyListeners();
  }

  void generateQueryParams(Map params) {
    if (keyword != null && keyword != '') {
      params['keyword'] = keyword;
    }
    if (dateStartPoint != null) {
      params['dateStartPoint'] = DateFormatUtil.formatYMD(dateStartPoint);
    }
    if (dateEndPoint != null) {
      params['dateEndPoint'] = DateFormatUtil.formatYMD(dateEndPoint);
    }
  }

  void setDateStartPoint(DateTime newValue) {
    dateStartPoint = newValue;
  }

  void setDateEndPoint(DateTime newValue) {
    dateEndPoint = newValue;
  }

  void setKeywords(String newValue) {
    if (newValue == '') {
      keyword = null;
    } else {
      keyword = newValue;
    }
    clear();
  }
}
