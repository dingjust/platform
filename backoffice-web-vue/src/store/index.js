import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

import users from './modules/user/users';
import colors from './modules/product/colors';
import sizes from './modules/product/sizes';
import styles from './modules/product/styles';

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
    UsersModule: users,
    ColorsModule: colors,
    SizesModule: sizes,
    StylesModule: styles,
  },
  state,
  getters,
  mutations,
  actions
})
