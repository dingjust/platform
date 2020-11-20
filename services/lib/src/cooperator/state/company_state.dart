import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/state/state.dart';

class CompanyState extends PageState {
  PageEntry _page = PageEntry(
      currentPage: 0, size: 10, data: List<CompanyModel>(), totalElements: -1);

  String _keyword = '';

  String get getKeyword => _keyword;

  void setKeyword(String keywords) {
    _keyword = keywords;
    // 清空数据
    this.clear();
  }

  PageEntry getEntry() {
    if (_page.totalElements < 0) {
      getData();
    }
    return _page;
  }

  List<CompanyModel> companies() {
    if (_page.totalElements < 0) {
      getData();
    }
    return _page.data;
  }

  @override
  clear() {
    _page.currentPage = 0;
    _page.size = 10;
    _page.data = List<CompanyModel>();
    _page.totalElements = -1;

    notifyListeners();
  }

  @override
  getData() async {
    if (_page.totalElements < 0) {
      Response<Map<String, dynamic>> response;

      try {
        response = await http$.post(UserApis.companies, data: {
          'keyword': _keyword,
        }, queryParameters: {
          'page': _page.currentPage,
          'size': _page.size
        });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        CompanyResponse companyResponse =
            CompanyResponse.fromJson(response.data);
        _page.totalElements = companyResponse.totalElements;
        _page.totalPages = companyResponse.totalPages;
        _page.data.clear();
        _page.data.addAll(companyResponse.content);

        /// 通知刷新
        notifyListeners();
      }
    }
  }

  @override
  loadMore() async {
    if (!lock) {
      // 异步调用开始，通知加载组件
      workingStart();
      // 接口调用
      if (_page.currentPage + 1 != _page.totalPages) {
        Response<Map<String, dynamic>> response;

        try {
          response = await http$.post(UserApis.companies, data: {
            'keyword': _keyword,
          }, queryParameters: {
            'page': ++_page.currentPage,
            'size': _page.size
          });
        } on DioError catch (e) {
          print(e);
        }

        if (response.statusCode == 200) {
          CompanyResponse companyResponse =
              CompanyResponse.fromJson(response.data);
          _page.totalElements = companyResponse.totalElements;
          _page.totalPages = companyResponse.totalPages;
          _page.data.addAll(companyResponse.content);
        }
      }

      // 异步调用结束，通知加载组件
      workingEnd();
    }
  }
}
