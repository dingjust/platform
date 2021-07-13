import 'package:b2b_commerce/src/activity/invite/invite_page.dart';
import 'package:b2b_commerce/src/business/apparel_products_brand.dart';
import 'package:b2b_commerce/src/business/cooperator/cooperator_form.dart';
import 'package:b2b_commerce/src/business/cooperator/cooperators_page.dart';
import 'package:b2b_commerce/src/business/orders/delivery/delivery_order_detail_page.dart';
import 'package:b2b_commerce/src/business/orders/delivery/delivery_orders_page.dart';
import 'package:b2b_commerce/src/business/orders/fabric/fabric_requirement_page.dart';
import 'package:b2b_commerce/src/business/orders/fabric/fabric_requirement_publish_form_page.dart';
import 'package:b2b_commerce/src/business/orders/order_coordination.dart';
import 'package:b2b_commerce/src/business/orders/order_import_page.dart';
import 'package:b2b_commerce/src/business/orders/reconciliation/reconciliation_order_detail_page.dart';
import 'package:b2b_commerce/src/business/orders/reconciliation/reconciliation_orders_page.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_orders.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/external_sale_order/external_sale_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/external_sale_order/external_sale_order_import.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/external_sale_order/external_sale_orders_page.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/external_sale_order/form/external_order_form.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/out_order_form.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_order/out_orders_page.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_production_task_order/out_production_task_orders_page.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/production_task_order/production_task_order_entry_detail.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/production_task_order/production_task_orders_page.dart';
import 'package:b2b_commerce/src/business/products/materiel_product_manage.dart';
import 'package:b2b_commerce/src/business/products/materiel_products.dart';
import 'package:b2b_commerce/src/business/products/sample/sample_product_detail.dart';
import 'package:b2b_commerce/src/business/products/sample/sample_products.dart';
import 'package:b2b_commerce/src/business/proofing_orders.dart';
import 'package:b2b_commerce/src/business/quote_my_orders.dart';
import 'package:b2b_commerce/src/business/services/operation_agent_service.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_mine.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_pool.dart';
import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:b2b_commerce/src/helper/autho_login_helper.dart';
import 'package:b2b_commerce/src/home/account/auth_request_page.dart';
import 'package:b2b_commerce/src/home/factory/factory_introduction.dart';
import 'package:b2b_commerce/src/home/factory/finding_factory.dart';
import 'package:b2b_commerce/src/home/factory/publish_center.dart';
import 'package:b2b_commerce/src/home/product/hot_category.dart';
import 'package:b2b_commerce/src/home/product/index.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:b2b_commerce/src/home/requirement/nearby_requirement.dart';
import 'package:b2b_commerce/src/home/search/home_search_result.dart';
import 'package:b2b_commerce/src/home/search/home_serach.dart';
import 'package:b2b_commerce/src/my/account/my_bill.dart';
import 'package:b2b_commerce/src/my/account/register_channel_page.dart';
import 'package:b2b_commerce/src/my/account/register_page.dart';
import 'package:b2b_commerce/src/my/capacity/capacity_matching.dart';
import 'package:b2b_commerce/src/my/card/my_card.dart';
import 'package:b2b_commerce/src/my/integral/integral_center_page.dart';
import 'package:b2b_commerce/src/my/my_capacity.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:b2b_commerce/src/my/my_contract_manage_page.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../b2b_commerce.dart';
import '../business/apparel_products.dart';
import '../business/employees.dart';
import '../business/purchase_orders.dart';
import '../business/quote_orders.dart';
import '../business/requirement_orders.dart';
import '../business/suppliers.dart';
import '../home/account/login.dart';
import '../my/account/register.dart';
import '../my/index.dart';
import '../my/my_account.dart';
import '../my/my_addresses.dart';
import '../my/my_client_services.dart';
import '../my/my_invoices.dart';
import '../my/my_settings.dart';

