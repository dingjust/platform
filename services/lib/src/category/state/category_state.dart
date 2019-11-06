import 'package:dio/dio.dart';
import 'package:models/models.dart';

import '../../../services.dart';

///品类状态管理
class CategoryState {
  List<CategoryModel> _cascadedCategories;

  Future<List<CategoryModel>> get cascadedCategories async {
    if (_cascadedCategories == null) {
      _cascadedCategories = await getCascadedCategories();
    }
    return _cascadedCategories;
  }

  Future<List<CategoryModel>> getCascadedCategories() async {
    Response response;
    try {
      response = await http$.get(ProductApis.cascadedCategories);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data.map<CategoryModel>((category) {
        return CategoryModel.fromJson(category);
      }).toList();
    } else {
      return null;
    }
  }
}
