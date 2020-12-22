import http from '@/common/js/http';

const state = {
  url: '',
  keyword: '',
  statuses: [],
  currentPageNumber: 0,
  currentPageSize: 10,
  page: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  queryFormData: {
    'code': '',
    'requirementOrderRef': '',
    'brandName': '',
    'factoryName': '',
    'states': []
  }
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
};

const actions = {
  async search({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('url', url);
    commit('keyword', keyword);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    commit('url', url);
    commit('queryFormData', query);
    if (page || page === 0) {
      commit('currentPageNumber', page);
    }
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, query, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });
    if (!response['errors']) {
      commit('page', response);
    }
  },
  refresh({dispatch, commit, state}) {
    const keyword = state.keyword;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url: state.url, keyword, page: currentPageNumber, size: currentPageSize});
  },
  clearQueryFormData({dispatch, commit, state}) {
    commit('queryFormData', {
      'code': '',
      'requirementOrderRef': '',
      'brandName': '',
      'factoryName': '',
      'states': []
    });
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  queryFormData: state => state.queryFormData,
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