class AppRoutes with GlobalRoutes {
  static const ROUTE_LOGIN = GlobalRoutes.ROUTE_LOGIN;
  static const ROUTE_REGISTER = '/register';
  static const ROUTE_MY_HOME = GlobalRoutes.ROUTE_MY_HOME;
  static const ROUTE_HOT_CATEGORY_FACTORY = '/home/factory/hot_category';
  static const ROUTE_HOT_CATEGORY_PRODUCT = '/home/product/hot_category';
  static const ROUTE_ORDER_PRODUCTS = '/home/product/order_products';
  static const ROUTE_ORDER_PRODUCTS_INDEX =
      '/home/product/order_products/index';
  static const ROUTE_EMPLOYEES = '/business/employees';
  static const ROUTE_MEMBERSHIPS = '/business/memberships';
  static const ROUTE_MEMBER_REQUESTS = '/business/member_requests';
  static const ROUTE_PRODUCT_STOCKS = '/business/product_stocks';
  static const ROUTE_PRODUCT_STOCK_ADJUST_HISTORY =
      '/business/product_stock_adjust_history';
  static const ROUTE_PRODUCTION_ORDERS = '/business/production_orders';
  static const ROUTE_PRODUCTS = '/business/products';
  static const ROUTE_PRODUCTS_BRAND = '/business/products_brand';
  static const ROUTE_PRODUCTS_OFF_THE_SHELF =
      '/business/products_off_the_shelf';
  static const ROUTE_PURCHASE_ORDERS = '/business/purchase_orders';
  static const ROUTE_SALE_ORDERS = '/business/sale_orders';
  static const ROUTE_QUOTES = '/business/quotes';
  static const ROUTE_MY_QUOTES = '/business/my_quotes';
  static const ROUTE_REQUIREMENT_ORDERS = '/business/requirement_orders';
  static const ROUTE_FABRIC_PUBLISH = '/business/fabric/publish';
  static const ROUTE_FABRIC_REQUIREMENT = '/business/fabric/requirement';
  static const ROUTE_REQUIREMENT_ORDERS_DETAIL =
      '/business/orders/requirement_orders_detail';
  static const ROUTE_REQUIREMENT_QUOTE_DETAIL =
      '/business/orders/requirement_quote_detail';
  static const ROUTE_PROOFING_ORDERS = '/business/proofing_orders';
  static const ROUTE_SALES_ORDERS = '/business/sales_orders';
  static const ROUTE_SUPPLIERS = '/business/suppliers';

  ///新合作商
  static const ROUTE_COOPERATORS = '/business/cooperators';

  /// 创建合作商
  static const ROUTE_COOPERATORS_CREATE = '/business/cooperators/create';

  static const ROUTE_SUBCONTRACTS_POOL =
      '/business/subcontract/subcontract_pool';
  static const ROUTE_SUBCONTRACTS_MINE =
      '/business/subcontract/subcontract_mine';

  ///外接订单导入
  static const ROUTE_SALE_PRODUCTION_EXTERNAL_ORDERS_IMPORT =
      '/business/sale_production/external_sale_order/import';
  static const ROUTE_EXTERNAL_SALE_ORDERS =
      '/business/orders/sales_production/external_sale_orders';

  ///外接订单表单
  static const ROUTE_EXTERNAL_SALE_ORDER_FORM =
      '/business/sale_production/external_sale_order/form';

  ///外接订单导入
  static const ROUTE_OUT_ORDER_FORM =
      '/business/sale_production/out_order/form';

  static const ROUTE_OUT_ORDERS =
      '/business/orders/sales_production/out_orders';
  static const ROUTE_EXTERNAL_SALE_ORDERS_DETAIL =
      '/business/orders/sales_production/external_sale_orders/detail';
  static const ROUTE_PRODUCTION_TASK_ORDER_DETAIL =
      '/business/orders/sales_production/production_task_order/detail';
  static const ROUTE_PRODUCTION_TASK_ORDERS =
      '/business/orders/sales_production/production_task_orders';
  static const ROUTE_OUT_PRODUCTION_TASK_ORDERS =
      '/business/orders/sales_production/out_production_task_orders';

