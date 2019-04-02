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
    quantity: '',
    expectedReturningDate: '',
    relatedParty: '',
    contact: '',
    type: '',
    state: '',
    remarks: '',
    images: [],
    company: {
      uid: '',
      name: ''
    }
  },
  queryFormData: {
    id: null,
    code: '',
    name: '',
    quantity: '',
    expectedReturningDate: '',
    relatedParty: '',
    contact: '',
    type: '',
    state: '',
    remarks: '',
    images: [],
    company: {
      uid: '',
      name: ''
    }
  }
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  sampleCheckoutType: (state, sampleCheckoutType) => state.sampleCheckoutType = sampleCheckoutType,
  returnState: (state, returnState) => state.returnState = returnState,
  keyword: (state, keyword) => state.keyword = keyword,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page
};

const actions = {
  async search({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('keyword', keyword);
    if (page) {
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
    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAdvanced({dispatch, commit, state}, {url, query, page, size}) {
    commit('url', url);
    commit('queryFormData', query);
    commit('currentPageNumber', page);
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
  refresh({dispatch, commit, state},{url}) {
    const keyword = state.keyword;
    const queryFormData = state.queryFormData;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;
    dispatch('search', {url,keyword, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  keyword: state => state.keyword,
  queryFormData: state => state.queryFormData,
  sampleCheckoutType: state => state.sampleCheckoutType,
  returnState: state => state.returnState,
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
