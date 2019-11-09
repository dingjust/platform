import 'package:models/models.dart';
import 'package:services/src/capacity/repository/capacity_repository.dart';
import 'package:services/src/state/state.dart';

///工厂产能状态管理
class MyCapacityState extends PageState {
  List<FactoryCapacityModel> _factoryCapacityModels;

  List<FactoryCapacityModel> get factoryCapacityModels {
    if (_factoryCapacityModels == null) {
      getData();
    }
    return _factoryCapacityModels;
  }

  @override
  void getData() {
    CapacityRepository().list({}, {
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
      //接口调用：
      if (currentPage + 1 != totalPages) {
        await CapacityRepository().list({}, {
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
}
