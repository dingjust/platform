import 'package:b2b_commerce/src/business/proofing_orders.dart';
import 'package:b2b_commerce/src/home/factory/hot_category.dart';
import 'package:b2b_commerce/src/home/product/hot_category.dart';
import 'package:b2b_commerce/src/my/my_bill.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../business/apparel_product_stock_adjust_history.dart';
import '../business/apparel_product_stocks.dart';
import '../business/apparel_products.dart';
import '../business/apparel_products_off_the_shelf.dart';
import '../business/employees.dart';
import '../business/member_requests.dart';
import '../business/memberships.dart';
import '../business/production_orders.dart';
import '../business/purchase_orders.dart';
import '../business/quote_orders.dart';
import '../business/requirement_orders.dart';
import '../business/sales_orders.dart';
import '../business/sample_garments.dart';
import '../business/suppliers.dart';
import '../home/account/login.dart';
import '../my/account/register.dart';
import '../my/account/register_brand.dart';
import '../my/account/register_customer.dart';
import '../my/account/register_factory.dart';
import '../my/my_account.dart';
import '../my/my_addresses.dart';
import '../my/my_cart.dart';
import '../my/my_client_services.dart';
import '../my/my_collections.dart';
import '../my/my_brand.dart';
import '../my/my_invoices.dart';
import '../my/index.dart';
import '../my/my_settings.dart';
import '../business/orders/requirement_order_detail.dart';
import '../business/orders/requirement_quote_detail.dart';
import '../business/delivery.dart';

class AppRoutes with GlobalRoutes {
  static const ROUTE_LOGIN = GlobalRoutes.ROUTE_LOGIN;
  static const ROUTE_MY_HOME = GlobalRoutes.ROUTE_MY_HOME;
  static const ROUTE_HOT_CATEGORY_FACTORY = '/home/factory/hot_category';
  static const ROUTE_HOT_CATEGORY_PRODUCT = '/home/product/hot_category';
  static const ROUTE_EMPLOYEES = '/business/employees';
  static const ROUTE_MEMBERSHIPS = '/business/memberships';
  static const ROUTE_MEMBER_REQUESTS = '/business/member_requests';
  static const ROUTE_PRODUCT_STOCKS = '/business/product_stocks';
  static const ROUTE_PRODUCT_STOCK_ADJUST_HISTORY =
      '/business/product_stock_adjust_history';
  static const ROUTE_PRODUCTION_ORDERS = '/business/production_orders';
  static const ROUTE_PRODUCTS = '/business/products';
  static const ROUTE_PRODUCTS_OFF_THE_SHELF =
      '/business/products_off_the_shelf';
  static const ROUTE_PURCHASE_ORDERS = '/business/purchase_orders';
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
  static const ROUTE_MY_ACCOUNT = '/my/my_account';
  static const ROUTE_MY_BRAND = '/my/my_brand';
  static const ROUTE_MY_FACTORY = '/my/my_factory';
  static const ROUTE_MY_ADDRESSES = '/my/my_addresses';
  static const ROUTE_MY_CART = '/my/my_cart';
  static const ROUTE_MY_INVOICES = '/my/my_invoices';
  static const ROUTE_MY_COLLECTIONS = '/my/my_collections';
  static const ROUTE_MY_CLIENT_SERVICES = '/my/my_client_services';
  static const ROUTE_MY_SETTINGS = '/my/my_settings';
  static const ROUTE_MY_REGISTER = '/my/account/register';
  static const ROUTE_MY_REGISTER_BRAND = '/my/account/register_brand';
  static const ROUTE_MY_REGISTER_FACTORY = '/my/account/register_factory';
  static const ROUTE_MY_REGISTER_CUSTOMER = '/my/account/register_customer';
  static const ROUTE_MY_BILL = '/my/my_bill';
  static const ROUTE_DELIVERY = '/business/delivery';

  static Map<String, WidgetBuilder> allRoutes = <String, WidgetBuilder>{
    ROUTE_LOGIN: (context) => B2BLoginPage(),
    ROUTE_EMPLOYEES: (context) => EmployeesPage(),
    ROUTE_MEMBERSHIPS: (context) => MembershipsPage(),
    ROUTE_MEMBER_REQUESTS: (context) => MemberRequestsPage(),
    ROUTE_PRODUCT_STOCKS: (context) => ApparelProductStocksPage(),
    ROUTE_PRODUCTS: (context) => ApparelProductsPage(),
    ROUTE_PRODUCTS_OFF_THE_SHELF: (context) => OffTheShelfApparelProductsPage(),
    ROUTE_PRODUCT_STOCK_ADJUST_HISTORY: (context) =>
        ApparelProductStockAdjustHistoryPage(),
    ROUTE_PRODUCTION_ORDERS: (context) => ProductionOrdersPage(),
    ROUTE_PURCHASE_ORDERS: (context) => PurchaseOrdersPage(),
    ROUTE_REQUIREMENT_ORDERS: (context) => RequirementOrdersPage(),
    ROUTE_REQUIREMENT_ORDERS_DETAIL: (context) => RequirementOrderDetailPage(),
    ROUTE_SALES_ORDERS: (context) => SalesOrdersPage(),
    ROUTE_QUOTES: (context) => QuoteOrdersPage(),
    ROUTE_SAMPLE_GARMENTS: (context) => SampleGarmentsPage(),
    ROUTE_SUPPLIERS: (context) => SuppliersPage(),
    ROUTE_MY_HOME: (context) => MyHomePage(),
    ROUTE_MY_ACCOUNT: (context) => MyAccountPage(),
    ROUTE_MY_BRAND: (context) => MyBrandPage(),
    ROUTE_MY_FACTORY: (context) => MyFactoryPage(),
    ROUTE_MY_ADDRESSES: (context) => MyAddressesPage(),
    ROUTE_MY_CART: (context) => MyCartPage(),
    ROUTE_MY_INVOICES: (context) => MyInvoicesPage(),
    ROUTE_MY_COLLECTIONS: (context) => MyCollectionsPage(),
    ROUTE_MY_CLIENT_SERVICES: (context) => MyClientServicesPage(),
    ROUTE_MY_SETTINGS: (context) => MySettingsPage(),
    ROUTE_MY_REGISTER: (context) => RegisterPage(),
    ROUTE_MY_REGISTER_BRAND: (context) => RegisterBrandPage(),
    ROUTE_MY_REGISTER_FACTORY: (context) => RegisterFactoryPage(),
    ROUTE_MY_REGISTER_CUSTOMER: (context) => RegisterCustomerPage(),
    ROUTE_REQUIREMENT_QUOTE_DETAIL: (context) => RequirementQuoteDetailPage(),
    ROUTE_DELIVERY: (context) => DeliveryPage(),
    ROUTE_HOT_CATEGORY_FACTORY: (context) => FactoryHotCategoryPage(),
    ROUTE_HOT_CATEGORY_PRODUCT: (context) => ProductHotCategoryPage(),
    ROUTE_PROOFING_ORDERS: (context) => ProofingOrdersPage(),
    ROUTE_MY_BILL: (context) => MyBillPage()
  };
}
