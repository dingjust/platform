import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/response/b2b_customer_response.dart';

class EmployeeBLoC extends BLoCBase {
  List<B2BCustomerModel> b2bCustomers;
  B2BCustomerModel currentB2BCustomer;
  B2BCustomerResponse b2bCustomerResponse;

  // 工厂模式
  factory EmployeeBLoC() => _getInstance();

  static EmployeeBLoC get instance => _getInstance();
  static EmployeeBLoC _instance;
  bool lock = false;

  EmployeeBLoC._internal() {
    // 初始化
    b2bCustomers = List<B2BCustomerModel>();
  }

  static EmployeeBLoC _getInstance() {
    if (_instance == null) {
      _instance = EmployeeBLoC._internal();
    }
    return _instance;
  }

  //TODO 清空表单数据
  void clearNewProduct() {}

  var _controller = StreamController<List<B2BCustomerModel>>.broadcast();

  var _detailController = StreamController<B2BCustomerModel>();

  Stream<List<B2BCustomerModel>> get stream => _controller.stream;

  Stream<B2BCustomerModel> get detailStream => _detailController.stream;

  getB2BCustomerData(String keyword) async {
    if (!lock) {
      lock = true;
      b2bCustomers.clear();
      Map data = {};
      if(keyword != null){
        data['keyword'] = keyword;
      }
      b2bCustomerResponse = await UserRepositoryImpl().employees({
        //param
      }, data);
      if (b2bCustomerResponse != null) {
        b2bCustomers = b2bCustomerResponse.content;
      }
      _controller.sink.add(b2bCustomers);
      lock = false;
    }
  }

  loadingMoreByStatuses(String keyword) async {
    if (!lock) {
      lock = true;
      Map data = {};
      if(keyword != null){
        data['keyword'] = keyword;
      }
      if (b2bCustomerResponse.number < b2bCustomerResponse.totalPages - 1) {
        b2bCustomerResponse = await UserRepositoryImpl().employees({
          //param
          'page': b2bCustomerResponse.number + 1,
        }, data);
        if (b2bCustomerResponse != null) {
          b2bCustomers.addAll(b2bCustomerResponse.content);
        }
      } else {
        bottomController.sink.add(true);
      }

      loadingController.sink.add(false);
      _controller.sink.add(b2bCustomers);
      lock = false;
    }
  }

  //下拉刷新
//  Future refreshData() async {
//    addressResponse = await ProductRepositoryImpl().list({},{});
//    _controller.sink.add(addressResponse.content);
//  }

  void reset() {
    b2bCustomers.clear();
  }

  clear() {
    _controller.sink.add(null);
  }

  dispose() {
    _controller.close();
    _detailController.close();

    super.dispose();
  }
}
