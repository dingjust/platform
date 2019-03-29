import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/home/factory/response/factory_response.dart';
import 'package:services/src/supplier/brands_response.dart';

class SuppliersBloc {
  SuppliersBloc();
  FactoriesResponse factoriesResponse;
  BrandsResponse brandsResponse;

  List<FactoryModel> _factories = new List();
  List<BrandModel> _brands = new List();

  var _factoryController = StreamController<List<FactoryModel>>.broadcast();
  var _brandController = StreamController<List<BrandModel>>.broadcast();

  Stream<List<FactoryModel>> get factoryStream => _factoryController.stream;
  Stream<List<BrandModel>> get brandStream => _brandController.stream;

  filterfactories() async {
    factoriesResponse = await UserRepositoryImpl().factorySuppliers({});
    _factories.clear();
    _factories.addAll(factoriesResponse.content);
    _factoryController.sink.add(_factories);
  }

  filterbrands() async {
    brandsResponse = await UserRepositoryImpl().brandSuppliers({});
    _brands.clear();
    _brands.addAll(brandsResponse.content);
    _brandController.sink.add(_brands);
  }

  loadingMoreByFactories() async {
    //模拟数据到底
    if (factoriesResponse.number < factoriesResponse.totalPages - 1) {
      Response response = await http$.get(Apis.factorySuppliers, data:{
        'page':factoriesResponse.number + 1,
      }, );
      factoriesResponse = FactoriesResponse.fromJson(response.data);
      _factories.addAll(factoriesResponse.content);
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _factoryController.sink.add(this._factories);
  }

  loadingMoreByBrands() async {
    //模拟数据到底
    if (brandsResponse.number < brandsResponse.totalPages - 1) {
      Response response = await http$.get(Apis.brandsSuppliers, data:{
        'page':brandsResponse.number + 1,
      },);
      brandsResponse = BrandsResponse.fromJson(response.data);
      _brands.addAll(brandsResponse.content);
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _brandController.sink.add(this._brands);
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
    _factoryController.close();
    _brandController.close();
  }
}
