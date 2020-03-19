import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SaleOrderConstants {
  ///状态颜色
  static const STATUS_COLORS = {
    PurchaseOrderStatus.PENDING_PAYMENT: Colors.red,
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.IN_PRODUCTION: Color(0xFFFFD600),
    PurchaseOrderStatus.COMPLETED: Colors.green,
    PurchaseOrderStatus.CANCELLED: Colors.grey,
  };
}
