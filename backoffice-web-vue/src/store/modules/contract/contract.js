import http from '@/common/js/http';

const state = {
  url: '',
  keyword: '',
  statuses: '',
  currentPageNumber: 0,
  currentPageSize: 10,
  page: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  queryFormData: {},
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  state:(state) => state,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
};

const actions = {
  async search({dispatch, commit, state}, {url, keyword, statuses, page, size}) {
    console.log('2222222222'+statuses)
    commit('url', url);
    commit('keyword', keyword);
    commit('state', statuses);
    if (page||page===0) {
      commit('currentPageNumber', page);
    }
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword,
      state: statuses
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  refresh({dispatch, commit, state}) {
    const keyword = state.keyword;
    const statuses = state.statuses;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url: state.url, keyword,statuses, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  statuses: state => state.statuses,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  isAdvancedSearch: state => state.isAdvancedSearch,
  page: state => state.page,
  queryFormData: state => state.queryFormData,
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
