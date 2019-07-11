import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/my/response/bills_response.dart';

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

  int pageSize = 10;
  int currentPage = 0;
  int totalPages = 0;
  int totalElements = 0;

  //锁
  bool lock = false;

  var _controller = StreamController < List < BillModel

  >

  >

      .

  broadcast();

  Stream<List<BillModel>> get stream => _controller.stream;

  var conditionController = StreamController<DateTime>.broadcast();

  Stream<DateTime> get conditionStream => conditionController.stream;

  filterByDate({DateTime date}) async {
    if (!lock) {
      lock = true;
      //重置参数
      reset();
      _bills.clear();
      Map data = {
        'createdDateFrom':
        DateTime(date.year, date.month).millisecondsSinceEpoch,
        'createdDateTo': DateFormatUtil
            .nextMonth(date)
            .millisecondsSinceEpoch
      };
      Response<Map<String, dynamic>> response;
      try {
        response =
        await http$.post(UserApis.bills, data: data, queryParameters: {
          'page': currentPage,
          'size': pageSize,
        });
      } on DioError catch (e) {
        print(e);
      }
      if (response != null && response.statusCode == 200) {
        BillsResponse billsResponse = BillsResponse.fromJson(response.data);
        totalPages = billsResponse.totalPages;
        totalElements = billsResponse.totalElements;
        _bills.addAll(billsResponse.content);
      }
      _controller.sink.add(_bills);
      lock = false;
    }
  }

  loadingMoreByDate({DateTime date}) async {
    //模拟数据到底
    if (_bills.length < 15) {
      // _bills.add(await Future.delayed(const Duration(seconds: 1), () {
      //   BillModel model = BillModel.fromJson(mockBill);
      //   model.amountFlowType = AmountFlowType.OUTFLOW;
      //   model.creationtime = date;
      //   return model;
      // }));
    } else {
      //通知显示已经到底部
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _controller.sink.add(_bills);
  }

  clear() async {
    //清空
    _bills.clear();
    _controller.sink.add(null);
  }

  void reset() {
    _bills = [];
    currentPage = 0;
    totalPages = 0;
    totalElements = 0;
  }

  //下拉刷新
  Future refreshData({DateTime date}) async {
    _bills.clear();
    // _bills = (await Future.delayed(const Duration(seconds: 1), () {
    //   List<BillModel> list = [];
    //   for (int i = 10; i >= 0; i--) {
    //     BillModel model = BillModel.fromJson(mockBill);
    //     model.amountFlowType = AmountFlowType.OUTFLOW;
    //     model.creationtime = date;
    //     list.add(model);
    //   }
    //   return list;
    // }));

    _controller.sink.add(_bills);
  }

  dispose() {
    _controller.close();
    conditionController.close();

    super.dispose();
  }
}
