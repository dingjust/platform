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
    'ALL': PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
    '1': PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
    '2': PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
    '3': PageEntry(currentPage: 0, size: 10, data: List<ContractModel>()),
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

    _dataMap[status].data.addAll(await Future.delayed(const Duration(seconds: 1), () {
      return <ContractModel>[
        ContractModel.fromJson({
          'title':'衣加衣采购合同',
          'contractNumber':1245323523,
          'belongTo':'宁波衣加衣供应链管理有限公司',
          'struts':'WAIT_FOR_SIGN',
        }),
        ContractModel.fromJson({
          'title':'衣加衣采购合同',
          'contractNumber':5532535232,
          'belongTo':'宁波衣加衣供应链管理有限公司',
          'struts':'SIGNED',
        }),
        ContractModel.fromJson({
          'title':'衣加衣采购合同',
          'contractNumber':2145112322,
          'belongTo':'宁波衣加衣供应链管理有限公司',
          'struts':'FAILED',
        }),
      ];
    }));

    _controller.sink.add(ContractData(status: status, data: _dataMap[status].data));

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
