import 'package:flutter/material.dart';
import 'package:models/models.dart';

///工厂产能状态管理
class MyCapacityState with ChangeNotifier {
  List<FactoryCapacityModel> _factoryCapacityModels;
  int _pageSize = 10;
  int _currentPage = 0;
  int _totalPages = 10;
  int _totalElements = 0;
  bool _loadingMore = false;
  bool _lock = false;

  int get pageSize => _pageSize;

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  int get totalElements => _totalElements;

  bool get loadingMore => _loadingMore;

  List<FactoryCapacityModel> get factoryCapacityModels {
    if (_factoryCapacityModels == null) {
      getFactoryCapacities();
    }
    return _factoryCapacityModels;
  }

  void getFactoryCapacities() {
    Future.delayed(Duration(seconds: 3)).then((e) {
      _factoryCapacityModels = [];
      _factoryCapacityModels.add(mockData);
      _factoryCapacityModels.add(mockData);
      _factoryCapacityModels.add(mockData);
      _factoryCapacityModels.add(mockData);

      ///通知刷新
      notifyListeners();
    });
  }

  void loadMore() async {
    if (!_lock) {
      _lock = true;
      _loadingMore = true;
      notifyListeners();
      if (currentPage + 1 != totalPages) {
        await Future.delayed(Duration(seconds: 3)).then((e) {
          _factoryCapacityModels.add(mockData);
        });
      }
      _loadingMore = false;
      _lock = false;
      notifyListeners();
    }
  }

  void clear() {
    _factoryCapacityModels.clear();
    _factoryCapacityModels = null;
    notifyListeners();
  }

  FactoryCapacityModel mockData = FactoryCapacityModel(
      id: 1,
      code: '001',
      title: '五七九二哦i窘境请问请问 恶趣味',
      belongTo: FactoryModel(name: '工厂'),
      categoryCapacities: [
        FactoryCategoryCapacityModel(
            capacityRange: 2000, category: CategoryModel(name: '男装--衬衫')),
        FactoryCategoryCapacityModel(
            capacityRange: 2000, category: CategoryModel(name: '男装--衬衫')),
        FactoryCategoryCapacityModel(
            capacityRange: 2000, category: CategoryModel(name: '男装--衬衫')),
      ],
      clickTimes: 1,
      showTimes: 2000,
      dateEndPoint: DateTime.now().add(Duration(days: 30)),
      dateStartPoint: DateTime.now());
}
