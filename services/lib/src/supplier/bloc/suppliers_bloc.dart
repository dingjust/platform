import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/home/factory/response/factory_response.dart';

class SuppliersBloc {
  SuppliersBloc();
  FactoriesResponse factoriesResponse;
  List<FactoryModel> _list = new List();

  var _controller = StreamController<List<FactoryModel>>.broadcast();

  Stream<List<FactoryModel>> get stream => _controller.stream;

  filter() async {
    Response response = await http$.post(Apis.factories, data:{}, queryParameters: {});
    factoriesResponse = FactoriesResponse.fromJson(response.data);
    _list.clear();
    _list.addAll(factoriesResponse.content);
    _controller.sink.add(_list);
  }

  loadingMore() async {
    //模拟数据到底
    if (factoriesResponse.number < factoriesResponse.totalPages - 1) {
      Response response = await http$.post(Apis.factories, data:{}, queryParameters: {
        'page':factoriesResponse.number + 1,
      });
      factoriesResponse = FactoriesResponse.fromJson(response.data);
      _list.addAll(factoriesResponse.content);
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(this._list);
  }

  //页面控制

  var _loadingController = StreamController<bool>.broadcast();

  var _bottomController = StreamController<bool>.broadcast();

  var _toTopBtnController = StreamController<bool>.broadcast();

  var _returnToTopController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<bool> get bottomStream => _bottomController.stream;

  Stream<bool> get toTopBtnStream => _toTopBtnController.stream;

  Stream<bool> get returnToTopStream => _returnToTopController.stream;

  loadingStart() async {
    _loadingController.sink.add(true);
  }

  loadingEnd() async {
    _loadingController.sink.add(false);
  }

  showToTopBtn() async {
    _toTopBtnController.sink.add(true);
  }

  hideToTopBtn() async {
    _toTopBtnController.sink.add(false);
  }

  returnToTop() async {
    _returnToTopController.sink.add(true);
  }

  dispose() {
    _controller.close();
  }
}
