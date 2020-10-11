import 'package:b2b_commerce/src/business/apparel_products_brand.dart';
import 'package:b2b_commerce/src/business/orders/order_coordination.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_orders.dart';
import 'package:b2b_commerce/src/business/proofing_orders.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_mine.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_pool.dart';
import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:b2b_commerce/src/home/account/auth_request_page.dart';
import 'package:b2b_commerce/src/home/factory/publish_center.dart';
import 'package:b2b_commerce/src/home/product/hot_category.dart';
import 'package:b2b_commerce/src/home/product/index.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:b2b_commerce/src/my/account/my_bill.dart';
import 'package:b2b_commerce/src/my/capacity/capacity_matching.dart';
import 'package:b2b_commerce/src/my/my_capacity.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:b2b_commerce/src/my/my_contract_manage_page.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../business/apparel_products.dart';
import '../business/employees.dart';
import '../business/purchase_orders.dart';
import '../business/quote_orders.dart';
import '../business/requirement_orders.dart';
import '../business/sample_garments.dart';
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
  static const ROUTE_REQUIREMENT_ORDERS = '/business/requirement_orders';
  static const ROUTE_REQUIREMENT_ORDERS_DETAIL =
      '/business/orders/requirement_orders_detail';
  static const ROUTE_REQUIREMENT_QUOTE_DETAIL =
      '/business/orders/requirement_quote_detail';
  static const ROUTE_PROOFING_ORDERS = '/business/proofing_orders';
  static const ROUTE_SALES_ORDERS = '/business/sales_orders';
  static const ROUTE_SAMPLE_GARMENTS = '/business/sample_garments';
  static const ROUTE_SUPPLIERS = '/business/suppliers';
  static const ROUTE_SUBCONTRACTS_POOL =
      '/business/subcontract/subcontract_pool';
  static const ROUTE_SUBCONTRACTS_MINE =
      '/business/subcontract/subcontract_mine';

  static const ROUTE_MY_ACCOUNT = '/my/my_account';
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

  static Map<String, WidgetBuilder> allRoutes = <String, WidgetBuilder>{
    ROUTE_LOGIN: (context) => B2BLoginPage(),
    ROUTE_EMPLOYEES: (context) => EmployeesPage(),
    ROUTE_PRODUCTS: (context) => ApparelProductsPage(),
    ROUTE_PRODUCTS_BRAND: (context) => ApparelProductsBrandPage(),
    ROUTE_PURCHASE_ORDERS: (context) => PurchaseOrdersPage(),
    ROUTE_REQUIREMENT_ORDERS: (context) => RequirementOrdersPage(),
    ROUTE_QUOTES: (context) => QuoteOrdersPage(),
    ROUTE_SAMPLE_GARMENTS: (context) => SampleGarmentsPage(),
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
    ROUTE_AUTH_REQUEST_PAGE: (context) => AuthRequestPage()
  };
}
