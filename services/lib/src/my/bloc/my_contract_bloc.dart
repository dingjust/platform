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
    'INITIATE':
    PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
    'INVALID':
    PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
    'COMPLETE':
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

  getData(String status) async {

    //若没有数据则查询
    if(_dataMap != null && _dataMap.length > 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {
        'state': status
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

  getDataByKeyword(String keyword) async {

    //若没有数据则查询
    if(_dataMap != null && _dataMap.length > 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {
        'state': 'ALL',
        'code':keyword
      };

      Response<Map<String, dynamic>> response;

      try {
        response = await http$
            .post(UserApis.contractList, data: data, queryParameters: {
          'page': _dataMap['ALL'].currentPage,
          'size': _dataMap['ALL'].size,
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        ContractResponse contractResponse =
        ContractResponse.fromJson(response.data);
        _dataMap['ALL'].totalPages = contractResponse.totalPages;
        _dataMap['ALL'].totalElements = contractResponse.totalElements;
        _dataMap['ALL'].data.clear();
        _dataMap['ALL'].data.addAll(contractResponse.content);
      }
    }
    _controller.sink.add(ContractData(status: 'ALL', data: _dataMap['ALL'].data));

  }

  loadingMoreByStatuses(String status) async {
    //数据到底
    if (_dataMap[status].currentPage + 1 == _dataMap[status].totalPages) {
      //通知显示已经到底部
      bottomController.sink.add(true);
    } else {
      getData(status);
    }

    loadingController.sink.add(false);
    _controller.sink.add(ContractData(status: status, data: _dataMap[status].data));
  }

  loadingMoreByKeyword(String keyword) async {
    //数据到底
    if (_dataMap['ALL'].currentPage + 1 == _dataMap['ALL'].totalPages) {
      //通知显示已经到底部
      bottomController.sink.add(true);
    } else {
      getDataByKeyword(keyword);
    }

    loadingController.sink.add(false);
    _controller.sink.add(ContractData(status: 'ALL', data: _dataMap['ALL'].data));
  }

  refreshData(String status) async {
    //重置信息
    _dataMap[status].data.clear();
    _dataMap[status].currentPage = 0;
    await getData(status);
  }


}

class ContractData {
  String status;

  List<ContractModel> data;

  ContractData({this.status, this.data});
}
