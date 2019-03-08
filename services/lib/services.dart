library app_services;

export 'src/api/apis.dart';
export 'src/api/order.dart';
export 'src/api/product.dart';
export 'src/api/user.dart';
export 'src/home/factory/bloc/quick_reaction_factory_bloc.dart';
export 'src/home/product/bloc/order_product_bloc.dart';
export 'src/my/bloc/my_bill_bloc.dart';
export 'src/net/http_manager.dart';
export 'src/order/bloc/proofing_orders_bloc.dart';
export 'src/order/bloc/purchase_order_bloc.dart';
export 'src/order/bloc/quote_orders_bloc.dart';
export 'src/order/bloc/requirement_order_bloc.dart';
export 'src/order/bloc/requirement_quote_detail_bloc.dart';
export 'src/order/bloc/sales_order_bloc.dart';
export 'src/product/bloc/apparel_product_bloc.dart';
export 'src/production/bloc/production_bloc.dart';
export 'src/production/bloc/production_search_result_bloc.dart';
export 'src/supplier/bloc/suppliers_bloc.dart';
export 'src/supplier/bloc/suppliers_bloc.dart';
export 'src/system/notification/message_file_storage.dart';
export 'src/system/notification/message_repository.dart';
export 'src/system/notification/message_repository_impl.dart';
export 'src/system/notification/message_web_client.dart';
export 'src/user/bloc/login.dart';
export 'src/user/bloc/user_bloc.dart';
export 'src/user/city_repository.dart';
export 'src/user/city_repository_impl.dart';
export 'src/user/district_repository.dart';
export 'src/user/district_repository_impl.dart';
export 'src/user/region_repository.dart';
export 'src/user/region_repository_impl.dart';
export 'src/user/user_repository.dart';
export 'src/user/user_repository_impl.dart';
export 'src/wechat/wechat_service_impl.dart';
export 'src/order/order_repository_impl.dart';

abstract class BLoCBase {
  void dispose();
}
