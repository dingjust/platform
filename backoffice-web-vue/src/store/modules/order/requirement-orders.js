import http from '@/common/js/http';

const state = {
  url: '',
  statusOptions: [
    {text: '报价中', value: 'PENDING_QUOTE'},
    {text: '已完成', value: 'COMPLETED'},
    {text: '已失效', value: 'CANCELLED'},
  ],
  keyword: '',
  statuses: [],
  isAdvancedSearch: false,
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
    details: {
      pictures: [],
      category: {
        code: '',
        name: ''
      },
      majorCategory: {
        code: '',
        name: ''
      },
      expectedMachiningQuantity: 0,
      machiningType: null,
      expectedDeliveryDate: null,
      maxExpectedPrice: 0,
      invoiceNeeded: false,
      samplesNeeded: false,
      proofingNeeded: false,
      contactPerson: '',
      contactPhone: '',
      productiveOrientations: []
    },
    attachments: [],
    labels: []
  },
  queryFormData: {
    code: '',
    skuID: '',
    statuses: [],
    expectedDeliveryDateFrom: null,
    expectedDeliveryDateTo: null,
    createdDateFrom: null,
    createdDateTo: null,
  },
  quoteFormData: {
    id: null,
    code: '',
    requirementOrder: null,
    unitPriceOfFabric: 0,
    unitPriceOfExcipients: 0,
    unitPriceOfProcessing: 0,
    costOfOther: 0,
    costOfSamples: 0,
    expectedDeliveryDate: null,
    remarks: null,
    attachments: [],
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
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
};

const actions = {
  async search({dispatch, commit, state}, {url, keyword, statuses, page, size}) {
    commit('url', url);
    commit('keyword', keyword);
    commit('statuses', statuses);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      code: state.keyword,
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
  async searchAdvanced({dispatch, commit, state}, {url, query, page, size}) {
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
  refresh({dispatch, commit, state}) {
    const keyword = state.keyword;
    const statuses = state.statuses;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url: state.url, keyword, statuses, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  statuses: state => state.statuses,
  isAdvancedSearch: state => state.isAdvancedSearch,
  statusOptions: state => state.statusOptions,
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
