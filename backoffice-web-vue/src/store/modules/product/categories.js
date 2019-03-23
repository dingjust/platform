import http from '@/common/js/http';

const state = {
  items: [], // 数据,
  formData: {
    id: null,
    code: '',
    name: '',
    group: '',
    description: '',
    thumbnail:{},
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
  async search({dispatch, commit, state},{url}) {
    const response = await http.get(url);

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('items', response);
    }
  },
  refresh({dispatch, commit, state},{url}) {
    dispatch('search',{url});
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
