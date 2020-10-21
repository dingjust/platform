import http from '@/common/js/http';

const getDefaultState = () => {
  return {
    url: '',
    keyword: '',
    status: [],
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
      code: '',
      entries: [

      ],
      id: ''
    },
    queryFormData: {
      code: '',
      skuID: '',
      state: '',
      keywords: '',
      productionLeaderName: '',
      cooperator: '',
      categories: [],
      productionWorkOrder: ''
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
    detailData: {

    }
  }
}

const state = getDefaultState();

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  status: (state, status) => state.status = status,
  formData: (state, formData) => state.formData = formData,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
  detailData: (state, detailData) => state.detailData = detailData,
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
    status,
    page,
    size
  }) {
    console.log(keyword + 'test' + page + 'test' + size);
    commit('url', url);
    commit('keyword', keyword);
    commit('status', status);
    if (page || page === 0) {
      console.log(page);
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword,
      status: state.status
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
    const status = state.status;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {
      url: state.url,
      keyword,
      status,
      page: currentPageNumber,
      size: currentPageSize
    });
  },
  async refreshDetail ({
    dispatch,
    commit,
    state
  }) {
    const url = '/b2b/orders/purchase/' + state.detailData.code;
    const result = await http.get(url);
    if (!result['errors']) {
      commit('detailData', result);
    }
  },
  clearQueryFormData ({dispatch, commit, state}) {
    commit('queryFormData', {
      code: '',
      skuID: '',
      state: '',
      keywords: '',
      productionLeaderName: '',
      cooperator: '',
      categories: [],
      productionWorkOrder: ''
    })
  },
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  status: state => state.status,
  isAdvancedSearch: state => state.isAdvancedSearch,
  formData: state => state.formData,
  queryFormData: state => state.queryFormData,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  detailData: state => state.detailData
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
