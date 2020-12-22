import http from '@/common/js/http';

const state = {
  url: '',
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
    images: [],
    details: [],
    code: '',
    skuID: '',
    name: '',
    price: 0.00,
    minPrice: 0.00,
    maxPrice: 0.00,
    category: {
      code: '',
      name: ''
    },
    brand: '',
    gramWeight: 0.0,
    variants: [],
    colors: [],
    sizes: [],
    attributes: {
      styles: [],
      fabricCompositions: [],
      editionType: '',
      pattern: '',
      sleeveType: '',
      sleeveLength: '',
      decorativePatterns: [],
      popularElements: [],
      filler: '',
      thickness: '',
      season: '',
      taggable: true,
      placket: ''
    },
    belongTo: {
      uid: '',
      name: ''
    },
    steppedPrices: []

  },
  newFormData: {
    id: null,
    images: [],
    details: [],
    code: '',
    skuID: '',
    name: '',
    price: 0.00,
    gramWeight: 0.0,
    minPrice: 0.00,
    maxPrice: 0.00,
    category: null,
    brand: '',
    variants: [],
    colors: [],
    sizes: [],
    fabricCompositions: [],
    attributes: {
      styles: [],
      editionType: '',
      pattern: '',
      sleeveType: '',
      sleeveLength: '',
      decorativePatterns: [],
      popularElements: [],
      filler: '',
      thickness: '',
      season: '',
      taggable: true,
      placket: ''
    },
    belongTo: {
      uid: '',
      name: ''
    },
    steppedPrices: [
      {
        minimumQuantity: '',
        price: ''
      }
    ],
    spotSteppedPrices: [
      {
        minimumQuantity: '',
        price: ''
      }
    ],
    productType: ['FUTURE_GOODS'],
    colorSizes: []
  },
  queryFormData: {
    code: '',
    skuID: '',
    name: '',
    approvalStatuses: '',
    categories: [],
    belongToName: ''
  }
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  newFormData: (state, newFormData) => state.newFormData = newFormData,
  page: (state, page) => state.page = page,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('url', url);
    commit('keyword', keyword);
    // commit('currentPageNumber', page);

    if (page || page === 0) {
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }

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
  async searchAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
    commit('url', url);
    commit('queryFormData', query);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, query, {
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

    dispatch('search', {url: state.url, keyword, page: currentPageNumber, size: currentPageSize});
  },
  resetFormData ({dispatch, commit, state}) {
    commit('newFormData', {
      id: null,
      images: [],
      details: [],
      code: '',
      skuID: '',
      name: '',
      price: 0.00,
      gramWeight: 0.0,
      minPrice: 0.00,
      maxPrice: 0.00,
      category: null,
      brand: '',
      variants: [],
      colors: [],
      sizes: [],
      fabricCompositions: [],
      attributes: {
        styles: [],
        editionType: '',
        pattern: '',
        sleeveType: '',
        sleeveLength: '',
        decorativePatterns: [],
        popularElements: [],
        filler: '',
        thickness: '',
        season: '',
        taggable: true,
        placket: ''
      },
      belongTo: {
        uid: '',
        name: ''
      },
      steppedPrices: [
        {
          minimumQuantity: '',
          price: ''
        }
      ],
      spotSteppedPrices: [
        {
          minimumQuantity: '',
          price: ''
        }
      ],
      productType: ['FUTURE_GOODS'],
      colorSizes: []
    });
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  isAdvancedSearch: state => state.isAdvancedSearch,
  queryFormData: state => state.queryFormData,
  newFormData: state => state.newFormData,
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
