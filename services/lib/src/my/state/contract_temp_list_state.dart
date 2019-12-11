import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/state/state.dart';

///工厂产能状态管理
class ContractTempListState extends PageState {
  ContractTempListState();
  
  Map<String,Object> _queryFormData = {};

  List<ContractTemplateModel> _contractTempModels;
  bool _showTopBtn = false;


  List<ContractTemplateModel> get contractTempModels {
    if (_contractTempModels == null) {
      getData();
    }
    return _contractTempModels;
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
    response = await ContractRepository().getContractTempList(_queryFormData, {
      'page': currentPage,
      'size': pageSize,
    });

    if (response != null) {
      _contractTempModels = response.content;
      pageSize = response.size;
      currentPage = response.number;
      totalPages = response.totalPages;
      totalElements = response.totalElements;
    }

    ///通知刷新
    notifyListeners();
  }

  @override
  void loadMore() async {
    print(_queryFormData);
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        isDownEnd = false;
        var response;
        response = await ContractRepository().getContractTempList(_queryFormData, {
          'page': currentPage + 1,
          'size': pageSize,
        });

        if (response != null) {
          _contractTempModels.addAll(response.content);
          pageSize = response.size;
          currentPage = response.number;
          totalPages = response.totalPages;
          totalElements = response.totalElements;
        }

      }else{
        isDownEnd = true;
      }
      //异步调用结束，通知加载组件
      workingEnd();
    }
  }

  @override
  void clear() {
    _contractTempModels = null;
    reset();
    notifyListeners();
  }
}
