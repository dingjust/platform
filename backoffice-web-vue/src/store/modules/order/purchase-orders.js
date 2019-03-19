import http from '@/common/js/http';

const state = {
  statusOptions: [
    {text: '待付款', value: 'PENDING_PAYMENT'},
    {text: '生产中', value: 'IN_PRODUCTION'},
    {text: '待出库', value: 'WAIT_FOR_OUT_OF_STORE'},
    {text: '已出库', value: 'OUT_OF_STORE'},
    {text: '已完成', value: 'COMPLETED'},
    {text: '已取消', value: 'CANCELLED'}
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
    uniqueCode: '',
    requirementOrderCode: '',
    entries: [],
    remarks: '',
    deliveryAddress: {
      fullname: '',
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
    }
  },
  queryFormData: {
    productionOrderCode: '',
    requirementOrderCode: '',
    skuID: '',
    statuses: [],
    expectedDeliveryDateFrom: null,
    expectedDeliveryDateTo: null,
    createdDateFrom: null,
    createdDateTo: null,
    belongTos: [],
  }
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  statuses: (state, statuses) => state.statuses = statuses,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
};

const actions = {
  async search({dispatch, commit, state}, {keyword, statuses, page, size}) {
    commit('keyword', keyword);
    commit('statuses', statuses);
    if (page) {
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post('/b2b/orders/purchase', {
      skuID: state.keyword,
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

    const response = await http.post('/b2b/orders/purchase', query, {
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
