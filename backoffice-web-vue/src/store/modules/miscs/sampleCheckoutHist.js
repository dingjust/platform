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
    code: '',
    name:'',
    quantity:'',
    expectedReturningDate:'',
    relatedParty:'',
    contact:'',
    type:'',
    state:'',
    remarks:'',
    images: [],
    company: {
      uid: '',
      name: ''
    }
  },
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  sampleCheckoutType: (state, sampleCheckoutType) => state.sampleCheckoutType = sampleCheckoutType,
  returnState: (state, returnState) => state.returnState = returnState,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page
};

const actions = {
  async search({dispatch, commit, state}, {keyword, page, size}) {
    if(keyword){
      commit('keyword', keyword);
    }

    if (page) {
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }
    let url = '/b2b/products/sampleCheckoutHist/keyword/'+state.keyword;
    const response = await http.get(url, {
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
  sampleCheckoutType: state => state.sampleCheckoutType,
  returnState: state => state.returnState,
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
