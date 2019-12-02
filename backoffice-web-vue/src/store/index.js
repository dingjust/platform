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
  // product
  ColorsModule,
  SizesModule,
  CategoriesModule,
  ApparelProductsModule,
  // order
  RequirementOrdersModule,
  PurchaseOrdersModule,
  QuotesModule,
  ProofingsModule,
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
  //产能
  CapacityModule,
  //报表
  ReceiptReportModule
} from './modules';

// 状态管理
const state = {
  sideSliderState: false,
  timeout: false
};

const getters = {};

// mutations
const mutations = {
  sideSliderState_get(state, payload) {
    // 类别
    state.sideSliderState = payload;
  }
};

// actions
const actions = {
  sideSliderState_set({
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
    // product
    ColorsModule,
    SizesModule,
    CategoriesModule,
    ApparelProductsModule,
    // order
    RequirementOrdersModule,
    PurchaseOrdersModule,
    QuotesModule,
    ProofingsModule,
    // miscs
    CarouselsModule,
    IndustrialClustersModule,
    LabelsModule,
    SampleCheckoutHistModule,
    SampleProductModule,
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
    //产能
    CapacityModule,
    //报表
    ReceiptReportModule
  },
  state,
  getters,
  mutations,
  actions
});
