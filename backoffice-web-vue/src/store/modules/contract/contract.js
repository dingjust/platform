import http from '@/common/js/http';

const state = {
  url: '',
  keyword: '',
  statuses: '',
  dateTime:'',
  orderCode:'',
  currentPageNumber: 0,
  currentPageSize: 10,
  page: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  queryFormData: {},
};
var creationtimeStart='';
var creationtimeEnd = '';

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  state:(state) => state,
  keyword: (state, keyword) => state.keyword = keyword,
  orderCode:(state, orderCode) => state.orderCode = orderCode,
  dateTime:(state, dateTime) => state.dateTime = dateTime,
  page: (state, page) => state.page = page,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
};

const actions = {
  async search({dispatch, commit, state}, {url, keyword,orderCode,dateTime, statuses, page, size}) {
    commit('url', url);
    commit('keyword', keyword);
    commit('orderCode', orderCode);
    console.log(dateTime)
    if(dateTime != null && dateTime != ''){
      commit('dateTime', dateTime);
      creationtimeStart = state.dateTime[0];
      creationtimeEnd = state.dateTime[1];
    }

    commit('state', statuses);
    if (page||page===0) {
      commit('currentPageNumber', page);
    }
    if (size) {
      commit('currentPageSize', size);
    }
    const response = await http.post(url, {
      title: state.keyword,
      orderCode:state.orderCode,
      creationtimeStart:creationtimeStart,
      creationtimeEnd:creationtimeEnd,
      state: statuses
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  refresh({dispatch, commit, state}) {
    const keyword = state.keyword;
    const statuses = state.statuses;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url: state.url, keyword,statuses, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  orderCode:state => state.orderCode,
  statuses: state => state.statuses,
  dateTime:state => state.dateTime,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  isAdvancedSearch: state => state.isAdvancedSearch,
  page: state => state.page,
  queryFormData: state => state.queryFormData,
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
