import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';

import '../../../services.dart';

///品牌状态管理
class MyBrandState with ChangeNotifier{
  final String brandUid;
  MyBrandState({this.brandUid});

  BrandModel _model;

  BrandModel get model {
    if(_model == null){
      this._getBrandData();
    }
    return _model;
  }

  //获取品牌数据
  _getBrandData() async {
    _model =  await UserRepositoryImpl().getBrand(brandUid);
    notifyListeners();
  }

  set model(BrandModel value) {
    _model = value;
  }

  //刷新model
  refresh(){
    print('refresh----------------');
    _model = null;
    notifyListeners();
  }
}
