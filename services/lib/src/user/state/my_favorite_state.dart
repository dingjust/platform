import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/src/state/state.dart';
import 'package:services/src/user/response/favorite_response.dart';

import '../../../services.dart';

///用户收藏状态(全局)
class MyFavoriteState extends PageState {
  List<MyFavoriteModel> _myFavorites;

  ///收藏ID集合
  List<int> idCollection;

  List<MyFavoriteModel> get myFavorites {
    if (_myFavorites == null) {
      getData();
    }
    return _myFavorites;
  }

  @override
  void getData() {
    FavoriteRepository.search({
      'page': 0,
      'size': 999,
    }, {}).then((response) {
      if (response != null) {
        _myFavorites = response.content;
        pageSize = response.size;
        currentPage = response.number;
        totalPages = response.totalPages;
        totalElements = response.totalElements;
        idCollection = _myFavorites.map((e) => e.item['id'] as int).toList();

        ///通知刷新
        notifyListeners();
      }
    });
  }

  @override
  void clear() {
    _myFavorites = null;
    reset();
    notifyListeners();
  }

  @override
  loadMore() {}

  ///是否已收藏
  bool isFavorite(int id) {
    if (_myFavorites == null) {
      getData();
      return false;
    } else {
      return idCollection?.contains(id);
    }
  }

  ///添加收藏
  void add(int id) async {
    //直接先集合添加
    idCollection.add(id);
    notifyListeners();
    //后续数据提交同步
    BaseResponse baseResponse = await FavoriteRepository.add(id);
    if (baseResponse != null && baseResponse.code == 1) {
      this.clear();
    }
  }

  ///取消收藏
  void del(int id) async {
    //直接先集合添加
    idCollection?.remove(id);
    notifyListeners();
    //后续数据提交同步
    BaseResponse baseResponse = await FavoriteRepository.del(id);
    if (baseResponse != null && baseResponse.code == 1) {
      this.clear();
    }
  }
}

class MyFavoriteTabSectionState with ChangeNotifier {
  ///需求收藏
  List<RequirementOrderModel> _requirementsFavorites;

  ///工厂收藏
  List<FactoryModel> _factoryFavorites;

  ///产品收藏
  List<ApparelProductModel> _productFavorites;

  ///需求收藏
  List<RequirementOrderModel> get requirementsFavorites {
    if (_requirementsFavorites == null) {
      getRequirementFavorites();
    }
    return _requirementsFavorites;
  }

  ///工厂收藏
  List<FactoryModel> get factoryFavorites {
    if (_factoryFavorites == null) {
      getFactoryFavorites();
    }
    return _factoryFavorites;
  }

  ///产品收藏
  List<ApparelProductModel> get productFavorites {
    if (_productFavorites == null) {
      getProductFavorites();
    }
    return _productFavorites;
  }

  ///需求
  void getRequirementFavorites() {
    try {
      http$.post(UserApis.favoriteSearch, data: {
        'typeCode': "RequirementOrder"
      }, queryParameters: {
        'page': 0,
        'size': 999,
      }).then((response) {
        if (response != null && response.statusCode == 200) {
          FavoriteResponse favoriteResponse =
              FavoriteResponse.fromJson(response.data);
          _requirementsFavorites = favoriteResponse.content
              .map((e) =>
                  RequirementOrderModel.fromJson(e.item)..favoriteId = e.id)
              .toList();

          ///通知刷新
          notifyListeners();
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  ///工厂
  void getFactoryFavorites() {
    try {
      http$.post(UserApis.favoriteSearch, data: {
        'typeCode': "Company"
      }, queryParameters: {
        'page': 0,
        'size': 999,
      }).then((response) {
        if (response != null && response.statusCode == 200) {
          FavoriteResponse favoriteResponse =
              FavoriteResponse.fromJson(response.data);
          _factoryFavorites = favoriteResponse.content
              .map((e) => FactoryModel.fromJson(e.item)..favoriteId = e.id)
              .toList();

          ///通知刷新
          notifyListeners();
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  ///产品
  void getProductFavorites() {
    try {
      http$.post(UserApis.favoriteSearch, data: {
        'typeCode': "ApparelProduct"
      }, queryParameters: {
        'page': 0,
        'size': 999,
      }).then((response) {
        if (response != null && response.statusCode == 200) {
          FavoriteResponse favoriteResponse =
              FavoriteResponse.fromJson(response.data);
          _productFavorites = favoriteResponse.content
              .map((e) =>
                  ApparelProductModel.fromJson(e.item)..favoriteId = e.id)
              .toList();

          ///通知刷新
          notifyListeners();
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  void refresh() {
    _requirementsFavorites = null;
    _factoryFavorites = null;
    _productFavorites = null;
    notifyListeners();
  }
}
