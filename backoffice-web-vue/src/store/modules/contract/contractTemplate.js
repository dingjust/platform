import http from '@/common/js/http';

const state = {
  url: '',
  keyword: '',
  statuses: [],
  type:'',
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
    title: '',
    type: ''
  },
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  type: (state, type) => state.type = type,
  page: (state, page) => state.page = page,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
};

const actions = {
  async search({dispatch, commit, state}, {url, query, page, size}) {
    if (page !== null || page !== undefined) {
      commit('currentPageNumber', page);
    }
    if (size !== null || size !== undefined) {
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
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  type: state => state.type,
  queryFormData: state => state.queryFormData,
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
