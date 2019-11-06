import 'package:flutter/material.dart';

///页面状态管理
abstract class PageState with ChangeNotifier {
  int pageSize = 10;
  int currentPage = 0;
  int totalPages = 10;
  int totalElements = 0;
  bool loadingMore = false;
  bool lock = false;

  ///获取数据
  getData();

  ///加载更多数据
  loadMore();
}
