import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';

import '../../../services.dart';

///品类状态管理
class MyFactoryState with ChangeNotifier{
  final String factoryUid;
  MyFactoryState({this.factoryUid});

  FactoryModel _model;

  FactoryModel get model {
    if(_model == null){
      this._getFactoryData();
    }
    return _model;
  }

  //获取工厂数据
  _getFactoryData() async {
    _model =  await UserRepositoryImpl().getFactory(factoryUid);
    notifyListeners();
  }

  set model(FactoryModel value) {
    _model = value;
  }

  //刷新model
  refresh(){
    _model = null;
    notifyListeners();
  }
}
