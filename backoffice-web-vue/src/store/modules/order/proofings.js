import http from '@/common/js/http';

const state = {
  url: '',
  keyword: '',
  isAdvancedSearch: false,
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
    quoteRef: '',
    belongTo: {
      uid: '',
      name: ''
    },
    salesApplication: 'BELOW_THE_LINE',
    companyOfSeller: '',
    contactPersonOfSeller: '',
    contactOfSeller: '',
    expectedDeliveryDate: null,
    deposit: 0,
    depositPaid: false,
    depositPaidDate: null,
    balance: 0,
    balancePaid: false,
    balancePaidDate: null,
    machiningType: null,
    invoiceNeeded: false,
    proofingNeeded: false,
    uniqueCode: '',
    requirementOrderCode: '',
    unitPrice: 0,
    remarks: '',
    deliveryAddress: {
      id: null,
      fullname: '',
      cellphone: '',
      region: {
        isocode: '',
        name: ''
      },
      city: {
        code: '',
        name: ''
      },
      cityDistrict: {
        code: '',
        name: ''
      },
      line1: ''
    },
    consignment: {
      trackingID: '',
      carrierDetails: {
        code: '',
        name: ''
      },
      isOffline: false
    }
  },
  queryFormData: {
    keyword: '',
    brandOperatorName: '',
    factoryOperatorName: '',
    brandReferenceName: '',
    factoryReferenceName: '',
    categories: [],
    statuses: []
  },
  addressFormData: {
    id: null,
    fullname: '',
    cellphone: '',
    region: {
      isocode: '',
      name: ''
    },
    city: {
      code: '',
      name: ''
    },
    cityDistrict: {
      code: '',
      name: ''
    },
    line1: ''
  },
  consignmentFormData: {
    trackingID: '',
    carrierDetails: {
      code: '',
      name: ''
    }
  },
  categories: []
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
  keyword: (state, keyword) => state.keyword = keyword,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page,
  categories: (state, categories) => state.categories = categories
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('url', url);
    commit('keyword', keyword);
    commit('isAdvancedSearch', false);
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
    commit('url', url);
    commit('queryFormData', query);
    commit('isAdvancedSearch', true);
    if (page || page === 0) {
      commit('currentPageNumber', page);
    }

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
  refresh ({dispatch, commit, state}) {
    const keyword = state.keyword;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url: state.url, keyword, page: currentPageNumber, size: currentPageSize});
  },
  clearQueryFormData ({dispatch, commit, state}) {
    commit('queryFormData', {
      keyword: '',
      brandOperatorName: '',
      factoryOperatorName: '',
      brandReferenceName: '',
      belongToName: [],
      categories: [],
      statuses: []
    });
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  queryFormData: state => state.queryFormData,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  isAdvancedSearch: state => state.isAdvancedSearch,
  categories: state => state.categories
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
