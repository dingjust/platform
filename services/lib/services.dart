library app_services;

import 'dart:async';

export 'package:services/src/cooperator/repository/cooperator_repository_impl.dart';

export 'src/amap/amap_response.dart';
export 'src/amap/amap_service.dart';
export 'src/amap/state/amap_state.dart';
export 'src/api/apis.dart';
export 'src/api/capacity.dart';
export 'src/api/order.dart';
export 'src/api/product.dart';
export 'src/api/subcontract.dart';
export 'src/api/user.dart';
export 'src/auth/response/auth_response.dart';
export 'src/auth/respository/auth_respository.dart';
export 'src/bank/bank_response.dart';
export 'src/bank/bank_service.dart';
export 'src/capacity/repository/capacity_repository.dart';
export 'src/capacity/state/capacity_matching_state.dart';
export 'src/capacity/state/my_capacity_state.dart';
export 'src/common/response.dart';
export 'src/cooperator/state/company_state.dart';
export 'src/cooperator/state/cooperatorV2_state.dart';
export 'src/cooperator/state/cooperator_state.dart';
export 'src/home/factory/bloc/factory_bloc.dart';
export 'src/home/factory/response/factory_condition.dart';
export 'src/home/factory/state/factory_tab_section_state.dart';
export 'src/home/product/bloc/order_product_bloc.dart';
export 'src/message/jpush_service.dart';
export 'src/message/message_bloc.dart';
export 'src/message/notifications_pool.dart';
export 'src/message/notifications_service.dart';
export 'src/message/notify_bloc.dart';
export 'src/my/bloc/amount_flow_bloc.dart';
export 'src/my/bloc/my_bill_bloc.dart';
export 'src/my/bloc/my_contract_bloc.dart';
export 'src/my/bloc/my_contract_template_bloc.dart';
export 'src/my/bloc/my_help_bloc.dart';
export 'src/my/repository/bankcard_repository.dart';
export 'src/my/repository/bankcard_repository.dart';
export 'src/my/repository/bill_repository.dart';
export 'src/my/repository/contract_repository.dart';
export 'src/my/repository/user_guideline_repository.dart';
export 'src/my/repository/wallet_repository.dart';
export 'src/my/state/cash_products_state.dart';
export 'src/my/state/cash_products_state.dart';
export 'src/my/state/contract_list_state.dart';
export 'src/my/state/contract_temp_list_state.dart';
export 'src/my/state/my_brand_state.dart';
export 'src/my/state/my_contract_state.dart';
export 'src/my/state/my_factory_capacity_state.dart';
export 'src/my/state/my_factory_state.dart';
export 'src/my/state/pay_plan_state.dart';
export 'src/net/common_response.dart';
export 'src/net/http_manager.dart';
export 'src/net/net_state.dart';
export 'src/order/bloc/proofing_orders_bloc.dart';
export 'src/order/bloc/purchase_order_bloc.dart';
export 'src/order/bloc/quote_my_orders_bloc.dart';
export 'src/order/bloc/quote_orders_bloc.dart';
export 'src/order/bloc/requirement_order_bloc.dart';
export 'src/order/bloc/requirement_pool_bloc.dart';
export 'src/order/bloc/requirement_quote_detail_bloc.dart';
export 'src/order/bloc/sale_orders_bloc.dart';
export 'src/order/purchase/state/purchase_order_list_state.dart';
export 'src/order/repository/order_note_respository.dart';
export 'src/order/repository/progress_order_respository.dart';
export 'src/order/repository/progress_work_sheet_respository.dart';
export 'src/order/repository/proofing_order_respository.dart';
export 'src/order/repository/purchase_order_repository.dart';
export 'src/order/repository/quote_order_respository.dart';
export 'src/order/repository/requirement_order_repository.dart';
export 'src/order/repository/sales_order_respository.dart';
export 'src/order/response/order_response.dart';
export 'src/order/state/delivery_orders_state.dart';
export 'src/order/state/fabric_requirement_state.dart';
export 'src/order/state/production_progress_state.dart';
export 'src/order/state/production_progress_v2_state.dart';
export 'src/order/state/requirement_order_form_state.dart';
export 'src/order/state/requirement_order_select_state.dart';
export 'src/order/state/requirement_tab_section_state.dart';
export 'src/order/state/sale_orders_state.dart';
export 'src/payment/alipay/alipay_response.dart';
export 'src/payment/alipay/alipay_service_impl.dart';
export 'src/payment/order_payment_service_impl.dart';
export 'src/payment/payment_for.dart';
export 'src/payment/wechat/wechat_service_impl.dart';
export 'src/product/bloc/apparel_product_bloc.dart';
export 'src/product/bloc/apparel_product_search_result_bloc.dart';
export 'src/product/bloc/sample_product_bloc.dart';
export 'src/product/bloc/sample_product_history_bloc.dart';
export 'src/product/product_condition.dart';
export 'src/product/repository/product_repository_impl.dart';
export 'src/product/response/product_response.dart';
export 'src/product/response/sample_product_historys_response.dart';
export 'src/product/response/sample_products_response.dart';
export 'src/product/state/plate_product_state.dart';
export 'src/product/state/recommend_product_state.dart';
export 'src/production/bloc/production_bloc.dart';
export 'src/production/bloc/production_search_result_bloc.dart';
export 'src/qq/qq_service.dart';
export 'src/sale_production/repository/external_sale_order_respository.dart';
export 'src/sale_production/repository/out_order_respository.dart';
export 'src/sale_production/repository/production_task_order_respository.dart';
export 'src/sale_production/state/external_sale_orders_state.dart';
export 'src/sale_production/state/out_orders_state.dart';
export 'src/sale_production/state/production_task_orders_state.dart';
export 'src/sale_production/state/progress_work_sheet_state.dart';
export 'src/state/address_state.dart';
export 'src/state/b2b_dept_state.dart';
export 'src/state/b2bcustomers_state.dart';
export 'src/state/carrier_state.dart';
export 'src/state/category_state.dart';
export 'src/state/color_state.dart';
export 'src/state/label_state.dart';
export 'src/state/major_category_state.dart';
export 'src/state/size_state.dart';
export 'src/subcontract/repository/subcontract_repository.dart';
export 'src/subcontract/repository/subcontract_repository_impl.dart';
export 'src/subcontract/response/subcontract_response.dart';
export 'src/subcontract/state/subcontract_form_state.dart';
export 'src/subcontract/state/subcontract_mine_state.dart';
export 'src/subcontract/state/subcontract_pool_state.dart';
export 'src/supplier/bloc/suppliers_bloc.dart';
export 'src/system/bloc/app_bloc.dart';
export 'src/system/bloc/bloc_bus.dart';
export 'src/system/item/item_respository.dart';
export 'src/system/notification/message_file_storage.dart';
export 'src/system/notification/message_repository.dart';
export 'src/system/notification/message_repository_impl.dart';
export 'src/system/notification/message_web_client.dart';
export 'src/system/page/repository/carousels_respository.dart';
export 'src/system/page/state/product_home_carousels_state.dart';
export 'src/system/page/state/product_home_state.dart';
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
export 'src/user/repository/payplan_repository_impl.dart';
export 'src/user/repository/reports_repository.dart';
export 'src/user/response/address_response.dart';
export 'src/user/response/company_payplan_response.dart';
export 'src/user/response/company_response.dart';
export 'src/user/response/cooperator_response.dart';
export 'src/user/user_repository.dart';
export 'src/user/user_repository_impl.dart';
export 'src/websocket/websocket_response.dart';
export 'src/websocket/websocket_service.dart';

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
