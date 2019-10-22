import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/my/response/my_response.dart';
import 'package:services/src/order/PageEntry.dart';

class MyContractTemplateBLoC extends BLoCBase {
  // 工厂模式
  factory MyContractTemplateBLoC() => _getInstance();

  static MyContractTemplateBLoC get instance => _getInstance();
  static MyContractTemplateBLoC _instance;

  bool lock = false;

  static final Map<String, PageEntry> _dataMap = {
    'CGDD':
    PageEntry(currentPage: 0, size: 10, data: List<ContractTemplateModel>()),
    'KJXY':
    PageEntry(currentPage: 0, size: 10, data: List<ContractTemplateModel>()),
    'WTSCHT':
    PageEntry(currentPage: 0, size: 10, data: List<ContractTemplateModel>()),
    'BCXY':
    PageEntry(currentPage: 0, size: 10, data: List<ContractTemplateModel>()),
  };

  var _controller = StreamController <TemplateData>.broadcast();

  MyContractTemplateBLoC._internal() {}

  static MyContractTemplateBLoC _getInstance() {
    if (_instance == null) {
      _instance = MyContractTemplateBLoC._internal();
    }
    return _instance;
  }

  bool isShowNotRead = true;

  setReadStatus (bool isNotRead) => isShowNotRead = isNotRead;

  Stream<TemplateData> get stream => _controller.stream;

  getData(String type) async {

    //若没有数据则查询
    if(_dataMap != null && _dataMap.length > 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {
        'type': type == null || type == '' || type == 'ALL' ? '' : type
      };

      Response<Map<String, dynamic>> response;

      try {
        response = await http$
            .post(UserApis.tempList, data: data, queryParameters: {
          'page': _dataMap[type].currentPage,
          'size': _dataMap[type].size,
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        ContractTempResponse contractTempResponse =
        ContractTempResponse.fromJson(response.data);
        _dataMap[type].totalPages = contractTempResponse.totalPages;
        _dataMap[type].totalElements = contractTempResponse.totalElements;
        _dataMap[type].data.clear();
        _dataMap[type].data.addAll(contractTempResponse.content);
      }
    }
    _controller.sink.add(TemplateData(status: type, data: _dataMap[type].data));

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
    _controller.sink.add(TemplateData(status: 'ALL', data: _dataMap['ALL'].data));

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
    _controller.sink.add(TemplateData(status: status, data: _dataMap[status].data));
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
    _controller.sink.add(TemplateData(status: 'ALL', data: _dataMap['ALL'].data));
  }

  refreshData(String status) async {
    //重置信息
    _dataMap[status].data.clear();
    _dataMap[status].currentPage = 0;
    await getData(status);
  }


}

class TemplateData {
  String status;

  List<ContractTemplateModel> data;

  TemplateData({this.status, this.data});
}
