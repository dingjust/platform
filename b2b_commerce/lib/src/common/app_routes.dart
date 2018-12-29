import 'package:flutter/material.dart';

import '../business/employees.dart';
import '../business/member_requests.dart';
import '../business/memberships.dart';
import '../business/product_stock_adjust_history.dart';
import '../business/product_stocks.dart';
import '../business/production_orders.dart';
import '../business/products.dart';
import '../business/products_off_the_shelf.dart';
import '../business/purchase_orders.dart';
import '../business/quotes.dart';
import '../business/requirement_orders.dart';
import '../business/sales_orders.dart';
import '../business/sample_garments.dart';
import '../business/suppliers.dart';
import '../my/my_account.dart';
import '../my/my_addresses.dart';
import '../my/my_cart.dart';
import '../my/my_client_services.dart';
import '../my/my_collections.dart';
import '../my/my_company.dart';
import '../my/my_invoices.dart';
import '../my/my_settings.dart';

class AppRoutes {
  static const ROUTE_EMPLOYEES = '/business/employees';
  static const ROUTE_MEMBERSHIPS = '/business/memberships';
  static const ROUTE_MEMBER_REQUESTS = '/business/member_requests';
  static const ROUTE_PRODUCT_STOCKS = '/business/product_stocks';
  static const ROUTE_PRODUCT_STOCK_ADJUST_HISTORY = '/business/product_stock_adjust_history';
  static const ROUTE_PRODUCTION_ORDERS = '/business/production_orders';
  static const ROUTE_PRODUCTS = '/business/products';
  static const ROUTE_PRODUCTS_OFF_THE_SHELF = '/business/products_off_the_shelf';
  static const ROUTE_PURCHASE_ORDERS = '/business/purchase_orders';
  static const ROUTE_QUOTES = '/business/quotes';
  static const ROUTE_REQUIREMENT_ORDERS = '/business/requirement_orders';
  static const ROUTE_SALES_ORDERS = '/business/sales_orders';
  static const ROUTE_SAMPLE_GARMENTS = '/business/sample_garments';
  static const ROUTE_SUPPLIERS = '/business/suppliers';
  static const ROUTE_MY_ACCOUNT = '/my/my_account';
  static const ROUTE_MY_COMPANY = '/my/my_company';
  static const ROUTE_MY_ADDRESSES = '/my/my_addresses';
  static const ROUTE_MY_CART = '/my/my_cart';
  static const ROUTE_MY_INVOICES = '/my/my_invoices';
  static const ROUTE_MY_COLLECTIONS = '/my/my_collections';
  static const ROUTE_MY_CLIENT_SERVICES = '/my/my_client_services';
  static const ROUTE_MY_SETTINGS = '/my/my_settings';

  static Map<String, WidgetBuilder> allRoutes = <String, WidgetBuilder>{
    ROUTE_EMPLOYEES: (context) => EmployeesPage(),
    ROUTE_MEMBERSHIPS: (context) => MembershipsPage(),
    ROUTE_MEMBER_REQUESTS: (context) => MemberRequestsPage(),
    ROUTE_PRODUCT_STOCKS: (context) => ProductStocksPage(),
    ROUTE_PRODUCTION_ORDERS: (context) => ProductionOrdersPage(),
    ROUTE_PRODUCTS: (context) => ProductsPage(),
    ROUTE_PRODUCTS_OFF_THE_SHELF: (context) => OffTheShelfProductsPage(),
    ROUTE_PRODUCT_STOCK_ADJUST_HISTORY: (context) => ProductStockAdjustHistoryPage(),
    ROUTE_PURCHASE_ORDERS: (context) => PurchaseOrdersPage(),
    ROUTE_QUOTES: (context) => QuotesPage(),
    ROUTE_REQUIREMENT_ORDERS: (context) => RequirementOrdersPage(),
    ROUTE_SALES_ORDERS: (context) => SalesOrdersPage(),
    ROUTE_SAMPLE_GARMENTS: (context) => SampleGarmentsPage(),
    ROUTE_SUPPLIERS: (context) => SuppliersPage(),
    ROUTE_MY_ACCOUNT: (context) => MyAccountPage(),
    ROUTE_MY_COMPANY: (context) => MyCompanyPage(),
    ROUTE_MY_ADDRESSES: (context) => MyAddressesPage(),
    ROUTE_MY_CART: (context) => MyCartPage(),
    ROUTE_MY_INVOICES: (context) => MyInvoicesPage(),
    ROUTE_MY_COLLECTIONS: (context) => MyCollectionsPage(),
    ROUTE_MY_CLIENT_SERVICES: (context) => MyClientServicesPage(),
    ROUTE_MY_SETTINGS: (context) => MySettingsPage()
  };
}
