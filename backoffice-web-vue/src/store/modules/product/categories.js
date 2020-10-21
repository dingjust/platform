import http from '@/common/js/http';

const getDefaultState = () => {
  return {
    items: [], // 数据,
    formData: {
      id: null,
      code: '',
      name: '',
      group: '',
      description: '',
      thumbnail: {},
      parent: {
        code: '',
        name: ''
      }
    }
  }
}

const state = getDefaultState();

const mutations = {
  items: (state, items) => state.items = items,
  resetModuleState (state) {
    Object.assign(state, getDefaultState())
  }
};

const actions = {
  async search ({dispatch, commit, state}, {url}) {
    const response = await http.get(url);

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('items', response);
    }
  },
  refresh ({dispatch, commit, state}, {url}) {
    dispatch('search', {url});
  },
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
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
