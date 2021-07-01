import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:services/src/product/repository/sample_product_repository.dart';
import 'package:services/src/state/state.dart';

///款式状态管理
class SampleProductsState extends PageState {
  final List<SampleProductModel> selectedData;

  final ValueChanged<SampleProductModel> onItemTap;

  List<SampleProductModel> _data;

  SampleProductsState({this.selectedData, this.onItemTap});

  String _keyword = '';

  String get getKeyword => _keyword;

  void setKeyword(String keywords) {
    _keyword = keywords;
    //清空数据
    this.clear();
  }

  List<SampleProductModel> get data {
    if (_data == null) {
      getData();
    }
    return _data;
  }

  @override
  void getData() {
    Map params = {'keyword': _keyword};
    SampleProductRepository.list(params, {
      'page': 0,
      'size': pageSize,
    }).then((response) {
      if (response != null) {
        _data = response.content;
        pageSize = response.size;
        currentPage = response.number;
        totalPages = response.totalPages;
        totalElements = response.totalElements;

        ///通知刷新
        notifyListeners();
      }
    });
  }

  @override
  void loadMore() async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      Map params = {'keyword': _keyword};
      //接口调用：
      if (currentPage + 1 != totalPages) {
        await SampleProductRepository.list(params, {
          'page': ++currentPage,
          'size': pageSize,
        }).then((response) {
          if (response != null) {
            _data.addAll(response.content);
            pageSize = response.size;
            currentPage = response.number;
            totalPages = response.totalPages;
            totalElements = response.totalElements;
          }
        });
      }
      //异步调用结束，通知加载组件
      workingEnd();
    }
  }

  @override
  void clear() {
    _data = null;
    reset();
    notifyListeners();
  }
}
