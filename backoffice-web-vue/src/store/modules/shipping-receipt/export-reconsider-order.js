import http from '@/common/js/http';

const state = {
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
  formData: {},
};

const mutations = {
  keyword: (state, keyword) => state.keyword = keyword,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  page: (state, page) => state.page = page,
  formData: (state, formData) => state.formData = formData,
};

const actions = {
  async search({
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

    // 设置筛选收货方
    query['receiveParty'] = companyCode;

    const response = await http.post(url, query, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    if (!response['errors']) {
      commit('page', response);
    }
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
