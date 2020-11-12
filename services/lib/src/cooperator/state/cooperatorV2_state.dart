import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:services/src/api/user.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/state/state.dart';
import 'package:services/src/user/response/cooperator_response.dart';

///新合作商状态管理(v2)
class CooperatorV2State extends PageState {
  final List<CooperatorModel> selectedData;

  final ValueChanged<CooperatorModel> onItemTap;

  CooperatorV2State({this.selectedData, this.onItemTap});

  //** 数据管理*/

  Map<String, PageEntry> _cooperatorsMap = {
    'SUPPLIER': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<CooperatorModel>(),
        totalElements: -1),
    'CUSTOMER': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<CooperatorModel>(),
        totalElements: -1),
    'FABRIC_SUPPLIER': PageEntry(
        currentPage: 0,
        size: 10,
        data: List<CooperatorModel>(),
        totalElements: -1),
  };

  String _keyword = '';

  String get getKeyword => _keyword;

  void setKeyword(String keywords) {
    _keyword = keywords;
    //清空数据
    this.clear();
  }

  PageEntry getEntry(String status, {String keyword}) {
    if (_cooperatorsMap[status].totalElements < 0) {
      getData(status: status);
    }
    return _cooperatorsMap[status];
  }

  List<CooperatorModel> cooperators(String status, {String keyword}) {
    if (_cooperatorsMap[status].totalElements < 0) {
      getData(status: status);
    }
    return _cooperatorsMap[status].data;
  }

  @override
  void clear() {
    _cooperatorsMap.forEach((key, entry) {
      entry.currentPage = 0;
      entry.size = 10;
      entry.data = List<CooperatorModel>();
      entry.totalElements = -1;
    });
    notifyListeners();
  }

  @override
  getData({String status}) async {
    //若没有数据则查询
    if (_cooperatorsMap[status].totalElements < 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {
        'keyword': _keyword != '' ? _keyword : null,
      };
      if (status != '' && status != 'SEARCH') {
        data['category'] = status;
      }

      Response<Map<String, dynamic>> response;

      try {
        response = await http$
            .post(UserApis.cooperators, data: data, queryParameters: {
          'page': _cooperatorsMap[status].currentPage,
          'size': _cooperatorsMap[status].size,
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        CooperatorResponse ordersResponse =
            CooperatorResponse.fromJson(response.data);
        _cooperatorsMap[status].totalPages = ordersResponse.totalPages;
        _cooperatorsMap[status].totalElements = ordersResponse.totalElements;
        _cooperatorsMap[status].data.clear();
        _cooperatorsMap[status].data.addAll(ordersResponse.content);

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
      if (_cooperatorsMap[status].currentPage + 1 !=
          _cooperatorsMap[status].totalPages) {
        Map data = {
          'keyword': _keyword != '' ? _keyword : null,
        };
        if (status != 'ALL') {
          data['category'] = status;
        }

        Response<Map<String, dynamic>> response;
        try {
          response = await http$
              .post(UserApis.cooperators, data: data, queryParameters: {
            'page': ++_cooperatorsMap[status].currentPage,
            'size': _cooperatorsMap[status].size,
          });
        } on DioError catch (e) {
          print(e);
        }

        if (response.statusCode == 200) {
          CooperatorResponse ordersResponse =
              CooperatorResponse.fromJson(response.data);
          _cooperatorsMap[status].totalPages = ordersResponse.totalPages;
          _cooperatorsMap[status].totalElements = ordersResponse.totalElements;
          _cooperatorsMap[status].data.addAll(ordersResponse.content);
        }
      }

      //异步调用结束，通知加载组件
      workingEnd();
    }
  }
}
