import http from '@/common/js/http';

const getDefaultState = () => {
  return {
    keyword: '',
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
      uid: '',
      name: '',
      registrationDate: null,
      scaleRange: '',
      address: '',
      styles: [],
      brand: '',
      ageRanges: [],
      priceRange1s: [],
      priceRange2s: [],
      adeptAtCategories: [],
      contactPhone: '',
      contactPerson: '',
      accountUid: '',
      password: '',
      confirmPassword: '',
      email: '',
      taxNumber: '',
      bankOfDeposit: '',
      phone: '',
      cooperativeBrand: ''
    }
  }
}

const state = getDefaultState();

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page,
  resetModuleState (state) {
    Object.assign(state, getDefaultState())
  }
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
  refresh ({dispatch, commit, state}) {
    const keyword = state.keyword;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {keyword, page: currentPageNumber, size: currentPageSize});
  },
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
  }

};

const getters = {
  keyword: state => state.keyword,
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
