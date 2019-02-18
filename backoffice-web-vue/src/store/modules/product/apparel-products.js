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
    price: 0.00,
    suggestedPrice: 0.00,
    price1: 0.00,
    price2: 0.00,
    price3: 0.00,
    categories: [],
    staircasePrices: [],
    startingAmount: '',
    skuID: '',
    year: '',
    season: '',
    placeOfOrigin: '',
    brand: '',
    style: {
      id: null,
      code: '',
      name: ''
    },
    material: '',
    content: '',
    belongTo: {
      uid: '',
      name: ''
    },
    postageFree: true,
    gramWeight: 0.0,
    variants: []
  },
  queryFormData: {
    skuID: '',
    name: '',
    approvalStatuses: [],
    categories: [],
    belongTos: []
  }
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page
};

const actions = {
  async search({dispatch, commit, state}, {keyword, page, size}) {
    commit('keyword', keyword);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.get('/djbackoffice/product', {
      code: state.keyword,
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAdvanced({dispatch, commit, state}, {query, page, size}) {
    commit('queryFormData', query);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post('/djbackoffice/product/advancedSearch', query, {
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
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {keyword, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  keyword: state => state.keyword,
  queryFormData: state => state.queryFormData,
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
