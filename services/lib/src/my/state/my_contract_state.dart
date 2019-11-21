import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/capacity/repository/capacity_repository.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/product/product_repository.dart';
import 'package:services/src/state/state.dart';

import '../../../services.dart';

///工厂产能状态管理
class MyContractState extends PageState {
  String status;
  MyContractState({this.status});

  List<ContractModel> _contractModels;

  static final Map<String, PageEntry> _dataMap = {
    'ALL':
    PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
    'WAIT_ME_SIGN':
    PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
    'WAIT_HIM_SIGN':
    PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
    'COMPLETE':
    PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
    'INVALID':
    PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
  };
  bool _showTopBtn = false;


  List<ContractModel> get contractModels {
    if (_dataMap[status].data == null || _dataMap[status].data.length == 0) {
      getData();
    }
    return _dataMap[status].data;
  }


  bool get showTopBtn => _showTopBtn;

  set showTopBtn(bool value) {
    _showTopBtn = value;
    notifyListeners();
  }

  @override
  void getData() async {
    String _status = '';
    String signState = '';
    if(status == 'WAIT_ME_SIGN' || status == 'WAIT_HIM_SIGN'){
      _status = 'SIGN';
    }else{
      _status = status;
    }
    if(status == 'WAIT_ME_SIGN'){
      signState = '1';
    }else if(status == 'WAIT_HIM_SIGN'){
      signState = '0';
    }

    //若没有数据则查询
    if(_dataMap != null && _dataMap.length > 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {
        'state': _status == null || _status == '' || _status == 'ALL' ? '' : _status,
        'signState': signState,
      };

      var response;

      try {
        print(data);
          response = await http$
              .post(UserApis.contractList, data: data, queryParameters: {
            'page': _dataMap[status].currentPage,
            'size': _dataMap[status].size,
          });
      } on DioError catch (e) {
        print(e);
      }

      print(response.data);

      if (response != null && response.statusCode == 200) {
        _dataMap[status].size = response.data.size;
        _dataMap[status].currentPage = response.data.number;
        _dataMap[status].totalPages = response.data.totalPages;
        _dataMap[status].totalElements = response.data.totalElements;
        _dataMap[status].data.addAll(response.data.content);
      }
    }

    ///通知刷新
    notifyListeners();
  }

  @override
  void loadMore() async {

    if(!lock){
      workingStart();
      if (currentPage + 1 != totalPages) {
        String _status = '';
        String signState = '';
        if(status == 'WAIT_ME_SIGN' || status == 'WAIT_HIM_SIGN'){
          _status = 'SIGN';
        }else{
          _status = status;
        }
        if(status == 'WAIT_ME_SIGN'){
          signState = '1';
        }else if(status == 'WAIT_HIM_SIGN'){
          signState = '0';
        }

        //若没有数据则查询
        if(_dataMap != null && _dataMap.length > 0) {
          //  分页拿数据，response.data;
          //请求参数
          Map data = {
            'state': _status == null || _status == '' || _status == 'ALL' ? '' : _status,
            'signState': signState,
          };

          var response;

          try {
            response = await http$
                .post(UserApis.contractList, data: data, queryParameters: {
              'page': _dataMap[status].currentPage,
              'size': _dataMap[status].size,
            });
          } on DioError catch (e) {
            print(e);
          }

          if (response != null && response.statusCode == 200) {
            _dataMap[status].size = response.size;
            _dataMap[status].totalPages = response.totalPages;
            _dataMap[status].totalElements = response.totalElements;
            _dataMap[status].data.addAll(response.content);
          }
        }
      }
      workingEnd();
    }

    ///通知刷新
    notifyListeners();
  }

  @override
  void clear({String status,String keyword}) {
    if(status != null){
      _dataMap[status].currentPage = 0;
      _dataMap[status].totalElements = 0;
      _dataMap[status].totalPages = 0;
      _dataMap[status].size = 10;
      _dataMap[status].data.clear();
    }else{
      _dataMap.forEach((key,pageEntry){
        _dataMap[key].currentPage = 0;
        _dataMap[status].totalElements = 0;
        _dataMap[status].totalPages = 0;
        _dataMap[status].size = 10;
        _dataMap[key].data.clear();
      });
    }

//    reset();
    notifyListeners();
  }
}
