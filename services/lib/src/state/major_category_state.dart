import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/net/http_manager.dart';

import '../../services.dart';

///品类状态管理
class MajorCategoryState {
  List<CategoryModel> _majorCategories;

  Future<List<CategoryModel>> getMajorCategories() async {

    if (_majorCategories == null) {
      Response response;
      try {
        response = await http$.get(ProductApis.majorCategories);
      } on DioError catch (e) {
        print(e);
      }
      if (response != null && response.statusCode == 200) {
        _majorCategories = response.data.map<CategoryModel>((category) {
          return CategoryModel.fromJson(category);
        }).toList();
        return _majorCategories;
      } else {
        return null;
      }
    } else {
      return _majorCategories;
    }
  }
}
