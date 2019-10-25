import http from '@/common/js/http';

const state = {
  url: '',
  keyword: '',
  statuses: [],
  isAdvancedSearch: false,
  currentPageNumber: 0,
  currentPageSize: 10,
  quoteCurrentPageNumber: 0,
  quoteCurrentPageSize: 10,
  cooperatorCurrentPageNumber: 0,
  cooperatorCurrentPageSize: 10,
  factoryCurrentPageNumber: 0,
  factoryCurrentPageSize: 10,
  factories: [],
  phoneNumbers: [],
  page: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  quotePage: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  factoryPage: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  cooperatorPage: {
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
      category: null,
      majorCategory: null,
      expectedMachiningQuantity: '',
      machiningType: 'LABOR_AND_MATERIAL',
      expectedDeliveryDate: null,
      maxExpectedPrice: '',
      invoiceNeeded: false,
      proofingNeeded: false,
      contactPerson: '',
      contactPhone: '',
      productiveOrientations: [],
      publishingMode: 'PUBLIC',
      effectiveDays: '90',
      salesMarket: []
    },
    attachments: [],
    labels: [],
    cancelledDate: ''
  },
  queryFormData: {
    code: '',
    skuID: '',
    statuses: [],
    expectedDeliveryDateFrom: null,
    expectedDeliveryDateTo: null,
    createdDateFrom: null,
    createdDateTo: null

  },
  quoteQueryFormData: {
    requirementOrderRef: ''
  },
  factoryQueryFormData: {
    keyword: '',
    adeptAtCategories: [],
    productiveOrientations: [],
    populationScales: [],
    starLevel: null,
    machiningTypes: [],
    categories: [],
    industrialClusters: [],
    labels: []
  },
  cooperatorQueryFormData: {
    type: '',
    keyword: ''
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
    attachments: []
  },
  categories: [],
  majorCategories: [],
  regions: []
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  quoteCurrentPageNumber: (state, quoteCurrentPageNumber) => state.quoteCurrentPageNumber = quoteCurrentPageNumber,
  quoteCurrentPageSize: (state, quoteCurrentPageSize) => state.quoteCurrentPageSize = quoteCurrentPageSize,
  cooperatorCurrentPageNumber: (state, cooperatorCurrentPageNumber) => state.cooperatorCurrentPageNumber = cooperatorCurrentPageNumber,
  cooperatorCurrentPageSize: (state, cooperatorCurrentPageSize) => state.cooperatorCurrentPageSize = cooperatorCurrentPageSize,
  factoryCurrentPageNumber: (state, factoryCurrentPageNumber) => state.factoryCurrentPageNumber = factoryCurrentPageNumber,
  factoryCurrentPageSize: (state, factoryCurrentPageSize) => state.factoryCurrentPageSize = factoryCurrentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  statuses: (state, statuses) => state.statuses = statuses,
  formData: (state, formData) => state.formData = formData,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  quoteQueryFormData: (state, quoteQueryFormData) => state.quoteQueryFormData = quoteQueryFormData,
  cooperatorQueryFormData: (state, cooperatorQueryFormData) => state.cooperatorQueryFormData = cooperatorQueryFormData,
  factoryQueryFormData: (state, factoryQueryFormData) => state.factoryQueryFormData = factoryQueryFormData,
  page: (state, page) => state.page = page,
  quotePage: (state, quotePage) => state.quotePage = quotePage,
  cooperatorPage: (state, cooperatorPage) => state.cooperatorPage = cooperatorPage,
  factoryPage: (state, factoryPage) => state.factoryPage = factoryPage,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
  categories: (state, categories) => state.categories = categories,
  majorCategories: (state, majorCategories) => state.majorCategories = majorCategories,
  regions: (state, regions) => state.regions = regions
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, statuses, page, size}) {
    commit('url', url);
    commit('keyword', keyword);
    commit('statuses', statuses);
    commit('currentPageNumber', page);
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
    commit('url', url);
    commit('queryFormData', query);
    if (page) {
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
  async searchQuotesAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    commit('quoteQueryFormData', query);
    if (page) {
      commit('quoteCurrentPageNumber', page);
    }
    if (size) {
      commit('quoteCurrentPageSize', size);
    }

    const response = await http.post(url, query, {
      page: state.quoteCurrentPageNumber,
      size: state.quoteCurrentPageSize
    });
    console.log(response);
    if (!response['errors']) {
      commit('quotePage', response);
    }
  },
  async searchCooperatorsAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    commit('cooperatorQueryFormData', query);
    if (page) {
      commit('cooperatorCurrentPageNumber', page);
    }
    if (size) {
      commit('cooperatorCurrentPageSize', size);
    }

    const response = await http.post(url, query, {
      page: state.cooperatorCurrentPageNumber,
      size: state.cooperatorCurrentPageSize
    });
    console.log(response);
    if (!response['errors']) {
      commit('cooperatorPage', response);
    }
  },
  async searchFactoriesAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    commit('factoryQueryFormData', query);
    if (page) {
      commit('factoryCurrentPageNumber', page);
    }
    if (size) {
      commit('factoryCurrentPageSize', size);
    }

    const response = await http.post(url, query, {
      page: state.factoryCurrentPageNumber,
      size: state.factoryCurrentPageSize
    });
    console.log(response);
    if (!response['errors']) {
      commit('factoryPage', response);
    }
  },
  refresh ({dispatch, commit, state}) {
    const keyword = state.keyword;
    const statuses = state.statuses;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url: state.url, keyword, statuses, page: currentPageNumber, size: currentPageSize});
  },
  clearFormData ({dispatch, commit, state}) {
    commit('formData', {
      id: null,
      code: '',
      details: {
        pictures: [],
        category: null,
        majorCategory: null,
        expectedMachiningQuantity: '',
        machiningType: 'LABOR_AND_MATERIAL',
        expectedDeliveryDate: null,
        maxExpectedPrice: '',
        invoiceNeeded: false,
        proofingNeeded: false,
        contactPerson: '',
        contactPhone: '',
        productiveOrientations: [],
        publishingMode: 'PUBLIC',
        effectiveDays: '90',
        salesMarket: []
      },
      attachments: [],
      labels: [],
      cancelledDate: ''
    });
  },
  clearFactoryQueryFormData ({dispatch, commit, state}) {
    commit('factoryQueryFormData', {
      keyword: '',
      adeptAtCategories: [],
      productiveOrientations: [],
      populationScales: [],
      starLevel: null,
      machiningTypes: [],
      categories: [],
      industrialClusters: [],
      labels: []
    });
  },
  clearCooperatorQueryFormData ({dispatch, commit, state}) {
    commit('cooperatorQueryFormData', {
      keyword: '',
      type: ''
    });
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  statuses: state => state.statuses,
  isAdvancedSearch: state => state.isAdvancedSearch,
  queryFormData: state => state.queryFormData,
  quoteQueryFormData: state => state.quoteQueryFormData,
  factoryQueryFormData: state => state.factoryQueryFormData,
  cooperatorQueryFormData: state => state.cooperatorQueryFormData,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  quotePage: state => state.quotePage,
  factoryPage: state => state.factoryPage,
  cooperatorPage: state => state.cooperatorPage,
  formData: state => state.formData,
  categories: state => state.categories,
  majorCategories: state => state.majorCategories,
  regions: state => state.regions
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
