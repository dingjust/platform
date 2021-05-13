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
    industrialCluster: null,
    longitude: 0,
    latitude: 0,
    certificates: [],
    productionMode: '',
    starLevel:0,
    cuttingDepartment: [],
    productionWorkshop: [],
    lastDepartment: [],
    keyword: '',
    qualityLevels: [],
    duties: '',
    loginDisabled: false,
    profiles: []
  },
  queryFormData: {
    keyword: '',
    labels: [],
    populationScales: [],
    productiveOrientations: [],
    cities: [],
    starLevel: null,
    machiningTypes: [],
    categories: [],
    adeptAtCategories: [],
    industrialClusters: [],
    creationTimeFrom: '',
    creationTimeTo: '',
    reviewState: ''
  },
  cities: [],
  cityDistricts: [],
  labels: [],
  categories: [],
  factoryFormVisible: false,
  isCitiesChanged: false,
  isDistrictsChanged: false,
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  setFormData: (state, formData) => state.formData = formData,
  page: (state, page) => state.page = page,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
  setLabels: (state,labels) => state.labels = labels,
  cities: (state,cities) => state.cities = cities,
  cityDistricts: (state,cityDistricts) => state.cityDistricts = cityDistricts,
  setFactoryFormVisible: (state,factoryFormVisible) => state.factoryFormVisible = factoryFormVisible,
  setIsCitiesChanged: (state,isCitiesChanged) => state.isCitiesChanged = isCitiesChanged,
  setIsDistrictsChanged: (state,isDistrictsChanged) => state.isDistrictsChanged = isDistrictsChanged,
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('keyword', keyword);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }
    commit('isAdvancedSearch', false);
    const response = await http.post(url, {
      keyword: state.keyword
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    if (!response['errors']) {
      commit('page', response);
    }
  },
  async advancedSearch ({dispatch, commit, state}, {url, queryFormData, page, size}) {
    commit('queryFormData', queryFormData);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }
    commit('isAdvancedSearch', true);
    const response = await http.post(url, queryFormData, {
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
  clearFormData ({dispatch, commit, state}) {
    var data = {
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
      industrialCluster: null,
      longitude: 0,
      latitude: 0,
      certificates: [],
      productionMode: '',
      keyword: ''
    };
    commit('setFormData', data);
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
  labels: state => state.labels,
  cityDistricts: state => state.cityDistricts,
  factoryFormVisible: state => state.factoryFormVisible,
  isCitiesChanged: state => state.isCitiesChanged,
  isDistrictsChanged: state => state.isDistrictsChanged
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
