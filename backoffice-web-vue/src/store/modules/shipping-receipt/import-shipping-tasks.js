import http from '@/common/js/http';

const getDefaultState = () => {
  return {
    keyword: '',
    currentPageNumber: 0,
    currentPageSize: 10,
    page: {
      number: 0, // 当前页，从0开始
      size: 10, // 每页显示条数
      totalPages: 1, // 总页数
      totalElements: 0, // 总数目数
      content: [] // 当前页数据
    },
    formData: {}
  }
}

const state = getDefaultState();

const mutations = {
  keyword: (state, keyword) => state.keyword = keyword,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  page: (state, page) => state.page = page,
  formData: (state, formData) => state.formData = formData,
  resetModuleState (state) {
    Object.assign(state, getDefaultState())
  }
};

const actions = {
  async search ({
    dispatch,
    commit,
    state
  }, {
    url,
    keyword,
    page,
    size,
    companyCode
  }) {
    commit('keyword', keyword);
    if (page || page === 0) {
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword,
      shipParty: companyCode
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAdvanced ({
    dispatch,
    commit,
    state
  }, {
    url,
    query,
    page,
    size,
    companyCode
  }) {
    if (page || page === 0) {
      commit('currentPageNumber', page);
    }
    if (size) {
      commit('currentPageSize', size);
    }

    // 设置筛选发货方
    query['shipParty'] = companyCode;

    const response = await http.post(url, query, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    if (!response['errors']) {
      commit('page', response);
    }
  },
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  formData: state => state.formData
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
