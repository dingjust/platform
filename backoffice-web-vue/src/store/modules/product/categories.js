import http from '@/common/js/http';

const state = {
  items: [], // 数据,
  formData: {
    id: null,
    code: '',
    name: '',
    group: '',
    description: '',
    parent: {
      code: '',
      name: ''
    }
  }
};

const mutations = {
  items: (state, items) => state.items = items
};

const actions = {
  async search({dispatch, commit, state}) {
    const response = await http.get('/b2b/categories/categories');

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('items', response);
    }
  },
  refresh({dispatch, commit, state}) {
    dispatch('search');
  }
};

const getters = {
  items: state => state.items
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
