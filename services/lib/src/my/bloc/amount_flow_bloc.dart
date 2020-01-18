import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/response/amount_flow_response.dart';

class AmountFlowBLoC extends BLoCBase {
  // 工厂模式
  factory AmountFlowBLoC() => _getInstance();

  static AmountFlowBLoC get instance => _getInstance();
  static AmountFlowBLoC _instance;

  AmountFlowResponse amountFlowResponse;

  AmountFlowBLoC._internal() {
    // 初始化
    amountFlowResponse = AmountFlowResponse(0, 10, 0, 0, []);
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
//    amountFlows.clear();
    //若没有数据则查询
    if (amountFlowResponse == null || amountFlowResponse.content.isEmpty) {
      // TODO: 分页拿数据，response.data;
      amountFlowResponse = await AmountFlowRepository().list();
      if(amountFlowResponse != null){
        amountFlows.addAll(amountFlowResponse.content);
      }
    }
    _controller.sink.add(amountFlows);
  }

  loadingMore({DateTime date}) async {
    //模拟数据到底
    if (amountFlowResponse.totalPages > amountFlowResponse.number + 1) {
      // TODO: 分页拿数据，response.data;
      amountFlowResponse = await AmountFlowRepository()
          .list(params: {'page': amountFlowResponse.number + 1});
      amountFlows.addAll(amountFlowResponse.content);
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
    //若没有数据则查询
//    if (amountFlowResponse.content.isEmpty) {
    // TODO: 分页拿数据，response.data;
    amountFlowResponse = await AmountFlowRepository().list();
    amountFlows.addAll(amountFlowResponse.content);
//    }
    _controller.sink.add(amountFlows);
  }

  dispose() {
    _controller.close();
    conditionController.close();

    super.dispose();
  }
}
