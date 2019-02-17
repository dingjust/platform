import http from '@/common/js/http';

const state = {
  statusOptions: [
    {text: '待处理', value: 'WAIT_FOR_PROCESSING'},
    {text: '待确认', value: 'PENDING_APPROVAL'},
    {text: '已确认', value: 'APPROVED'},
    {text: '待分配', value: 'WAIT_FOR_ALLOCATION'},
    {text: '待出库', value: 'WAIT_FOR_OUT_OF_STORE'},
    {text: '已出库', value: 'OUT_OF_STORE'},
    {text: '已签收', value: 'COMPLETED'}
  ],
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
    name: '',
    description: '',
    depositPaid: false,
    depositAmount: 0,
    retainagePaid: false,
    retainageAmount: 0,
    entries: [],
    contracts: [],
    deliveryAddress: {
      fullname: '',
      title: {
        code: '',
        name: ''
      },
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
      line1: '',
      remarks: ''
    },
    details: {
      minorCategories: [],
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
      contactPerson: '',
      contactPhone: ''
    }
  },
  queryFormData: {
    code: '',
    skuID: '',
    statuses: [],
    expectedDeliveryDateFrom: null,
    expectedDeliveryDateTo: null,
    createdDateFrom: null,
    createdDateTo: null,
  }
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  statuses: (state, statuses) => state.statuses = statuses,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page
};

const actions = {
  async search({dispatch, commit, state}, {keyword, statuses, page, size}) {
    commit('keyword', keyword);
    commit('statuses', statuses);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post('/djbrand/requirementOrder', {
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
  async searchAdvanced({dispatch, commit, state}, {query, page, size}) {
    commit('queryFormData', query);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post('/djbrand/requirementOrder/advancedSearch', query, {
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

    dispatch('search', {keyword, statuses, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  keyword: state => state.keyword,
  statuses: state => state.statuses,
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
