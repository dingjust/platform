import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';

///工作台数据状态
class BusinessReportState with ChangeNotifier {
  ///报价中的需求
  int requirementCount;

  ///报价单
  int quoteCount;

  int orderCount;

  int agreementCount;

  int pendingPayCount;

  int productionCount;

  DateTime updateTime;

  void getData() async {
    Response response;
    try {
      response = await http$.get(OrderApis.businessReport);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.code == 1) {
        var data = baseResponse.data;
        this
          ..requirementCount = data['requirementCount']
          ..quoteCount = data['quoteCount']
          ..orderCount = data['orderCount']
          ..agreementCount = data['agreementCount']
          ..pendingPayCount = data['pendingPayCount']
          ..productionCount = data['productionCount'];
        //更新数据获取时间
        updateTime = DateTime.now();
        notifyListeners();
      }
    }
  }
}
