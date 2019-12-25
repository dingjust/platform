import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/state/state.dart';
import 'package:services/src/subcontract/repository/subcontract_repository_impl.dart';

///工厂产能状态管理
class SubContractMineState extends PageState {
  List<SubContractModel> _subcontractModels;
  String _keyword;
  bool _showTopBtn = false;

  bool get showTopBtn => _showTopBtn;

  set showTopBtn(bool value) {
    _showTopBtn = value;
    notifyListeners();
  }

  @override
  void getData() async {
    isDownEnd = false;
    var response = await SubContractRepositoryImpl().getSubcontracts(data:{'keyword':_keyword}, params:{
      'page': currentPage,
      'size': pageSize,
    });

    if (response != null) {
      _subcontractModels = response.content;
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

    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        isDownEnd = false;
        var response= await SubContractRepositoryImpl().getSubcontracts(data:{'keyword':_keyword}, params:{
          'page': currentPage + 1,
          'size': pageSize,
        });

        if (response != null) {
          _subcontractModels.addAll(response.content);
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
    _subcontractModels = null;
    reset();
    notifyListeners();
  }


  List<SubContractModel> get subcontractModels {
    if (_subcontractModels == null) {
      getData();
    }
    return _subcontractModels;
  }

  String get keyword {
   if(_keyword == null){
     _keyword = '';
   }
   return _keyword;
  }

  set keyword(String value) {
    _keyword = value;
    notifyListeners();
    clear();
  }

}
