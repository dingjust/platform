import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SaleOrderConstants {
  ///状态颜色
  static const STATUS_COLORS = {
    SalesOrderStatus.PENDING_PAYMENT: Colors.red,
    SalesOrderStatus.PENDING_CONFIRM: Color(0xFFFFD600),
    // SalesOrderStatus.OUT_OF_STORE: Color(0xFFFFD600),
    // SalesOrderStatus.IN_PRODUCTION: Color(0xFFFFD600),
    SalesOrderStatus.COMPLETED: Colors.green,
    SalesOrderStatus.CANCELLED: Colors.grey,
  };
}
