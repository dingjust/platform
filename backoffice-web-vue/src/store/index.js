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
  ColorsModule,
  SizesModule,
  StylesModule,
  CategoriesModule,
  FabricProductsModule,
  ApparelProductsModule,
  RequirementOrdersModule,
  SalesOrdersModule,
  ProductionOrdersModule
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
    UsersModule,
    UserGroupsModule,
    RolesModule,
    EmployeesModule,
    FactoriesModule,
    BrandsModule,
    AuditFactoriesModule,
    AuditBrandsModule,
    ColorsModule,
    SizesModule,
    StylesModule,
    CategoriesModule,
    FabricProductsModule,
    ApparelProductsModule,
    RequirementOrdersModule,
    SalesOrdersModule,
    ProductionOrdersModule
  },
  state,
  getters,
  mutations,
  actions
});
