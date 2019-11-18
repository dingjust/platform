import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';

import '../../../services.dart';

///品类状态管理
class MyFactoryCapacityState with ChangeNotifier{
  int _capacityIndex = 0;

  int get capacityIndex => _capacityIndex;

  set capacityIndex(int value) {
    _capacityIndex = value;
    notifyListeners();
  }

}
