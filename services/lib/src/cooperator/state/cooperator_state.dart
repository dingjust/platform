import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/src/capacity/repository/capacity_repository.dart';
import 'package:services/src/product/product_repository.dart';
import 'package:services/src/state/state.dart';

import '../../../services.dart';

///工厂产能状态管理
class CooperatorState extends PageState {
  String factoryUid;
  CooperatorState({this.factoryUid});

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

  @override
  void getData() async {
    var response;
    if(UserBLoC.instance.currentUser.type == UserType.BRAND){
      response = await CooperatorRepositoryImpl().list(data:{}, params:{
        'page': currentPage,
        'size': pageSize,
      });
    }else{
      response = await CooperatorRepositoryImpl().list(data:{}, params:{
        'page': currentPage,
        'size': pageSize,
      });
    }

    if (response != null) {
      _cooperatorModels = response.content;
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
        var response;
        if(UserBLoC.instance.currentUser.type == UserType.BRAND){
          response = await ProductRepositoryImpl().getProductsOfFactory({}, {
            'page': currentPage,
            'size': pageSize,
          },factoryUid);
        }else{
          response = await ProductRepositoryImpl().list({}, {
            'page': currentPage,
            'size': pageSize,
          });
        }

        if (response != null) {
          _cooperatorModels.addAll(response.content);
          pageSize = response.size;
          currentPage = response.number;
          totalPages = response.totalPages;
          totalElements = response.totalElements;
        }
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
