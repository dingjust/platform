import http from '@/common/js/http';

const state = {
  url: '',
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
  formData: {
  },
  queryFormData: {
    keyword: ''
  }
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  formData: (state, formData) => state.formData = formData,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page,
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('url', url);
    commit('keyword', keyword);
    if (page || page === 0) {
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    commit('queryFormData', query);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, query, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  formData: state => state.formData,
  queryFormData: state => state.queryFormData,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
