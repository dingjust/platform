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
const PRODUCTION_TASK_ORDER_STATE_COLORS = {
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

///  生产进度工单状态颜色
const PROGRESS_WORK_SHEET_STATUS_COLORS = {
  ProgressWorkSheetStatus.IN_PRODUCTION: Color(0xffff9800),
  ProgressWorkSheetStatus.COMPLETED: Colors.green,
};

///  发货单状态颜色
const DELIVERY_ORDER_STATUS_COLORS = {
  LogisticsSheetState.PENDING_RECONCILED: Color(0xffff9800),
  LogisticsSheetState.IN_RECONCILED: Colors.blueAccent,
  LogisticsSheetState.COMPLETED: Colors.green,
};

Color getDeliveryOrderStateColor(LogisticsSheetState state) {
  return DELIVERY_ORDER_STATUS_COLORS[state] ?? Colors.black54;
}

///  对账单状态颜色
const RECONCILIATION_ORDER_STATUS_COLORS = {
  FastReconciliationSheetState.PENDING_B_SIGN: Colors.blueAccent,
  FastReconciliationSheetState.PENDING_APPROVAL: Color(0xffff9800),
  FastReconciliationSheetState.PENDING_A_SIGN: Color(0xff4db6ac),
  FastReconciliationSheetState.COMPLETED: Colors.green,
  FastReconciliationSheetState.CANCELLED: Colors.red
};

Color getReconciliationOrderStateColor(FastReconciliationSheetState state) {
  return RECONCILIATION_ORDER_STATUS_COLORS[state] ?? Colors.black54;
}
