import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/state/state.dart';

///合作商状态管理
class CooperatorState extends PageState {
  String factoryUid;
  CooperatorState({this.factoryUid});

  Map<String, Object> _queryFormData = {};

  List<CooperatorModel> _cooperatorModels;
  bool _showTopBtn = false;

  List<CooperatorModel> get cooperatorModels {
    if (_cooperatorModels == null) {
      getData();
    }
    return _cooperatorModels;
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
//    if(UserBLoC.instance.currentUser.type == UserType.BRAND){
    response =
    await CooperatorRepositoryImpl().list(data: _queryFormData, params: {
      'page': currentPage,
      'size': pageSize,
    });
//    }else{
//      response = await CooperatorRepositoryImpl().list(data:_queryFormData, params:{
//        'page': currentPage,
//        'size': pageSize,
//      });
//    }

    if (response != null) {
      _cooperatorModels = response.content;
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
        response = await CooperatorRepositoryImpl()
            .list(data: _queryFormData, params: {
          'page': currentPage + 1,
          'size': pageSize,
        });

        if (response != null) {
          _cooperatorModels.addAll(response.content);
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
    _cooperatorModels = null;
    reset();
    notifyListeners();
  }
}
