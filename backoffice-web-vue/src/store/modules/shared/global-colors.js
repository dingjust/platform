import http from '@/common/js/http';

const state = {
  colors: [],
};

const mutations = {
  colors: (state, colors) => state.colors = colors
};

const actions = {
  async getcolorsData ({
    dispatch,
    commit,
    state
  }) {
    // 获取尺码数据
    const url = '/b2b/colors/all';
    const response = await http.get(url, {}, true);
    if (!response['errors'] && response instanceof Array) {
      commit('colors', response);
    }
  },
};

const getters = {
  colors: state => state.colors
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
