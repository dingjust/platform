import http from '@/common/js/http';

const getDefaultState = () => {
  return {
    url: '',
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
      progresses: [],
      partyACompany: {},
      partyBCompany: {},
      code: '',
      status: '',
      skuID: '',
      currentPhase: '',
      machiningType: 'LABOR_AND_MATERIAL',
      expectedDeliveryDate: '',
      personInCharge: {},
      orderStatus: '',
      colorSizeEntries: [],
      product: {

      },
      belongTo: {}
    },
    queryFormData: {
      keyword: '',
      statuses: '',
      expectedDeliveryDateFrom: '',
      expectedDeliveryDateTo: '',
      operatorName: ''
    },
    detailData: {

    },
    colorSizeData: [],
    currentProgress: ''
  }
}

const state = getDefaultState();

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  statuses: (state, statuses) => state.statuses = statuses,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
  detailData: (state, detailData) => state.detailData = detailData,
  formData: (state, formData) => state.formData = formData,
  colorSizeData: (state, colorSizeData) => state.colorSizeData = colorSizeData,
  currentProgress: (state, currentProgress) => state.currentProgress = currentProgress,
  resetModuleState (state) {
    Object.assign(state, getDefaultState())
  }
};

const actions = {
  async search ({
    dispatch,
    commit,
    state
  }, {
    url,
    keyword,
    statuses,
    page,
    size
  }) {
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
  async searchAdvanced ({
    dispatch,
    commit,
    state
  }, {
    url,
    query,
    page,
    size
  }) {
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
  refresh ({
    dispatch,
    commit,
    state
  }) {
    const keyword = state.keyword;
    const statuses = state.statuses;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {
      url: state.url,
      keyword,
      statuses,
      page: currentPageNumber,
      size: currentPageSize
    });
  },
  async getDetail ({
    dispatch,
    commit,
    state
  }, code) {
    const url = '/b2b/sheets/progress/work/' + code;
    const result = await http.get(url);
    if (!result['errors']) {
      commit('formData', result.data);
    }
  },
  async refreshDetail ({
    dispatch,
    commit,
    state
  }) {
    // const url = '/b2b/orders/production/work/' + state.formData.code;
    const url = '/b2b/sheets/progress/work/' + state.formData.code;
    const result = await http.get(url);
    if (!result['errors']) {
      commit('formData', result.data);
    }
  },
  async setDetail ({
    dispatch,
    commit,
    state
  }, data) {
    if (data != null) {
      commit('formData', data);
    }
  },
  clearFormData ({
    dispatch,
    commit,
    state
  }) {
    commit('formData', {
      id: null,
      progresses: [],
      partyACompany: {},
      partyBCompany: {},
      code: '',
      status: '',
      skuID: '',
      currentPhase: '',
      machiningType: 'LABOR_AND_MATERIAL',
      expectedDeliveryDate: '',
      personInCharge: {},
      orderStatus: '',
      colorSizeEntries: [],
      product: {

      },
      belongTo: {}
    });
  },
  clearQueryFormData ({
    dispatch,
    commit,
    state
  }) {
    commit('queryFormData', {
      keyword: '',
      statuses: '',
      expectedDeliveryDateFrom: '',
      expectedDeliveryDateTo: '',
      operatorName: ''
    });
  },
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  statuses: state => state.statuses,
  isAdvancedSearch: state => state.isAdvancedSearch,
  queryFormData: state => state.queryFormData,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  detailData: state => state.detailData,
  formData: state => state.formData,
  colorSizeData: state => state.colorSizeData
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
