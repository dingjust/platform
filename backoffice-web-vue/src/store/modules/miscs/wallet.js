import http from '@/common/js/http';

const state = {
  keyword: '',
  isAdvancedSearch: false,
  groups: ['B2B'],
  currentPageNumber: 0,
  currentPageSize: 10,
  walletData: null,
  page: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  amountFlowPage: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  formData: {
    id: null,
    index: '',
    name: '',
    description: '',
    group: 'B2B',
    infos: []
  },
  queryFormData: {
    company: '',
    flowSources: [],
    amountFlowTypes: [],
    amountStatus: [],
    createdDateFrom: null,
    createdDateTo: null
  }
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page,
  amountFlowPage: (state, page) => state.amountFlowPage = page,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
  walletData: (state, walletData) => state.walletData = walletData,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('keyword', keyword);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword,
      groups: ['B2B']}, {
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
    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAdvancedByAmountFlow ({dispatch, commit, state}, {url, query, page, size}) {
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
      commit('amountFlowPage', response);
    }
  },
  refresh ({dispatch, commit, state}, {url}) {
    const keyword = state.keyword;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url, keyword, page: currentPageNumber, size: currentPageSize});
  },
  async getWallet ({dispatch, commit, state}, {url}) {
    const response = await http.get(url);
    if (!response['errors']) {
      commit('walletData', response);
    }
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  isAdvancedSearch: state => state.isAdvancedSearch,
  walletData: state => state.walletData,
  queryFormData: state => state.queryFormData,
  amountFlowPage: state => state.amountFlowPage
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
