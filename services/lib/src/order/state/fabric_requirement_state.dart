import 'package:services/src/state/state.dart';

///面料需求状态管理
class FabricRequirementState extends PageState {
  List<String> _fabricRequirements;

  List<String> get fabricRequirements {
    if (_fabricRequirements == null) {
      getData();
    }
    return _fabricRequirements;
  }

  @override
  void getData() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      _fabricRequirements = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
      totalPages = 3;

      ///通知刷新
      notifyListeners();
    });
  }

  @override
  void clear() {
    _fabricRequirements = null;

    notifyListeners();
  }

  @override
  void loadMore() async {
    if (!lock) {
      //接口调用：
      if (currentPage + 1 != totalPages) {
        //异步调用开始，通知加载组件
        workingStart();

        ++currentPage;
        Future.delayed(Duration(seconds: 3)).then((value) {
          _fabricRequirements
              .addAll(['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']);
          //异步调用结束，通知加载组件
          workingEnd();
        });
      }
    }
  }
}
