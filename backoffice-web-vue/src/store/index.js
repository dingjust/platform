import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

const modulesFiles = require.context('./modules', true, /\.js$/)

// 自动化导入文件
const modules = {};
modulesFiles.keys().forEach((key) => {
  // 通过 modulesFiles(key)导出文件内容
  const mod = modulesFiles(key);
  const path = key.replace(/^\.\/(.*)\.\w+$/, '$1');
  let strs = path.split('/');
  // 生产Module名
  const moduleName = generateModulesName(strs[strs.length - 1]) + 'Module';
  modules[moduleName] = mod.__esModule && mod.default ? mod.default : mod
});
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
  },
  resetAllState ({
    dispatch,
    commit,
    state
  }) {
    try {
      for (const key in modules) {
        if (modules.hasOwnProperty(key)) {
          const element = modules[key];
          if (element.actions && element.actions.hasOwnProperty('resetState')) {
            dispatch(key + '/resetState');
          }
        }
      }
    } catch (error) {

    }
    dispatch('resetState');
  }
};

export default new Vuex.Store({
  modules,
  state,
  getters,
  mutations,
  actions
});

function generateModulesName (str) {
  // 转驼峰式
  let result = str.replace(/([^-])(?:-+([^-]))/g, function ($0, $1, $2) {
    return $1 + $2.toUpperCase();
  });
  // 首字母大写
  result = result.replace(str[0], str[0].toUpperCase());
  return result;
}
