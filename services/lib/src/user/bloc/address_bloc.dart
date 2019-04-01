import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class AddressBLoC extends BLoCBase {
  List<AddressModel> addresses;
  AddressModel currentProduct;

  AddressModel newProduct;

  // 工厂模式
  factory AddressBLoC() => _getInstance();

  static AddressBLoC get instance => _getInstance();
  static AddressBLoC _instance;
  bool lock = false;

  AddressBLoC._internal() {
    // 初始化
    addresses = List<AddressModel>();
//    currentProduct = AddressModel();

//    newProduct = AddressModel();
  }

  static AddressBLoC _getInstance() {
    if (_instance == null) {
      _instance = AddressBLoC._internal();
    }
    return _instance;
  }

  //TODO 清空表单数据
  void clearNewProduct() {}

  var _controller = StreamController<List<AddressModel>>.broadcast();

  var _detailController = StreamController<AddressModel>();

  Stream<List<AddressModel>> get stream => _controller.stream;

  Stream<AddressModel> get detailStream => _detailController.stream;

  filterByStatuses() async {
    if (!lock) {
      lock = true;
      addresses.clear();
      addresses = await AddressRepositoryImpl().list();
      _controller.sink.add(addresses);
      lock = false;
    }
  }

  loadingMoreByStatuses() async {
//    if(addressResponse.number < addressResponse.totalPages-1){
//      addressResponse = await AddressRepositoryImpl().list();
//      addresses.addAll(addressResponse.content);
//    }else{
//      _bottomController.sink.add(true);
//    }
//
//    loadingController.sink.add(false);
//    _controller.sink.add(addresses);
  }

  //下拉刷新
//  Future refreshData() async {
//    addressResponse = await ProductRepositoryImpl().list({},{});
//    _controller.sink.add(addressResponse.content);
//  }

  dispose() {
    _controller.close();
    _detailController.close();

    super.dispose();
  }
}
