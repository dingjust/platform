import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:flutter/material.dart';

///首页板块状态管理
class HomeSectionState with ChangeNotifier {
  ///报价中的需求
  int requirementOrder;

  ///报价单
  int quoteOrder;

  Future<int> getRequirementOrderNum() async {
    Response response;
    try {
      response = await http$.post(OrderApis.requirementOrdersAll,
          data: {'statuses': 'PENDING_QUOTE'},
          queryParameters: {'page': 0, 'size': 1});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      requirementOrder = response.data['totalElements'] as int;
      return requirementOrder;
    } else {
      return 0;
    }
  }

  Future<bool> getData() async {
    requirementOrder = await getRequirementOrderNum();
    notifyListeners();
  }
}
