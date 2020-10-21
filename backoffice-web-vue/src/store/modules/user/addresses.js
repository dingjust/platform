import http from '@/common/js/http';

const getDefaultState = () => {
  return {
    url: '',
    results: [],
    formData: {
      id: null,
      fullname: '',
      cellphone: '',
      region: {
        isocode: '',
        name: ''
      },
      city: {
        code: '',
        name: ''
      },
      cityDistrict: {
        code: '',
        name: ''
      },
      line1: '',
      defaultAddress: false
    }
  }
}

const state = getDefaultState();

const mutations = {
  url: (state, url) => state.url = url,
  results: (state, results) => state.results = results,
  resetModuleState (state) {
    Object.assign(state, getDefaultState())
  }
};

const actions = {
  async search ({dispatch, commit, state}, {url}) {
    commit('url', url);

    const response = await http.get(url);

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('results', response);
    }
  },
  refresh ({dispatch, commit, state}) {
    dispatch('search', {url: state.url});
  },
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
  }
};

const getters = {
  url: state => state.url,
  results: state => state.results
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
