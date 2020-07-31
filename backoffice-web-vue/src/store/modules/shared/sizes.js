import http from '@/common/js/http';

const state = {
  sizes: [],
};

const mutations = {
  sizes: (state, sizes) => state.sizes = sizes,
};

const actions = {
  async getData({
    dispatch,
    commit,
    state
  }) {
    //获取尺码数据
    const url = this.apis().getAllSizes();          
    const response = await http.get(url);
    if (!response['errors']) {
      commit('sizes', response);
    }
  },
};

const getters = {
  sizes: state => {
    state.sizes
  },
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
