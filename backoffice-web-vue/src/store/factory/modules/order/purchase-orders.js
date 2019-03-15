import http from '@/common/js/http';

const state = {
  statusOptions: [
    {text: '待分配', value: 'WAIT_FOR_ALLOCATION'},
    {text: '备料中', value: 'WAIT_FOR_PURCHASE'},
    {text: '待裁剪', value: 'PENDING_CUTTING'},
    {text: '裁剪中', value: 'CUTTING'},
    {text: '车缝中', value: 'STITCHING'},
    {text: '待验货', value: 'QC'},
    {text: '待发货', value: 'PENDING_DELIVERY'},
    {text: '已发货', value: 'DELIVERING'},
    {text: '已完成', value: 'DELIVERY_COMPLETED'}
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
    order: {
      id: '',
      code: '',
      entries: []
    },
    assignedTo: {
      uid: '',
      name: ''
    },
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
    consignmentEntries: []
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
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page
};

const actions = {
  async search({dispatch, commit, state}, {keyword, statuses, page, size}) {
    commit('keyword', keyword);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.get('/b2b/orders/purchase', {
      code: state.keyword
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
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {keyword, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  keyword: state => state.keyword,
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
