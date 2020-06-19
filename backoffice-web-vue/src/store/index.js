import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

import {
  EnumsModule,
  // user
  AddressesModule,
  B2BCustomersModule,
  B2BUnitsModule,
  BrandsModule,
  EmployeesModule,
  FactoriesModule,
  UserGroupsModule,
  UsersModule,
  RolesModule,
  PermissionModule,
  // product
  ColorsModule,
  SizesModule,
  CategoriesModule,
  ApparelProductsModule,
  MaterialModule,
  SampleProductsModule,
  // order
  RequirementOrdersModule,
  PurchaseOrdersModule,
  QuotesModule,
  ProofingsModule,
  SalesOrdersModule,
  SalesProductionOrdersModule,
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
  // sale-plan
  OutboundOrderModule,
  ProductionTasksModule,
  ProductionOrderModule,
  ProgressOrderModule,
  PurchaseTaskModule,
  // contract
  ContractModule,
  ContractTemplateModule,
  ContractSealModule,
  // shipping(发货)
  ShippingTasksModule,
  ShippingOrdersModule,
  // 产能
  CapacityModule,
  // 报表
  ReceiptReportModule,
  ProductionProgressReportModule,

  MessageModule,

  // 任务
  TaskHandleModule,
  TaskApprovalModule
} from './modules';

// 状态管理
const state = {
  sideSliderState: false,
  timeout: false
};

const getters = {};

// mutations
const mutations = {
  sideSliderState_get (state, payload) {
    // 类别
    state.sideSliderState = payload;
  }
};

// actions
const actions = {
  sideSliderState_set ({
    dispatch,
    commit,
    state
  }, payload) {
    commit('sideSliderState_get', payload);
  }
};

export default new Vuex.Store({
  modules: {
    EnumsModule,
    // user
    AddressesModule,
    B2BCustomersModule,
    B2BUnitsModule,
    BrandsModule,
    EmployeesModule,
    FactoriesModule,
    UserGroupsModule,
    UsersModule,
    RolesModule,
    PermissionModule,
    // product
    ColorsModule,
    SizesModule,
    CategoriesModule,
    ApparelProductsModule,
    MaterialModule,
    SampleProductsModule,
    // order
    RequirementOrdersModule,
    PurchaseOrdersModule,
    QuotesModule,
    ProofingsModule,
    SalesOrdersModule,
    SalesProductionOrdersModule,
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
    // sale-plan
    OutboundOrderModule,
    ProductionOrderModule,
    ProgressOrderModule,
    ProductionTasksModule,
    PurchaseTaskModule,
    // contract
    ContractModule,
    ContractTemplateModule,
    ContractSealModule,
    // shipping(发货)
    ShippingTasksModule,
    ShippingOrdersModule,
    // 产能
    CapacityModule,
    // 报表
    ReceiptReportModule,
    ProductionProgressReportModule,
    //
    MessageModule,
    // 任务
    TaskHandleModule,
    TaskApprovalModule
  },
  state,
  getters,
  mutations,
  actions
});
