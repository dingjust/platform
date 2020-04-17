import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/state/state.dart';

///工厂产能状态管理
class ContractListState extends PageState {
  ContractListState();

  Map<String, Object> _queryFormData = {};

  List<ContractModel> _contractModels;
  bool _showTopBtn = false;

  List<ContractModel> get contractModels {
    if (_contractModels == null) {
      getData();
    }
    return _contractModels;
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
    var response;
    response = await ContractRepository().getContractList(_queryFormData, {
      'page': currentPage,
      'size': pageSize,
    });

    if (response != null) {
      _contractModels = response.content;
      pageSize = response.size;
      currentPage = response.number;
      totalPages = response.totalPages;
      totalElements = response.totalElements;

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
        var response;
        response = await ContractRepository().getContractList(_queryFormData, {
          'page': currentPage + 1,
          'size': pageSize,
        });

        if (response != null) {
          _contractModels.addAll(response.content);
          pageSize = response.size;
          currentPage = response.number;
          totalPages = response.totalPages;
          totalElements = response.totalElements;
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
    _contractModels = null;
    reset();
    notifyListeners();
  }
}
