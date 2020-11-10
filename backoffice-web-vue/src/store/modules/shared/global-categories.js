import http from '@/common/js/http';

const state = {
  categories: [],
};

const mutations = {
  categories: (state, categories) => state.categories = categories
};

const actions = {
  async getCategoriesData ({
    dispatch,
    commit,
    state
  }) {
    // 获取尺码数据
    const url = '/b2b/categories/cascaded';
    const response = await http.get(url);
    if (!response['errors'] && response instanceof Array) {
      commit('categories', response);
    }
  }
};

const getters = {
  categories: state => state.categories
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
