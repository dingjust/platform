import http from '@/common/js/http';

const state = {
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
    profilePicture: null,
    contactAddress: {
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
    categories: [],
    adeptAtCategories: [],
    contactPerson: '',
    contactPhone: '',
    latheQuantity: '',
    scaleRange: '',
    monthlyCapacityRange: '',
    cooperationModes: [],
    populationScale: '',
    developmentCapacity: false,
    registrationDate: null,
    taxNumber: '',
    bankOfDeposit: '',
    phone: '',
    cooperativeBrand: '',
    businessRegistrationNo: '',
    legalRepresentative: '',
    certificateOfLegal: '',
    labels: [],
    industrialCluster: null
  },
  queryFormData: {
    labels: [],
    populationScales: [],
    productiveOrientations: [],
    starLevel: null,
    machiningTypes: [],
    categories: [],
    adeptAtCategories: [],
    industrialClusters:[],
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
  async search({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('keyword', keyword);
    commit('currentPageNumber', page);
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
  async advancedSearch({dispatch, commit, state}, {url, queryFormData, page, size}) {
    commit('queryFormData', queryFormData);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }
    console.log(queryFormData);
    const response = await http.post(url, queryFormData, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

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
