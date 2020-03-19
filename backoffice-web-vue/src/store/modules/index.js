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
// order
import RequirementOrdersModule from './order/requirement-orders';
import PurchaseOrdersModule from './order/purchase-orders';
import QuotesModule from './order/quotes';
import ProofingsModule from './order/proofings';
import SalesOrdersModule from './order/sales-orders';


// miscs
import SampleProductModule from './miscs/sampleProduct';
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

// contract
import ContractModule from './contract/contract';
import ContractTemplateModule from './contract/contractTemplate'
import ContractSealModule from './contract/contractSeal'

// 产能
import CapacityModule from './capacity/capacity'

// 报表
import ReceiptReportModule from './report/receipt'
import ProductionProgressReportModule from './report/production_progress'

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
  SampleProductModule,
  SampleCheckoutHistModule,
  SuppliersModule,
  CooperatorModule,
  PayPlanModule,
  OperationCoursesModule,
  WalletModule,
  CashOutManagerModule,
  // contract
  ContractModule,
  ContractTemplateModule,
  ContractSealModule,
  // 产能
  CapacityModule,
  // 报表
  ReceiptReportModule,
  ProductionProgressReportModule,
  // 消息
  MessageModule
}
