import http from '@/common/js/http';

const state = {
  keyword: '',
  currentPageNumber: 0,
  currentPageSize: 10,
  ordersPageNumber: 0,
  ordersPageSize: 10,
  page: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  orderPage: {
    number: 0, // 当前页，从0开始
    size: 8, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  queryFormData: {
    type: '',
    keyword: ''
  },
  ordersQueryFormData: {
    belongTos: null,
    purchasers: null
  },
  formData: {
    id: null,
    name: '',
    contactPhone: '',
    contactPerson: '',
    taxNumber: '',
    bankOfDeposit: '',
    bankAccount: '',
    partner: null,
    type: null,
    category: null,
    detailedIdentity: '',
    payPlan: null,
    remarks: ''
  },
  editFormData: {
    id: null,
    name: '',
    contactPhone: '',
    contactPerson: '',
    taxNumber: '',
    bankOfDeposit: '',
    bankAccount: '',
    partner: null,
    type: null,
    category: null,
    detailedIdentity: '',
    payPlan: null,
    remarks: ''
  },
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  setOrdersPageNumber: (state, ordersPageNumber) => state.ordersPageNumber = ordersPageNumber,
  setOrdersPageSize: (state, ordersPageSize) => state.ordersPageSize = ordersPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page,
  orderPage: (state, page) => state.orderPage = page,
  setQueryFormData: (state, query) => state.queryFormData = query,
  setQueryFormDataKeyword: (state, keyword) => state.queryFormData.keyword = keyword,
  setOrdersQueryFormData: (state, query) => state.ordersQueryFormData = query,
  setFormData: (state, data) => state.formData = data,
  setEditFormData: (state, data) => state.editFormData = data
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('keyword', keyword);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.get(url, {
      keyword: state.keyword
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

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

    const response = await http.post(url, state.queryFormData, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchOrdersAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    const response = await http.post(url, state.ordersQueryFormData, {
      page: state.ordersPageNumber,
      size: state.ordersPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('orderPage', response);
    }
  },
  refresh ({dispatch, commit, state}) {
    const keyword = state.keyword;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {keyword, page: currentPageNumber, size: currentPageSize});
  },
  //清空订单列表数据
  clearOrderPageData ({dispatch, commit, state}) {
    commit('orderPage', {
      number: 0, // 当前页，从0开始
      size: 8, // 每页显示条数
      totalPages: 1, // 总页数
      totalElements: 0, // 总数目数
      content: [] // 当前页数据
    });
  },
  clearFormData({dispatch, commit, state}){
    commit('setFormData', {
      id: null,
      name: '',
      contactPhone: '',
      contactPerson: '',
      taxNumber: '',
      bankOfDeposit: '',
      bankAccount: '',
      partner: null,
      type: null,
      category: null,
      detailedIdentity: '',
      payPlan: null,
      remarks: ''
    });
    console.log(state.formData);
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  ordersPageNumber: state => state.ordersPageNumber,
  ordersPageSize: state => state.ordersPageSize,
  page: state => state.page,
  orderPage: state => state.orderPage,
  queryFormData: state => state.queryFormData,
  ordersQueryFormData: state => state.ordersQueryFormData,
  formData: state => state.formData,
  editFormData: state => state.editFormData,
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
