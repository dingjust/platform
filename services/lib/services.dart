library app_services;

import 'dart:async';

export 'src/amap/amap_response.dart';
export 'src/amap/amap_service.dart';
export 'src/api/apis.dart';
export 'src/api/order.dart';
export 'src/api/product.dart';
export 'src/api/user.dart';
export 'src/bank/bank_response.dart';
export 'src/bank/bank_service.dart';
export 'src/home/factory/bloc/factory_bloc.dart';
export 'src/home/factory/response/factory_condition.dart';
export 'src/home/product/bloc/order_product_bloc.dart';
export 'src/message/jpush_service.dart';
export 'src/message/message_bloc.dart';
export 'src/message/notifications_pool.dart';
export 'src/message/notifications_service.dart';
export 'src/message/notify_bloc.dart';
export 'src/my/bloc/amount_flow_bloc.dart';
export 'src/my/bloc/my_bill_bloc.dart';
export 'src/my/bloc/my_contract_bloc.dart';
export 'src/my/bloc/my_help_bloc.dart';
export 'src/my/repository/bankcard_repository.dart';
export 'src/my/repository/bill_repository.dart';
export 'src/my/repository/user_guideline_repository.dart';
export 'src/my/repository/bankcard_repository.dart';
export 'src/my/repository/wallet_repository.dart';
export 'src/net/http_manager.dart';
export 'src/order/bloc/proofing_orders_bloc.dart';
export 'src/order/bloc/purchase_order_bloc.dart';
export 'src/order/bloc/quote_orders_bloc.dart';
export 'src/order/bloc/requirement_order_bloc.dart';
export 'src/order/bloc/requirement_pool_bloc.dart';
export 'src/order/bloc/requirement_quote_detail_bloc.dart';
export 'src/order/repository/proofing_order_respository.dart';
export 'src/order/repository/purchase_order_repository.dart';
export 'src/order/repository/quote_order_respository.dart';
export 'src/order/repository/requirement_order_repository.dart';
export 'src/order/response/order_response.dart';
export 'src/payment/alipay/alipay_response.dart';
export 'src/payment/alipay/alipay_service_impl.dart';
export 'src/payment/order_payment_service_impl.dart';
export 'src/payment/payment_for.dart';
export 'src/payment/wechat/wechat_service_impl.dart';
export 'src/product/bloc/apparel_product_bloc.dart';
export 'src/product/bloc/apparel_product_search_result_bloc.dart';
export 'src/product/bloc/sample_product_bloc.dart';
export 'src/product/bloc/sample_product_history_bloc.dart';
export 'src/product/product_repository_impl.dart';
export 'src/product/response/product_response.dart';
export 'src/product/response/product_response.dart';
export 'src/product/response/sample_product_historys_response.dart';
export 'src/product/response/sample_products_response.dart';
export 'src/production/bloc/production_bloc.dart';
export 'src/production/bloc/production_search_result_bloc.dart';
export 'src/qq/qq_service.dart';
export 'src/supplier/bloc/suppliers_bloc.dart';
export 'src/supplier/bloc/suppliers_bloc.dart';
export 'src/system/bloc/app_bloc.dart';
export 'src/system/bloc/bloc_bus.dart';
export 'src/system/notification/message_file_storage.dart';
export 'src/system/notification/message_repository.dart';
export 'src/system/notification/message_repository_impl.dart';
export 'src/system/notification/message_web_client.dart';
export 'src/system/version/app_version.dart';
export 'src/user/address_repository.dart';
export 'src/user/address_repository_impl.dart';
export 'src/user/amount_flow_repository.dart';
export 'src/user/bloc/address_bloc.dart';
export 'src/user/bloc/employee_bloc.dart';
export 'src/user/bloc/login.dart';
export 'src/user/bloc/user_bloc.dart';
export 'src/user/city_repository.dart';
export 'src/user/city_repository_impl.dart';
export 'src/user/district_repository.dart';
export 'src/user/district_repository_impl.dart';
export 'src/user/invoice_title_repository_impl.dart';
export 'src/user/region_repository.dart';
export 'src/user/region_repository_impl.dart';
export 'src/user/repository/reports_repository.dart';
export 'src/user/response/address_response.dart';
export 'src/user/user_repository.dart';
export 'src/user/user_repository_impl.dart';
export 'src/websocket/websocket_response.dart';
export 'src/websocket/websocket_service.dart';
export 'src/my/repository/contract_repository.dart';

abstract class BLoCBase {
  var _loadingController = StreamController<bool>.broadcast();
  var _bottomController = StreamController<bool>.broadcast();
  var _toTopBtnController = StreamController<bool>.broadcast();
  var _returnToTopController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<bool> get bottomStream => _bottomController.stream;
  Stream<bool> get toTopBtnStream => _toTopBtnController.stream;
  Stream<bool> get returnToTopStream => _returnToTopController.stream;

  StreamController<bool> get loadingController => _loadingController;
  StreamController<bool> get bottomController => _bottomController;
  StreamController<bool> get toTopBtnController => _toTopBtnController;
  StreamController<bool> get returnToTopController => _returnToTopController;

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

  void dispose() {
    _loadingController.close();
    _bottomController.close();
    _toTopBtnController.close();
    _returnToTopController.close();
  }
}