  ///出货单
  static const ROUTE_DELIVERY_ORDERS = '/business/orders/delivery_orders';
  static const ROUTE_DELIVERY_ORDER_DETAIL =
      '/business/orders/delivery_orders/detail';

  ///对账单
  static const ROUTE_RECONCILIATION_ORDERS =
      '/business/orders/reconciliation_orders';
  static const ROUTE_RECONCILIATION_ORDER_DETAIL =
      '/business/orders/reconciliation_orders/detail';

  static const ROUTE_MY_ACCOUNT = '/my/my_account';
  static const ROUTE_MY_CARD = '/my/card';
  static const ROUTE_MY_BRAND = '/my/my_brand';
  static const ROUTE_MY_FACTORY = '/my/my_factory';
  static const ROUTE_MY_BRAND_CERTIFICATE = '/my/my_brand_certificate';
  static const ROUTE_MY_ADDRESSES = '/my/my_addresses';
  static const ROUTE_MY_CART = '/my/my_cart';
  static const ROUTE_MY_INVOICES = '/my/my_invoices';
  static const ROUTE_MY_CONTRACT = '/my/my_contract_manage_page';
  static const ROUTE_MY_CONTRACT_LIST = '/my/my_contract';
  static const ROUTE_MY_CAPACITY = '/my/my_capacity_from';
  static const ROUTE_CAPACITY_MATCHING = '/my/capacity/capacity_matching';
  static const ROUTE_MY_COLLECTIONS = '/my/my_collections';
  static const ROUTE_MY_CLIENT_SERVICES = '/my/my_client_services';
  static const ROUTE_MY_SETTINGS = '/my/my_settings';
  static const ROUTE_MY_HELP = '/my/my_helps';
  static const ROUTE_MY_INTEGRAL_CENTER = '/my/integral_center';

  static const ROUTE_MY_REGISTER = '/my/account/register';
  static const ROUTE_MY_REGISTER_BRAND = '/my/account/register_brand';
  static const ROUTE_MY_REGISTER_FACTORY = '/my/account/register_factory';
  static const ROUTE_MY_REGISTER_CUSTOMER = '/my/account/register_customer';
  static const ROUTE_MY_BILL = '/my/my_bill';
  static const ROUTE_DELIVERY = '/business/delivery';

  static const ROUTE_ORDER_COORDINATION = '/business/order_coordination';
  static const ROUTE_PUBLISH_CENTER = '/home/publish_center';

  static const ROUTE_WEBVIEW_PAGE = '/webview_page';

  static const ROUTE_AUTH_REQUEST_PAGE = '/auth_request_page';

  static const ROUTE_ACTIVITY_INVITE = '/activity/invite';

  ///面辅料管理
  static const ROUTE_MATERIEL_PRODUCT_MANAGE =
      '/business/materiel_product/manage';

  ///面辅料
  static const ROUTE_MATERIEL_PRODUCTS = '/home/materiel_product';

  ///渠道码注册
  static const ROUTE_CHANNEL_REGISTER = '/my/account/register/channel';

  ///需求订单明细
  static const ROUTE_REQUIREMENT = '/business/requirement';

  ///工厂介绍明细
  static const ROUTE_FACTORY_INTRODUCTION = '/factory/introduction';

  ///服务申请页面
  static const ROUTE_SERVICE_APPLY = '/business/services/apply';

  ///订单导入页面
  static const ROUTE_ORDER_IMPORT = '/business/orders/import';

  ///款式管理
  static const ROUTE_SAMPLE_PRODUCTS = '/business/sample_products';

  ///款式详情
  static const ROUTE_SAMPLE_PRODUCT = '/business/sample_product';

  ///首页搜索
  static const ROUTE_HOME_SEARCH = '/search';

  ///首页搜索结果
  static const ROUTE_HOME_SEARCH_RESULT = '/search/';

