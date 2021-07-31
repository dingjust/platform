import 'dart:async';

import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/user/response/favorite_response.dart';

///收藏
class FavoriteRepository {
  /// 添加收藏
  static Future<BaseResponse> add(int id) async {
    Response response;
    BaseResponse result;

    try {
      response = await http$.post(UserApis.favorite(id));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BaseResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  /// 移除收藏
  static Future<BaseResponse> del(int id) async {
    Response response;
    BaseResponse result;

    try {
      response = await http$.delete(UserApis.favorite(id));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BaseResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  /// 批量移除收藏
  static Future<BaseResponse> delBatch(List<int> ids) async {
    Response response;
    BaseResponse result;

    try {
      response = await http$.delete(UserApis.favoriteBatchDel, data: ids);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BaseResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  /// 收藏列表
  static Future<FavoriteResponse> search(dynamic params, dynamic data) async {
    Response response;
    FavoriteResponse result;

    try {
      response = await http$.post(UserApis.favoriteSearch,
          queryParameters: params, data: data);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = FavoriteResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }
}
