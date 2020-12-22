import http from '@/common/js/http';

const state = {
  keyword: '',
  currentPageNumber: 0,
  currentPageSize: 8,
  page: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  queryFormData: {
    type: '',
    keyword: ''
  },
  formData: {
    id: null,
    name: '',
    payPlanType: 'PHASEONE',
    isHaveDeposit: false,
    remarks: '',
    payPlanItems:[]
  },
  editFormData: {
    id: null,
    name: '',
    payPlanType: '',
    isHaveDeposit: false,
    remarks: '',
    payPlanItems:[]
  },
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page,
  setQueryFormData: (state, query) => state.queryFormData = query,
  setFormData: (state, data) => state.formData = data,
  setEditFormData: (state, data) => state.editFormData = data,
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
  async searchAdvanced ({dispatch, commit, state}, {url, page, size}) {
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, state.queryFormData, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    if (!response['errors']) {
      commit('page', response);
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
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  orderPage: state => state.orderPage,
  queryFormData: state => state.queryFormData,
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
