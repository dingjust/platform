import http from '@/common/js/http';

const state = {
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
};

const mutations = {
  url: (state, url) => state.url = url,
  results: (state, results) => state.results = results
};

const actions = {
  async search({dispatch, commit, state}, {url}) {
    commit('url', url);

    const response = await http.get(url);

    if (!response['errors']) {
      commit('results', response);
    }
  },
  refresh({dispatch, commit, state}) {
    dispatch('search', {url: state.url});
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
