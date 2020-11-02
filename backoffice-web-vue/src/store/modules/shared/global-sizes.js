import http from '@/common/js/http';

const state = {
  sizes: []
};

const mutations = {
  sizes: (state, sizes) => state.sizes = sizes
};

const actions = {
  async getSizesData ({
    dispatch,
    commit,
    state
  }) {
    // 获取尺码数据
    const url = '/b2b/sizes/all';
    const response = await http.get(url);
    console.log(response);
    if (!response['errors'] && response instanceof Array) {
      commit('sizes', response);
    }
  }
};

const getters = {
  sizes: state => state.sizes
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
