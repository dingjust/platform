import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

import {
  UsersModule,
  ColorsModule,
  SizesModule,
  StylesModule,
  CategoriesModule,
  FabricProductsModule
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
    UsersModule: UsersModule,
    ColorsModule: ColorsModule,
    SizesModule: SizesModule,
    StylesModule: StylesModule,
    CategoriesModule: CategoriesModule,
    FabricProductsModule: FabricProductsModule
  },
  state,
  getters,
  mutations,
  actions
});