  ///离我最近
  static const ROUTE_REQUIREMENT_ORDERS_NEARBY =
      '/business/requirement_orders_nearby';

  ///推荐工厂
  static const ROUTE_FACTORIES = '/factories';

  static Map<String, WidgetBuilder> allRoutes = <String, WidgetBuilder>{
    ROUTE_LOGIN: (context) => B2BLoginPage(),
    ROUTE_EMPLOYEES: (context) => EmployeesPage(),
    ROUTE_PRODUCTS: (context) => ApparelProductsPage(),
    ROUTE_PRODUCTS_BRAND: (context) => ApparelProductsBrandPage(),
    ROUTE_PURCHASE_ORDERS: (context) => PurchaseOrdersPage(),
    ROUTE_REQUIREMENT_ORDERS: (context) => RequirementOrdersPage(),
    ROUTE_QUOTES: (context) => QuoteOrdersPage(),
    ROUTE_MY_QUOTES: (context) => QuoteMyOrdersPage(),
    ROUTE_SUPPLIERS: (context) => SuppliersPage(),
    ROUTE_SUBCONTRACTS_POOL: (context) => SubContractPoolPage(),
    ROUTE_SUBCONTRACTS_MINE: (context) => SubContractMinePage(),
    ROUTE_MY_HOME: (context) => MyHomePage(),
    ROUTE_MY_ACCOUNT: (context) => MyAccountPage(),
//    ROUTE_MY_BRAND: (context) => MyBrandPage(),
    ROUTE_MY_FACTORY: (context) => MyFactoryPage(),
    ROUTE_MY_ADDRESSES: (context) => MyAddressesPage(),
    ROUTE_MY_INVOICES: (context) => MyInvoicesPage(),
    ROUTE_MY_CONTRACT: (context) => MyContractManagePage(),
    ROUTE_MY_CONTRACT_LIST: (context) => MyContractPage(),
    ROUTE_MY_CAPACITY: (context) => MyCapacityPage(),
    ROUTE_MY_CLIENT_SERVICES: (context) => MyClientServicesPage(),
    ROUTE_MY_SETTINGS: (context) => MySettingsPage(),
    ROUTE_MY_REGISTER: (context) => RegisterPage(),
    ROUTE_MY_INTEGRAL_CENTER: (context) => IntegralCenterPage(),
    // ROUTE_HOT_CATEGORY_FACTORY: (context) => FactoryHotCategoryPage(),
    ROUTE_HOT_CATEGORY_PRODUCT: (context) => ProductHotCategoryPage(),
    ROUTE_PROOFING_ORDERS: (context) => ProofingOrdersPage(),
    ROUTE_MY_BILL: (context) => MyBillPage(),
    ROUTE_MY_HELP: (context) => MyHelpPage(),
    ROUTE_CAPACITY_MATCHING: (context) => CapacityMatchingPage(),
    ROUTE_ORDER_COORDINATION: (context) => OrderCoordinationPage(),
    ROUTE_PUBLISH_CENTER: (context) => PublishCenterPage(),
    ROUTE_ORDER_PRODUCTS: (context) => ProductsPage(),
    ROUTE_ORDER_PRODUCTS_INDEX: (context) => ProductsHomePage(),
    ROUTE_SALE_ORDERS: (context) => SaleOrdersPage(),
    ROUTE_WEBVIEW_PAGE: (context) => WebviewPage(),
    ROUTE_AUTH_REQUEST_PAGE: (context) => AuthRequestPage(),
    ROUTE_FABRIC_PUBLISH: (context) => FabricRequirementPublishFormPage(),
    ROUTE_FABRIC_REQUIREMENT: (context) => FabricRequirementPage(),
    ROUTE_EXTERNAL_SALE_ORDERS: (context) => ExternalSaleOrdersPage(),
    ROUTE_SALE_PRODUCTION_EXTERNAL_ORDERS_IMPORT: (context) =>
        ExternalSaleOrderImportPage(),
    ROUTE_OUT_ORDERS: (context) => OutOrdersPage(),
    ROUTE_EXTERNAL_SALE_ORDERS_DETAIL: (context) => ExternalSaleOrderDetailPage(
          id: int.parse('${getVal('id', context)}'),
          titile: getVal('title', context),
        ),
    ROUTE_PRODUCTION_TASK_ORDER_DETAIL: (context) =>
        ProductionTaskOrderEntryDetailPage(
            id: ModalRoute.of(context).settings.arguments),
    ROUTE_PRODUCTION_TASK_ORDERS: (context) => ProductionTaskOrdersPage(),
    ROUTE_OUT_PRODUCTION_TASK_ORDERS: (context) =>
        OutProductionTaskOrdersPage(),
    ROUTE_OUT_ORDER_FORM: (context) => OutOrderForm(),
    ROUTE_COOPERATORS: (context) => CooperatorsPage(),
    ROUTE_COOPERATORS_CREATE: (context) => CooperatorForm(),
    ROUTE_DELIVERY_ORDERS: (context) => DeliveryOrdersPage(),
    ROUTE_DELIVERY_ORDER_DETAIL: (context) => DeliveryOrderDetailPage(
        id: int.parse('${getVal('id', context)}'),
        needRefresh: getVal('needRefresh', context)),
    ROUTE_RECONCILIATION_ORDERS: (context) => ReconciliationOrdersPage(),
    ROUTE_RECONCILIATION_ORDER_DETAIL: (context) =>
        ReconciliationOrderDetailPage(
            id: int.parse('${getVal('id', context)}'),
            needRefresh: getVal('needRefresh', context)),
    ROUTE_ACTIVITY_INVITE: (context) => InvitePage(),
    ROUTE_MATERIEL_PRODUCT_MANAGE: (context) => MaterielProductManagePage(),
    ROUTE_MATERIEL_PRODUCTS: (context) => MaterielProductsPage(),
    ROUTE_CHANNEL_REGISTER: (context) => RegisterChannelPage(
          channelCode: getVal('code', context),
        ),
    ROUTE_REQUIREMENT: (context) => RequirementOrderDetailByFactoryPage(
          getVal('code', context),
        ),
    ROUTE_FACTORY_INTRODUCTION: (context) => FactoryIntroductionPage(
          uid: getVal('uid', context),
        ),
    ROUTE_SERVICE_APPLY: (context) => OperationAgentServiceApplyPage(),
    ROUTE_ORDER_IMPORT: (context) =>
        OrderImportPage(code: getVal('code', context)),
    ROUTE_SAMPLE_PRODUCTS: (context) => SampleProductsPage(),
    ROUTE_SAMPLE_PRODUCT: (context) =>
        SampleProductDetailPage(getVal('code', context)),
    ROUTE_EXTERNAL_SALE_ORDER_FORM: (context) => ExternalOrderForm(),
    ROUTE_MY_CARD: (context) => MyCardPage(),
    ROUTE_REGISTER: (context) =>
        RegisterPageV2(
          openId: getVal('openId', context),
          type: getVal('type', context) != null
              ? AuthTypeMap[getVal('type', context)]
              : null,
          channelCode: getVal('channelCode', context),
        ),
    ROUTE_HOME_SEARCH: (context) =>
        HomeSearchPage(keyword: getVal('keyword', context)),
    ROUTE_HOME_SEARCH_RESULT: (context) =>
        HomeSearchResultPage(keyword: getVal('keyword', context)),
    ROUTE_REQUIREMENT_ORDERS_NEARBY: (context) => NearbyRequirementPage(),
    ROUTE_FACTORIES: (context) => FindingFactoryPage()
  };

  static dynamic getVal(String key, BuildContext context) {
    Map<String, dynamic> map = ModalRoute
        .of(context)
        .settings
        .arguments;
    if (map != null) {
      return map[key];
    } else {
      return null;
    }
  }
}
