import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class AmountFlowBLoC extends BLoCBase {
  // 工厂模式
  factory AmountFlowBLoC() => _getInstance();

  static AmountFlowBLoC get instance => _getInstance();
  static AmountFlowBLoC _instance;

  AmountFlowBLoC._internal() {
    // 初始化
  }

  static AmountFlowBLoC _getInstance() {
    if (_instance == null) {
      _instance = new AmountFlowBLoC._internal();
    }
    return _instance;
  }

  List<AmountFlowModel> amountFlows = [];

  List<AmountFlowModel> get factories => amountFlows;

  var _controller = StreamController < List < AmountFlowModel

  >

  >

      .

  broadcast();

  Stream<List<AmountFlowModel>> get stream => _controller.stream;

  var conditionController = StreamController < DateTime

  >

      .

  broadcast();

  Stream<DateTime> get conditionStream => conditionController.stream;

  getData({DateTime date}) async {
    amountFlows.clear();
    //若没有数据则查询
    if (amountFlows.isEmpty) {
      // TODO: 分页拿数据，response.data;
      amountFlows = (await Future.delayed(const Duration(seconds: 1), () {
        List<AmountFlowModel> list = [];
        for (int i = 10; i >= 0; i--) {
          AmountFlowModel model = AmountFlowModel.fromJson(mockBill);
          model.amountFlowType = AmountFlowType.INFLOW;
          model.creationtime = date;
          model.amountStatus = AmountStatus.AUDITING;
          model.creationtime = DateTime.now();
          list.add(model);
        }
        return list;
      }));
    }
    _controller.sink.add(amountFlows);
  }

  loadingMore({DateTime date}) async {
    //模拟数据到底
    if (amountFlows.length < 15) {
      amountFlows.add(await Future.delayed(const Duration(seconds: 1), () {
        AmountFlowModel model = AmountFlowModel.fromJson(mockBill);
        model.amountFlowType = AmountFlowType.INFLOW;
        model.creationtime = date;
        model.amountStatus = AmountStatus.AUDITING;
        model.creationtime = DateTime.now();
        return model;
      }));
    } else {
      //通知显示已经到底部
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _controller.sink.add(amountFlows);
  }

  clear() async {
    //清空
    amountFlows.clear();
    _controller.sink.add(null);
  }

  //下拉刷新
  Future refreshData({DateTime date}) async {
    amountFlows.clear();
    amountFlows = (await Future.delayed(const Duration(seconds: 1), () {
      List<AmountFlowModel> list = [];
      for (int i = 10; i >= 0; i--) {
        AmountFlowModel model = AmountFlowModel.fromJson(mockBill);
        model.amountFlowType = AmountFlowType.INFLOW;
        model.creationtime = date;
        model.amountStatus = AmountStatus.AUDITING;
        model.creationtime = DateTime.now();
        list.add(model);
      }
      return list;
    }));

    _controller.sink.add(amountFlows);
  }

  dispose() {
    _controller.close();
    conditionController.close();

    super.dispose();
  }

  ///TODO：mock数据待删除
  Map<String, dynamic> mockBill = {
    'amount': 12392.00,
    'account': '89080***********28',
    'amountStatus': 'AUDITING',
    'flowSource': 'CASH_OUT'
  };
}
