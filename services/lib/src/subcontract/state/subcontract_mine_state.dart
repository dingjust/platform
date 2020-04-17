import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/state/state.dart';
import 'package:services/src/subcontract/repository/subcontract_repository_impl.dart';

///工厂产能状态管理
class SubContractMineState extends PageState {
  Map<String, PageEntry> _subContractsMap = {
    '0': PageEntry(currentPage: 0, size: 10, data: null),
    '1': PageEntry(currentPage: 0, size: 10, data: null),
    '2': PageEntry(currentPage: 0, size: 10, data: null),
  };
  List<SubContractModel> _subcontractModels;
  String _keyword;
  String _key;
  bool _showTopBtn = false;
  Map<String, dynamic> _queryFromData = {};

  bool get showTopBtn => _showTopBtn;

  set showTopBtn(bool value) {
    _showTopBtn = value;
    notifyListeners();
  }

  @override
  void getData() async {
    isDownEnd = false;
    var response = await SubContractRepositoryImpl()
        .getSubcontracts(data: _queryFromData, params: {
      'page': currentPage,
      'size': pageSize,
    });

    if (response != null) {
      _subcontractModels = response.content;
      pageSize = response.size;
      currentPage = response.number;
      totalPages = response.totalPages;
      totalElements = response.totalElements;

      ///通知刷新
      notifyListeners();
    }
  }

  void getMapData() async {
    print(_queryFromData);
    isDownEnd = false;
    var response = await SubContractRepositoryImpl()
        .getSubcontracts(data: _queryFromData, params: {
      'page': _subContractsMap[_key].currentPage,
      'size': _subContractsMap[_key].size,
    });

    if (response != null) {
      _subContractsMap[_key].size = response.size;
      _subContractsMap[_key].currentPage = response.number;
      _subContractsMap[_key].totalPages = response.totalPages;
      _subContractsMap[_key].totalElements = response.totalElements;
      _subContractsMap[_key].data = response.content;

      ///通知刷新
      notifyListeners();
    }
  }

  void loadMoreMapData() async {
    print(_subContractsMap[_key].currentPage);
    print(_subContractsMap[_key].totalPages);
    if (_subContractsMap[_key].data.isNotEmpty) {
      //接口调用：
      if (_subContractsMap[_key].currentPage + 1 !=
          _subContractsMap[_key].totalPages) {
        //异步调用开始，通知加载组件
        workingStart();
        isDownEnd = false;
        var response = await SubContractRepositoryImpl()
            .getSubcontracts(data: _queryFromData, params: {
          'page': _subContractsMap[_key].currentPage + 1,
          'size': _subContractsMap[_key].size,
        });

        if (response != null) {
          _subContractsMap[_key].size = response.size;
          _subContractsMap[_key].currentPage = response.number;
          _subContractsMap[_key].totalPages = response.totalPages;
          _subContractsMap[_key].totalElements = response.totalElements;
          _subContractsMap[_key].data.addAll(response.content);
        }
        //异步调用结束，通知加载组件
        workingEnd();
      } else {
        isDownEnd = true;
      }
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
        var response = await SubContractRepositoryImpl()
            .getSubcontracts(data: _queryFromData, params: {
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
      } else {
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

  void clearMapData() {
    _subContractsMap[_key] = PageEntry(currentPage: 0, size: 10, data: null);
    notifyListeners();
  }

  List<SubContractModel> get subcontractModels {
    if (_subcontractModels == null) {
      getData();
    }
    return _subcontractModels;
  }

  List<SubContractModel> get subcontractModelsByMap {
    if (_key == null) {
      _key = '0';
    }
    if (_subContractsMap[_key].data == null) {
      getMapData();
    }
    return _subContractsMap[_key].data;
  }

  String get key => _key;

  set key(String value) {
    _key = value;
    switch (_key) {
      case '0':
        _queryFromData['canneled'] = null;
        break;
      case '1':
        _queryFromData['canneled'] = false;
        break;
      case '2':
        _queryFromData['canneled'] = true;
        break;
    }
  }

  String get keyword {
    if (_keyword == null) {
      _keyword = '';
    }
    return _keyword;
  }

  set keyword(String value) {
    _keyword = value;
    _queryFromData['keyword'] = _keyword;
    notifyListeners();
    clear();
  }
}
