import 'package:flutter/material.dart';

///页面状态管理
abstract class PageState with ChangeNotifier {
  int pageSize = 10;
  int currentPage = 0;
  int totalPages = 10;
  int totalElements = 0;
  bool loadingMore = false;
  bool lock = false;
  bool _isDownEnd = false;

  bool get isDownEnd => _isDownEnd;

  set isDownEnd(bool value) {
    _isDownEnd = value;
  }

  ///获取数据
  getData();

  ///加载更多数据
  loadMore();

  ///数据到底
  bool isEnd() {
    return currentPage + 1 == totalPages;
  }

  ///刷新
  clear();

  void workingStart() {
    lock = true;
    loadingMore = true;
    notifyListeners();
  }

  void workingEnd() {
    loadingMore = false;
    lock = false;
    notifyListeners();
  }

  ///数据重置
  void reset() {
    pageSize = 10;
    currentPage = 0;
    totalPages = 10;
    totalElements = 0;
    loadingMore = false;
    lock = false;
  }
}
