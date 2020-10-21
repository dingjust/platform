import http from '@/common/js/http';

const getDefaultState = () => {
  return {
    url: '',
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
      code: null,
      title: '',
      lastRefreshTime: null,
      dateStartPoint: null,
      dateEndPoint: null,
      enabled: false,
      clickTimes: 0,
      showTimes: 0,
      todayRefreshTimes: 0,
      longTerm: true,
      categoryCapacities: []
    }
  }
}

const state = getDefaultState();

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  page: (state, page) => state.page = page,
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
    page,
    size
  }) {
    if (page || page === 0) {
      console.log(page);
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {

    }, {
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
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {
      url: state.url,
      page: currentPageNumber,
      size: currentPageSize
    });
  },
  resetState ({dispatch, commit, state}) {
    commit('resetModuleState');
  }
};

const getters = {
  url: state => state.url,
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
