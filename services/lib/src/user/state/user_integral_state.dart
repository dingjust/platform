import 'package:models/models.dart';
import 'package:services/src/state/state.dart';

import '../../../services.dart';

///用户积分记录状态管理
class UserIntegralHistoryState extends PageState {
  ///用户积分信息
  UserIntegralInfo _integralInfo;

  List<IntegralHistoryModel> _integralHistories;

  UserIntegralInfo get integralInfo {
    if (_integralInfo == null) {
      getIntegralInfo();
    }
    return _integralInfo;
  }

  List<IntegralHistoryModel> get integralHistories {
    if (_integralHistories == null) {
      getData();
    }
    return _integralHistories;
  }

  @override
  void getData() {
    IntegralRepository.getIntegraHistory({
      'page': 0,
      'size': pageSize,
    }).then((response) {
      if (response != null) {
        _integralHistories = response.content;
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
  void loadMore() async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        await IntegralRepository.getIntegraHistory({
          'page': ++currentPage,
          'size': pageSize,
        }).then((response) {
          if (response != null) {
            _integralHistories.addAll(response.content);
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
    _integralHistories = null;
    _integralInfo = null;
    reset();
    notifyListeners();
  }

  ///获取用户积分信息
  void getIntegralInfo() async {
    IntegralRepository.getIntegralInfo().then((value) {
      if (value != null) {
        _integralInfo = value;

        ///通知刷新
        notifyListeners();
      }
    });
  }
}

///用户积分记录状态管理
class UserIntegralExchangeHistoryState extends PageState {
  List<IntegralExchangeHistoryModel> _exchageHistories;

  List<IntegralExchangeHistoryModel> get integralHistories {
    if (_exchageHistories == null) {
      getData();
    }
    return _exchageHistories;
  }

  @override
  void getData() {
    IntegralRepository.getIntegraExchangeHistory({
      'page': 0,
      'size': pageSize,
    }).then((response) {
      if (response != null) {
        _exchageHistories = response.content;
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
  void loadMore() async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        await IntegralRepository.getIntegraExchangeHistory({
          'page': ++currentPage,
          'size': pageSize,
        }).then((response) {
          if (response != null) {
            _exchageHistories.addAll(response.content);
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
    _exchageHistories = null;
    reset();
    notifyListeners();
  }
}
