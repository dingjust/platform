import http from '@/common/js/http';

const state = {
  keyword: '',
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
    uid: '',
    name: '',
    registrationDate: null,
    profilePicture: null,
    scaleRange: '',
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
    cooperativeBrand: '',
    businessRegistrationNo: '',
    legalRepresentative: '',
    certificateOfLegal: '',
    salesMarket: [],
    duties: ''
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
  queryFormData: {
    keyword:'',
    contactPhone:'',
    cooperativeBrand:'',
    adeptAtCategories:[],
    regions:[],
    cities:[],
    creationTimeFrom:'',
    creationTimeTo:'',
  },
  cities: [],
  cityDistricts: [],
  categories: [],
  isCitiesChanged: false,
  isDistrictsChanged: false,
  brandFormVisible: false,
  approvalStatus: ''
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  setFormData: (state, formData) => state.formData = formData,
  page: (state, page) => state.page = page,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
  setIsCitiesChanged: (state,isCitiesChanged) => state.isCitiesChanged = isCitiesChanged,
  setIsDistrictsChanged: (state,isDistrictsChanged) => state.isDistrictsChanged = isDistrictsChanged,
  setBrandFormVisible: (state,brandFormVisible) => state.brandFormVisible = brandFormVisible,
  cities: (state,cities) => state.cities = cities,
  cityDistricts: (state,cityDistricts) => state.cityDistricts = cityDistricts,
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
  page: state => state.page,
  isAdvancedSearch: state => state.isAdvancedSearch,
  formData: state => state.formData,
  cities: state => state.cities,
  cityDistricts: state => state.cityDistricts,
  isCitiesChanged: state => state.isCitiesChanged,
  isDistrictsChanged: state => state.isDistrictsChanged,
  brandFormVisible: state => state.brandFormVisible
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
