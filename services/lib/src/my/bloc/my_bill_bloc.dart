import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class MyBillBLoC extends BLoCBase {
  // 工厂模式
  factory MyBillBLoC() => _getInstance();

  static MyBillBLoC get instance => _getInstance();
  static MyBillBLoC _instance;

  MyBillBLoC._internal() {
    // 初始化
  }

  static MyBillBLoC _getInstance() {
    if (_instance == null) {
      _instance = new MyBillBLoC._internal();
    }
    return _instance;
  }

  List<BillModel> _bills = [];

  List<BillModel> get factories => _bills;

  var _controller = StreamController<List<BillModel>>.broadcast();

  Stream<List<BillModel>> get stream => _controller.stream;

  var conditionController = StreamController<DateTime>.broadcast();

  Stream<DateTime> get conditionStream => conditionController.stream;

  filterByDate({DateTime date}) async {
    _bills.clear();
    //若没有数据则查询
    if (_bills.isEmpty) {
      // TODO: 分页拿数据，response.data;
      _bills = (await Future.delayed(const Duration(seconds: 1), () {
        List<BillModel> list = [];
        for (int i = 10; i >= 0; i--) {
          BillModel model = BillModel.fromJson(mockBill);
          model.type = BillType.PAYMENT;
          model.date = date;
          model.balance = model.balance + 100000;
          list.add(model);
        }
        return list;
      }));
    }
    _controller.sink.add(_bills);
  }

  loadingMoreByDate({DateTime date}) async {
    //模拟数据到底
    if (_bills.length < 15) {
      _bills.add(await Future.delayed(const Duration(seconds: 1), () {
        BillModel model = BillModel.fromJson(mockBill);
        model.type = BillType.RECEIVABLES;
        model.date = date;
        model.balance = model.balance + 100000;
        return model;
      }));
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(_bills);
  }

  clear() async {
    //清空
    _bills.clear();
    _controller.sink.add(null);
  }

  //下拉刷新
  Future refreshData({DateTime date}) async {
    _bills.clear();
    _bills = (await Future.delayed(const Duration(seconds: 1), () {
      List<BillModel> list = [];
      for (int i = 10; i >= 0; i--) {
        BillModel model = BillModel.fromJson(mockBill);
        model.type = BillType.WITHDRAWAL;
        model.date = date;
        model.order=null;
        model.balance = model.balance + 100000;
        list.add(model);
      }
      return list;
    }));

    _controller.sink.add(_bills);
  }

  //页面控制

  var _loadingController = StreamController<bool>.broadcast();
  var _bottomController = StreamController<bool>.broadcast();
  var _toTopBtnController = StreamController<bool>.broadcast();
  var _returnToTopController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<bool> get bottomStream => _bottomController.stream;

  Stream<bool> get toTopBtnStream => _toTopBtnController.stream;

  Stream<bool> get returnToTopStream => _returnToTopController.stream;

  loadingStart() async {
    _loadingController.sink.add(true);
  }

  loadingEnd() async {
    _loadingController.sink.add(false);
  }

  showToTopBtn() async {
    _toTopBtnController.sink.add(true);
  }

  hideToTopBtn() async {
    _toTopBtnController.sink.add(false);
  }

  returnToTop() async {
    _returnToTopController.sink.add(true);
  }

  dispose() {
    _controller.close();
  }

  ///TODO：mock数据待删除
  Map<String, dynamic> mockBill = {
    'amount': 12392.00,
    'balance': 200.00,
    'order': {'code': 'ABCD123456'},
    'bankAccount': '89080***********28',
  };
}
