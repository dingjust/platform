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
  formData: {
    id: null,
    code: '',
    name: '',
    company: {
      uid: '',
      name: ''
    },
    pictures: []
  },
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page
};

const actions = {
  async search({dispatch, commit, state}, {url,keyword, page, size}) {
    commit('keyword', keyword);
    if (page) {
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }
    const response = await http.post(url,{keyword: state.keyword}, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    if (!response['errors']) {
      commit('page', response);
    }
  },
  refresh({dispatch, commit, state},{url}) {
    const keyword = state.keyword;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;
    dispatch('search', {url,keyword, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
