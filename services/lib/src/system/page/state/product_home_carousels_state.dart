import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/src/system/page/repository/carousels_respository.dart';

///产品首页轮播图状态管理
class ProductHomeCarouselsState with ChangeNotifier {
  List<CarouselModel> _headerCarousels;

  List<CarouselModel> headerCarousels() {
    if (_headerCarousels == null) {
      getHeaderData();
      return [];
    }
    return _headerCarousels;
  }

  List<CarouselModel> _bodyCarousels;

  List<CarouselModel> bodyCarousels() {
    if (_bodyCarousels == null) {
      getBodyData();
      return [];
    }
    return _bodyCarousels;
  }

  ///Banner
  List<CarouselModel> _bannerCarousels;

  List<CarouselModel> get bannerCarousels {
    if (_bannerCarousels == null) {
      getBannerData();
      return null;
    }
    return _bannerCarousels;
  }

  void getHeaderData() async {
    await CarouselsRepository()
        .getCarouselsByType(CarouselType.CT004)
        .then((response) {
      if (response != null) {
        _headerCarousels = response;

        ///通知刷新
        notifyListeners();
      }
    });
  }

  void getBodyData() async {
    await CarouselsRepository()
        .getCarouselsByType(CarouselType.CT005)
        .then((response) {
      if (response != null) {
        _bodyCarousels = response;

        ///通知刷新
        notifyListeners();
      }
    });
  }

  void getBannerData() async {
    await CarouselsRepository()
        .getCarouselsByType(CarouselType.CT003)
        .then((response) {
      if (response != null) {
        _bannerCarousels = response;

        ///通知刷新
        notifyListeners();
      }
    });
  }
}
