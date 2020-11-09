import 'package:flutter/material.dart';
import 'package:models/models.dart';

///状态颜色
const SALES_PRODUCTION_STATE_COLORS = {
  SalesProductionOrderState.TO_BE_ACCEPTED: Color(0xFFFFD600),
  SalesProductionOrderState.TO_BE_SUBMITTED: Color(0xFFFF5722),
  SalesProductionOrderState.AUDITING: Color(0xffff9800),
  SalesProductionOrderState.AUDIT_REJECTED: Color(0xFFFFD600),
  SalesProductionOrderState.AUDIT_PASSED: Color(0xff1e88e5),
  SalesProductionOrderState.COMPLETED: Colors.green,
  SalesProductionOrderState.CANCELED: Colors.red,
};

Color getSalesProductionStateColor(SalesProductionOrderState state) {
  return SALES_PRODUCTION_STATE_COLORS[state] ?? Colors.black54;
}

///  生产工单状态颜色
const  PRODUCTION_TASK_ORDER_STATE_COLORS = {
  ProductionTaskOrderState.TO_BE_ALLOCATED: Color(0xFFFFD600),
  ProductionTaskOrderState.TO_BE_PRODUCED: Color(0xFFFF5722),
  ProductionTaskOrderState.PRODUCING: Color(0xffff9800),
  ProductionTaskOrderState.TO_BE_DELIVERED: Color(0xFFFFD600),
  ProductionTaskOrderState.TO_BE_RECONCILED: Color(0xff1e88e5),
  ProductionTaskOrderState.COMPLETED: Colors.green,
  ProductionTaskOrderState.CANCED: Colors.red,
};

Color getProductionTaskOrderStateColor(ProductionTaskOrderState state) {
  return PRODUCTION_TASK_ORDER_STATE_COLORS[state] ?? Colors.black54;
}


