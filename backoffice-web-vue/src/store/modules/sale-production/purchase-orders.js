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
  formData: {
    id: null,
    code: '',
    orderCode: '',
    skuID: '',
    completedDateFrom: '',
    completedDateTo: '',
    creator: {
      id: '',
      name: ''
    },
    approver: {
      id: '',
      name: ''
    },
    isApproval: false,
    purchaser: {
      id: '',
      name: ''
    },
    taxIncluded: false,
    qualityLevel: '',
    shippingAddress: {},
    purchaseDetails: [{
      name: '纯棉磨毛斜布',
      code: 'CTO123456789',
      spec: '100×100cm',
      unit: '厘米',
      property: '面料',
      unitQuantity: 1000,
      color: '黑色',
      sampleColor: '金色',
      orderQuantity: 10000000,
      materialQuantity: 100000000,
      floatQuantity: 1000000,
      quantity: 1000000000,
      countQuantity: 100000000,
      taxPrice: 123222.011,
      totalPrice: 129301209312.22,
      expected: 122222222222
    }]
  },
  queryFormData: {
    keyword: '',
    name: '',
    cooperator: '',
    status: ''
  }
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  statuses: (state, statuses) => state.statuses = statuses,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page,
  formData: (state, formData) => state.formData = formData
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, statuses, page, size}) {
    console.log(keyword + 'test' + page + 'test' + size);
    commit('url', url);
    commit('keyword', keyword);
    commit('statuses', statuses);
    if (page || page === 0) {
      console.log(page);
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword,
      statuses: state.statuses
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
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  statuses: state => state.statuses,
  queryFormData: state => state.queryFormData,
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
