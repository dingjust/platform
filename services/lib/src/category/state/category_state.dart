import 'package:dio/dio.dart';
import 'package:models/models.dart';

import '../../../services.dart';

///品类状态管理
class CategoryState {
  List<CategoryModel> _cascadedCategories;

  Future<List<CategoryModel>> getCascadedCategories() async {
    if (_cascadedCategories == null) {
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
    } else {
      return _cascadedCategories;
    }
  }
}
