// shared
import EnumsModule from './shared/enums';

// user
import UsersModule from './user/users';
import UserGroupsModule from './user/user-groups';
import B2BUnitsModule from './user/b2b-units';
import AddressesModule from './user/addresses';
import RolesModule from './user/roles';
import EmployeesModule from './user/employees';
import B2BCustomersModule from './user/b2b-customers';
import FactoriesModule from './user/factories';
import BrandsModule from './user/brands';
import PermissionModule from './user/permission';
// product
import ColorsModule from './product/colors';
import SizesModule from './product/sizes';
import CategoriesModule from './product/categories';
import ApparelProductsModule from './product/apparel-products';
import MaterialModule from './product/material'
import SampleProductsModule from './product/sample-products';
// order
import RequirementOrdersModule from './order/requirement-orders';
import PurchaseOrdersModule from './order/purchase-orders';
import QuotesModule from './order/quotes';
import ProofingsModule from './order/proofings';
import SalesOrdersModule from './order/sales-orders';

// miscs
import SampleCheckoutHistModule from './miscs/sampleCheckoutHist';
import SuppliersModule from './miscs/suppliers';
import CooperatorModule from './miscs/cooperator';
import IndustrialClustersModule from './miscs/industrial-clusters';
import LabelsModule from './miscs/labels';
import CarouselsModule from './miscs/carousels';
import PayPlanModule from './miscs/payPlan';
import OperationCoursesModule from './miscs/operationCourses';
import WalletModule from './miscs/wallet';
import CashOutManagerModule from './miscs/cashOutManager';
import PromoteProductModule from './miscs/promoteProduct';

// sale-production
import SalesProductionOrdersModule from './sale-production/sales-Production-orders';
import PendingSalesProductionOrdersModule from './sale-production/pending-sales-Production-orders';

import OutboundOrderModule from './sale-production/outbound-order'
import ProductionTasksModule from './sale-production/production-tasks'
import PurchaseTaskModule from './sale-production/purchase-orders'

import ProductionOrderModule from './sale-production/production-orders.js'
import OutboundProductionOrderModule from './sale-production/outbound-production-orders.js'
import ProgressOrderModule from './sale-production/progress-orders.js'

// contract
import ContractModule from './contract/contract';
import ContractTemplateModule from './contract/contractTemplate'
import ContractSealModule from './contract/contractSeal'

// shipping-receipt
import ImportShippingTasksModule from './shipping-receipt/import-shipping-tasks'
import ExportShippingTasksModule from './shipping-receipt/export-shipping-tasks'
import ShippingOrdersModule from './shipping-receipt/shipping-orders'
import ReceiptOrdersModule from './shipping-receipt/receipt-orders'
import ReturnOrdersModule from './shipping-receipt/return-orders'

// reconciliation
import ReconciliationTasksModule from './reconciliation/reconciliation-tasks'
import ReconciliationOrdersModule from './reconciliation/reconciliation-orders'

// 产能
import CapacityModule from './capacity/capacity'

// 报表
import ReceiptReportModule from './report/receipt'
import ProductionProgressReportModule from './report/production_progress'

// 任务
import TaskHandleModule from './task/task-handle'
import TaskApprovalModule from './task/task-approval'

// 消息
import MessageModule from './message/message';
export {
  // shared
  EnumsModule,
  // user
  AddressesModule,
  B2BCustomersModule,
  B2BUnitsModule,
  BrandsModule,
  EmployeesModule,
  FactoriesModule,
  RolesModule,
  UsersModule,
  PermissionModule,
  UserGroupsModule,
  // product
  ApparelProductsModule,
  CategoriesModule,
  ColorsModule,
  SizesModule,
  MaterialModule,
  SampleProductsModule,
  // order
  RequirementOrdersModule,
  PurchaseOrdersModule,
  QuotesModule,
  ProofingsModule,
  SalesOrdersModule,
  // miscs
  CarouselsModule,
  IndustrialClustersModule,
  LabelsModule,
  SampleCheckoutHistModule,
  SuppliersModule,
  CooperatorModule,
  PayPlanModule,
  OperationCoursesModule,
  WalletModule,
  CashOutManagerModule,
  PromoteProductModule,
  // sale-production
  SalesProductionOrdersModule,
  PendingSalesProductionOrdersModule,
  OutboundOrderModule,
  ProductionOrderModule,
  OutboundProductionOrderModule,
  ProgressOrderModule,
  ProductionTasksModule,
  PurchaseTaskModule,
  // contract
  ContractModule,
  ContractTemplateModule,
  ContractSealModule,
  // shipping-receipt
  ImportShippingTasksModule,
  ExportShippingTasksModule,
  ShippingOrdersModule,
  ReceiptOrdersModule,
  ReturnOrdersModule,
  // reconciliation
  ReconciliationTasksModule,
  ReconciliationOrdersModule,
  // 产能
  CapacityModule,
  // 报表
  ReceiptReportModule,
  ProductionProgressReportModule,
  // 消息
  MessageModule,
  // 任务
  TaskHandleModule,
  TaskApprovalModule
}
