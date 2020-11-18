import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:services/src/api/user.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/state/state.dart';
import 'package:services/src/user/response/company_payplan_response.dart';

///账务方案状态管理
class PayPlanState extends PageState {
  final List<CompanyPayPlanModel> selectedData;

  final ValueChanged<CompanyPayPlanModel> onItemTap;

  PayPlanState({this.selectedData, this.onItemTap});

  //** 数据管理*
  List<CompanyPayPlanModel> _payPlans;

  String _keyword = '';

  String get getKeyword => _keyword;

  void setKeyword(String keywords) {
    _keyword = keywords;
    //清空数据
    this.clear();
  }

  List<CompanyPayPlanModel> getPayPlans() {
    if (totalElements < 0) {
      getData();
    }
    return _payPlans;
  }

  @override
  void clear() {
    currentPage = 0;
    pageSize = 10;
    _payPlans = List<CompanyPayPlanModel>();
    totalElements = -1;
    notifyListeners();
  }

  @override
  getData() async {
    //若没有数据则查询
    if (totalElements < 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {
        'keyword': _keyword != '' ? _keyword : null,
      };

      Response<Map<String, dynamic>> response;

      try {
        response =
            await http$.post(UserApis.payplans, data: data, queryParameters: {
          'page': currentPage,
          'size': pageSize,
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        CompanyPayPlanResponse payPlanResponse =
            CompanyPayPlanResponse.fromJson(response.data);
        totalPages = payPlanResponse.totalPages;
        totalElements = payPlanResponse.totalElements;
        _payPlans.clear();
        _payPlans.addAll(payPlanResponse.content);

        ///通知刷新
        notifyListeners();
      }
    }
  }

  @override
  loadMore({String status}) async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        Map data = {
          'keyword': _keyword != '' ? _keyword : null,
        };

        Response<Map<String, dynamic>> response;
        try {
          response =
              await http$.post(UserApis.payplans, data: data, queryParameters: {
            'page': ++currentPage,
            'size': pageSize,
          });
        } on DioError catch (e) {
          print(e);
        }

        if (response.statusCode == 200) {
          CompanyPayPlanResponse payPlanResponse =
              CompanyPayPlanResponse.fromJson(response.data);
          totalPages = payPlanResponse.totalPages;
          totalElements = payPlanResponse.totalElements;
          _payPlans.addAll(payPlanResponse.content);
        }
      }

      //异步调用结束，通知加载组件
      workingEnd();
    }
  }
}
