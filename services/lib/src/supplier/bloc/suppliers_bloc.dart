import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/home/factory/response/factory_response.dart';
import 'package:services/src/supplier/brands_response.dart';

class SuppliersBloc extends BLoCBase {
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
      Response response = await http$.get(
        Apis.factorySuppliers,
        data: {
          'page': factoriesResponse.number + 1,
        },
      );
      factoriesResponse = FactoriesResponse.fromJson(response.data);
      _factories.addAll(factoriesResponse.content);
    } else {
      //通知显示已经到底部
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _factoryController.sink.add(this._factories);
  }

  loadingMoreByBrands() async {
    //模拟数据到底
    if (brandsResponse.number < brandsResponse.totalPages - 1) {
      Response response = await http$.get(
        Apis.brandsSuppliers,
        data: {
          'page': brandsResponse.number + 1,
        },
      );
      brandsResponse = BrandsResponse.fromJson(response.data);
      _brands.addAll(brandsResponse.content);
    } else {
      //通知显示已经到底部
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _brandController.sink.add(this._brands);
  }

  dispose() {
    _factoryController.close();
    _brandController.close();

    super.dispose();
  }
}
