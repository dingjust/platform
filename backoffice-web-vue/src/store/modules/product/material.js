import http from '@/common/js/http';

const state = {
  url: '',
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
    name: '',
    code: '',
    materialsType: '',
    materialsUnit: '',
    materialWidth: '',
    materialComposition: '',
    images: [],
    colors: [],
    specs: [
      {
        code: '',
        name: '',
        key: Number(Math.random().toString().substr(3, 3) + Date.now()).toString(36)
      }
    ],
    models: [
      {
        code: '',
        name: '',
        key: Number(Math.random().toString().substr(3, 3) + Date.now()).toString(36)
      }
    ],
    variants: []
  },
  queryFormData: {
    name: '',
    code: '',
    materialsType: ''
  },
  isCreate: true,
  selectMaterialList: []
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page,
  formData: (state, formData) => state.formData = formData,
  isCreate: (state, isCreate) => state.isCreate = isCreate,
  selectMaterialList: (state, selectMaterialList) => state.selectMaterialList = selectMaterialList
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

    const response = await http.post(url, state.queryFormData, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  resetFormData ({dispatch, commit, state}) {
    commit('formData', {
      id: null,
      name: '',
      code: '',
      materialsType: '',
      materialsUnit: '',
      images: [],
      colors: [],
      specs: [
        {
          code: '',
          name: ''
        }
      ],
      variants: []
    });
  },
  resetQueryFormData ({dispatch, commit, state}) {
    commit('queryFormData', {
      name: '',
      code: '',
      materialsType: ''
    });
    commit('currentPageNumber', 0);
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  isAdvancedSearch: state => state.isAdvancedSearch,
  queryFormData: state => state.queryFormData,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  formData: state => state.formData,
  isCreate: state => state.isCreate,
  selectMaterialList: state => state.selectMaterialList
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
