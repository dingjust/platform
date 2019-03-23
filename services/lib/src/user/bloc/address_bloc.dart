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
    if(!lock){
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
//    _loadingController.sink.add(false);
//    _controller.sink.add(addresses);
  }

  //下拉刷新
//  Future refreshData() async {
//    addressResponse = await ProductRepositoryImpl().list({},{});
//    _controller.sink.add(addressResponse.content);
//  }

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
    _detailController.close();
    _loadingController.close();
    _bottomController.close();
    _toTopBtnController.close();
    _returnToTopController.close();
  }
}
