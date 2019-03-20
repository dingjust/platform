import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

import {
  EnumsModule,
  UsersModule,
  CarouselsModule,
  UserGroupsModule,
  B2BUnitsModule,
  RolesModule,
  EmployeesModule,
  B2BCustomersModule,
  AddressesModule,
  FactoriesModule,
  BrandsModule,
  IndustrialClustersModule,
  LabelsModule,
  ColorsModule,
  SizesModule,
  CategoriesModule,
  ApparelProductsModule,
  RequirementOrdersModule,
  PurchaseOrdersModule,
  QuotesModule,
  ProofingsModule,
  SampleProductModule,
  SampleCheckoutHistModule
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
    CarouselsModule,
    UserGroupsModule,
    B2BUnitsModule,
    RolesModule,
    EmployeesModule,
    CompanyAddressesModule: AddressesModule,
    B2BCustomersModule,
    FactoriesModule,
    BrandsModule,
    IndustrialClustersModule,
    LabelsModule,
    ColorsModule,
    SizesModule,
    CategoriesModule,
    ApparelProductsModule,
    RequirementOrdersModule,
    PurchaseOrdersModule,
    QuotesModule,
    ProofingsModule,
    SampleProductModule,
    SampleCheckoutHistModule,
  },
  state,
  getters,
  mutations,
  actions
});
