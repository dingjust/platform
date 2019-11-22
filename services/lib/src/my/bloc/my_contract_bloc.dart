import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/my/response/my_response.dart';
import 'package:services/src/order/PageEntry.dart';

class MyContractBLoC extends BLoCBase {
  // 工厂模式
  factory MyContractBLoC() => _getInstance();

  static MyContractBLoC get instance => _getInstance();
  static MyContractBLoC _instance;

  bool lock = false;

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
    'SEARCH':
    PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
  };

  var _controller = StreamController <ContractData>.broadcast();

  MyContractBLoC._internal() {}

  static MyContractBLoC _getInstance() {
    if (_instance == null) {
      _instance = MyContractBLoC._internal();
    }
    return _instance;
  }

  bool isShowNotRead = true;

  setReadStatus (bool isNotRead) => isShowNotRead = isNotRead;

  Stream<ContractData> get stream => _controller.stream;

  getData({String status,String keyword}) async {
    print(status);
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
    if(_dataMap[status].data == null || _dataMap[status].data.length == 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {
        'state': _status == null || _status == '' || _status == 'ALL'  ? '' : _status,
        'signState': signState,
      };

      Response<Map<String, dynamic>> response;

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
        ContractResponse contractResponse =
        ContractResponse.fromJson(response.data);
        _dataMap[status].totalPages = contractResponse.totalPages;
        _dataMap[status].totalElements = contractResponse.totalElements;
        _dataMap[status].data.clear();
        _dataMap[status].data.addAll(contractResponse.content);
      }
    }
    _controller.sink.add(ContractData(status: status, data: _dataMap[status].data));

  }
  getDataByKeywrod({String status,String keyword}) async {
    //若没有数据则查询
    if(_dataMap['SEARCH'].data == null || _dataMap['SEARCH'].data.length == 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {
        'code': keyword
      };

      Response<Map<String, dynamic>> response;

      try {
          response = await http$
              .post(UserApis.contractList, data: data, queryParameters: {
            'page': _dataMap['SEARCH'].currentPage,
            'size': _dataMap['SEARCH'].size,
          });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        ContractResponse contractResponse =
        ContractResponse.fromJson(response.data);
        _dataMap['SEARCH'].totalPages = contractResponse.totalPages;
        _dataMap['SEARCH'].totalElements = contractResponse.totalElements;
        _dataMap['SEARCH'].data.clear();
        _dataMap['SEARCH'].data.addAll(contractResponse.content);
      }
    }
    _controller.sink.add(ContractData(status: 'SEARCH', data: _dataMap['SEARCH'].data));

  }

  loadingMore({String status,String keyword}) async {
    //数据到底
    if (_dataMap[status].currentPage + 1 == _dataMap[status].totalPages) {
      //通知显示已经到底部
//      loadingEnd();
      bottomController.sink.add(true);
    } else {
      String _status = '';
      String signState = '';
      if(status == 'WAIT_ME_SIGN' || status == 'WAIT_HIM_SIGN'){
//        _status = 'SIGN';
        _status = '';
      }else{
        _status = status;
      }
      if(status == 'WAIT_ME_SIGN'){
        signState = '1';
      }else if(status == 'WAIT_HIM_SIGN'){
        signState = '0';
      }

      //请求参数
      Map data = {
        'state': _status == null || _status == '' || _status == 'ALL' ? '' : _status,
        'signState': signState,
      };
      Response<Map<String, dynamic>> response;
      try {
        response = await http$
            .post(UserApis.contractList, data: data, queryParameters: {
          'page': ++_dataMap[status].currentPage,
          'size': _dataMap[status].size,
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response.statusCode == 200) {
        ContractResponse ordersResponse =
        ContractResponse.fromJson(response.data);
        _dataMap[status].totalPages = ordersResponse.totalPages;
        _dataMap[status].totalElements = ordersResponse.totalElements;
        _dataMap[status].data.addAll(ordersResponse.content);
      }
    }

    loadingController.sink.add(false);
    _controller.sink
        .add(ContractData(status: status, data: _dataMap[status].data));
  }

  loadingMoreByKeyword({String keyword}) async {
    //数据到底
    if (_dataMap['SEARCH'].currentPage + 1 == _dataMap['SEARCH'].totalPages) {
      //通知显示已经到底部
//      loadingEnd();
      bottomController.sink.add(true);
    } else {

      //请求参数
      Map data = {
        'code':keyword
      };
      Response<Map<String, dynamic>> response;
      try {
        response = await http$
            .post(UserApis.contractList, data: data, queryParameters: {
          'page': ++_dataMap['SEARCH'].currentPage,
          'size': _dataMap['SEARCH'].size,
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response.statusCode == 200) {
        ContractResponse ordersResponse =
        ContractResponse.fromJson(response.data);
        _dataMap['SEARCH'].totalPages = ordersResponse.totalPages;
        _dataMap['SEARCH'].totalElements = ordersResponse.totalElements;
        _dataMap['SEARCH'].data.addAll(ordersResponse.content);
      }
    }

    loadingController.sink.add(false);
    _controller.sink
        .add(ContractData(status: 'SEARCH', data: _dataMap['SEARCH'].data));
  }

  refreshData(String status,String keyword) async {
    //重置信息
    _dataMap[status].data.clear();
    _dataMap[status].currentPage = 0;
    await getData(status: status);
  }
  refreshDataByKeyword(String keyword) async {
    //重置信息
    _dataMap['SEARCH'].data.clear();
    _dataMap['SEARCH'].currentPage = 0;
    await getDataByKeywrod(keyword: keyword);
  }
  clearByKeyword() {
    //重置信息
    _dataMap['SEARCH'].data.clear();
    _dataMap['SEARCH'].currentPage = 0;
  }

  clear() {
    //重置信息
    _dataMap.forEach((statu, entry) {
      entry.data.clear();
      entry.currentPage = 0;
    });
  }
}

class ContractData {
  String status;

  List<ContractModel> data;

  ContractData({this.status, this.data});
}
