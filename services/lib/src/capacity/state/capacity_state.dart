import 'package:models/models.dart';
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

  @override
  void loadMore() async {
    if (!lock) {
      lock = true;
      loadingMore = true;
      notifyListeners();
      if (currentPage + 1 != totalPages) {
        await Future.delayed(Duration(seconds: 3)).then((e) {
          _factoryCapacityModels.add(mockData);
        });
      }
      loadingMore = false;
      lock = false;
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
            capacityRange: 2000,
            category:
                CategoryModel(name: '衬衫', parent: CategoryModel(name: '男装'))),
        FactoryCategoryCapacityModel(
            capacityRange: 2000,
            category:
                CategoryModel(name: '衬衫', parent: CategoryModel(name: '男装'))),
        FactoryCategoryCapacityModel(
            capacityRange: 2000,
            category:
                CategoryModel(name: '衬衫', parent: CategoryModel(name: '男装'))),
      ],
      clickTimes: 1,
      showTimes: 2000,
      dateEndPoint: DateTime.now().add(Duration(days: 30)),
      dateStartPoint: DateTime.now());
}
