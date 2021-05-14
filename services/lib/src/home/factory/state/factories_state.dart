import 'package:models/models.dart';
import 'package:services/src/home/factory/repository/factory_repository.dart';
import 'package:services/src/state/state.dart';

///工厂信息状态管理
class FactoriesState extends PageState {
  List<FactoryModel> _factories;

  List<FactoryModel> get factories {
    if (_factories == null) {
      getData();
    }
    return _factories;
  }

  @override
  getData() {
    FactoryRepository.getFactories(
            params: {'page': 0, 'size': pageSize, "sort": "creationtime,DESC"},
            data: getParamsData())
        .then((response) {
      if (response != null) {
        _factories = response.content;
        pageSize = response.size;
        currentPage = response.number;
        totalPages = response.totalPages;
        totalElements = response.totalElements;

        ///通知刷新
        notifyListeners();
      }
    });
  }

  @override
  loadMore() async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        await FactoryRepository.getFactories(params: {
          'page': ++currentPage,
          'size': pageSize,
          "sort": "creationtime,DESC"
        }, data: getParamsData())
            .then((response) {
          if (response != null) {
            _factories.addAll(response.content);
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

  Map<String, dynamic> getParamsData() {
    return {'profileCompleted': true, 'enableShow': true};
  }

  @override
  clear() {
    _factories = null;
    reset();
    notifyListeners();
  }
}
