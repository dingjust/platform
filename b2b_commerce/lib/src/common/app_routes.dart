import 'package:flutter/material.dart';

import '../business/employees.dart';
import '../business/member_requests.dart';
import '../business/memberships.dart';
import '../business/product_stocks.dart';
import '../business/production_orders.dart';
import '../business/products.dart';
import '../business/purchase_orders.dart';
import '../business/quotes.dart';
import '../business/requirement_orders.dart';
import '../business/sales_orders.dart';
import '../business/sample_garments.dart';
import '../business/suppliers.dart';

class AppRoutes {
  static const ROUTE_EMPLOYEES = '/business/employees';
  static const ROUTE_MEMBERSHIPS = '/business/memberships';
  static const ROUTE_MEMBER_REQUESTS = '/business/member_requests';
  static const ROUTE_PRODUCT_STOCKS = '/business/product_stocks';
  static const ROUTE_PRODUCTION_ORDERS = '/business/production_orders';
  static const ROUTE_PRODUCTS = '/business/products';
  static const ROUTE_PURCHASE_ORDERS = '/business/purchase_orders';
  static const ROUTE_QUOTES = '/business/quotes';
  static const ROUTE_REQUIREMENT_ORDERS = '/business/requirement_orders';
  static const ROUTE_SALES_ORDERS = '/business/sales_orders';
  static const ROUTE_SAMPLE_GARMENTS = '/business/sample_garments';
  static const ROUTE_SUPPLIERS = '/business/suppliers';

  static Map<String, WidgetBuilder> allRoutes = <String, WidgetBuilder>{
    ROUTE_EMPLOYEES: (context) => EmployeesPage(),
    ROUTE_MEMBERSHIPS: (context) => MembershipsPage(),
    ROUTE_MEMBER_REQUESTS: (context) => MemberRequestsPage(),
    ROUTE_PRODUCT_STOCKS: (context) => ProductStocksPage(),
    ROUTE_PRODUCTION_ORDERS: (context) => ProductionOrdersPage(),
    ROUTE_PRODUCTS: (context) => ProductsPage(),
    ROUTE_PURCHASE_ORDERS: (context) => PurchaseOrdersPage(),
    ROUTE_QUOTES: (context) => QuotesPage(),
    ROUTE_REQUIREMENT_ORDERS: (context) => RequirementOrdersPage(),
    ROUTE_SALES_ORDERS: (context) => SalesOrdersPage(),
    ROUTE_SAMPLE_GARMENTS: (context) => SampleGarmentsPage(),
    ROUTE_SUPPLIERS: (context) => SuppliersPage(),
  };
}
