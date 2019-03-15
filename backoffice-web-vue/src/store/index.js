import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

import {
  EnumsModule,
  UsersModule,
  UserGroupsModule,
  RolesModule,
  EmployeesModule,
  FactoriesModule,
  BrandsModule,
  AuditFactoriesModule,
  AuditBrandsModule,
  IndustrialClustersModule,
  LabelsModule,
  ColorsModule,
  SizesModule,
  StylesModule,
  CategoriesModule,
  FabricProductsModule,
  ApparelProductsModule,
  RequirementOrdersModule,
  SalesOrdersModule,
  PurchaseOrdersModule,
  QuotesModule
} from './modules';

import {
  BrandEmployeesModule,
  BrandFollowersModule,
  BrandMembersModule,
  BrandMemberRequestsModule,
  BrandOrgsModule,
  BrandRolesModule,
  BrandRequirementOrdersModule,
  BrandSalesOrdersModule,
  BrandPurchaseOrdersModule,
  BrandApparelProductsModule,
  BrandDeletedApparelProductsModule,
  BrandApparelProductStocksModule,
} from './brand/modules';

import {
  FactoryEmployeesModule,
  FactoryOrgsModule,
  FactoryRolesModule,
  FactoryFabricProductsModule,
  FactoryFabricProductStocksModule,
  FactoryRequirementOrdersModule,
  FactoryPurchaseOrdersModule,
  FactoryQuotesModule,
} from './factory/modules';

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
  },
};

// actions
const actions = {
  sideSliderState_set({dispatch, commit, state}, payload) {
    commit('sideSliderState_get', payload);
  }
};

export default new Vuex.Store({
  modules: {
    EnumsModule,
    // tenant
    UsersModule,
    UserGroupsModule,
    RolesModule,
    EmployeesModule,
    FactoriesModule,
    BrandsModule,
    AuditFactoriesModule,
    AuditBrandsModule,
    IndustrialClustersModule,
    LabelsModule,
    ColorsModule,
    SizesModule,
    StylesModule,
    CategoriesModule,
    FabricProductsModule,
    ApparelProductsModule,
    RequirementOrdersModule,
    SalesOrdersModule,
    ProductionOrdersModule: PurchaseOrdersModule,
    QuotesModule,
    // brand
    BrandEmployeesModule,
    BrandFollowersModule,
    BrandMembersModule,
    BrandMemberRequestsModule,
    BrandOrgsModule,
    BrandRolesModule,
    BrandRequirementOrdersModule,
    BrandSalesOrdersModule,
    BrandProductionOrdersModule: BrandPurchaseOrdersModule,
    BrandApparelProductsModule,
    BrandDeletedApparelProductsModule,
    BrandApparelProductStocksModule,
    // factory
    FactoryEmployeesModule,
    FactoryOrgsModule,
    FactoryRolesModule,
    FactoryFabricProductsModule,
    FactoryFabricProductStocksModule,
    FactoryRequirementOrdersModule,
    FactoryProductionOrdersModule: FactoryPurchaseOrdersModule,
    FactoryQuotesModule,
  },
  state,
  getters,
  mutations,
  actions
});
