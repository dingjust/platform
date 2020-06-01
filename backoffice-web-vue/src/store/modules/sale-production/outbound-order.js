import http from '@/common/js/http';

const state = {
  url: '',
  keyword: '',
  statuses: [],
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
    byAorB: '',
    managementMode: '',
    outboundCompanyName: '',
    outboundContactPerson: '',
    outboundContactPhone: '',
    cooperator: {
      id: ''
    },
    entries: [{
      productionTask: {
        id: ''
      },
      billPrice: '',
      expectedDeliveryDate: '',
      shippingAddress: {},
      product: {

      },
      colorSizeEntries: []
    }],
    machiningType: 'LABOR_AND_MATERIAL',
    invoiceNeeded: false,
    invoiceTaxPoint: 0.03,
    freightPayer: 'PARTYA',
    remarks: '',
    isApproval: false,
    progressPlan: {},
    payPlan: {
      payPlanItems: [],
      isHaveDeposit: false,
      payPlanType: 'PHASEONE',
      deposit: {
        event: 'ORDER_CONFIRMED',
        time: 5,
        range: 'INSIDE',
        percent: 0.3
      },
      balance1: {
        event: 'ORDER_CONFIRMED',
        time: 5,
        range: 'INSIDE',
        percent: 0.3
      },
      balance2: {
        event: 'ORDER_CONFIRMED',
        time: 5,
        range: 'INSIDE',
        percent: 0.3
      },
      monthBalance: {
        event: 'ORDER_CONFIRMED',
        time: 5
      }
    },
    attachments: [],
    partyAOperator: {
      name: '',
      contactPhone: ''
    },
    partyBOperator: {
      name: '',
      contactPhone: ''
    },
    approvers: [],
    partyACompany: {
      uid: ''
    },
    partyBCompany: {
      uid: ''
    }
  },
  queryFormData: {
    keyword: '',
    cooperator: '',
    belongOperator: '',
    status: ''
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
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  statuses: (state, statuses) => state.statuses = statuses,
  formData: (state, formData) => state.formData = formData,
  setFormData: (state, formData) => state.formData = formData,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
  detailData: (state, detailData) => state.detailData = detailData
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, page, size}) {
    console.log(keyword + 'test' + page + 'test' + size);
    commit('url', url);
    commit('keyword', keyword);
    if (page || page === 0) {
      console.log(page);
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

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAdvanced ({dispatch, commit, state}, {url, query, page, size}) {
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
  clearFormData ({dispatch, commit, state}) {
    commit('formData', {
      id: null,
      byAorB: '',
      managementMode: '',
      outboundCompanyName: '',
      outboundContactPerson: '',
      outboundContactPhone: '',
      cooperator: {
        id: ''
      },
      entries: [{
        productionTask: {
          id: ''
        },
        billPrice: '',
        expectedDeliveryDate: '',
        shippingAddress: {},
        product: {
        },
        colorSizeEntries: []
      }],
      machiningType: 'LABOR_AND_MATERIAL',
      invoiceNeeded: false,
      invoiceTaxPoint: 0.03,
      freightPayer: 'PARTYA',
      remarks: '',
      isApproval: false,
      progressPlan: {},
      payPlan: {
        payPlanItems: [],
        isHaveDeposit: false,
        payPlanType: 'PHASEONE',
        deposit: {
          event: 'ORDER_CONFIRMED',
          time: 5,
          range: 'INSIDE',
          percent: 0.3
        },
        balance1: {
          event: 'ORDER_CONFIRMED',
          time: 5,
          range: 'INSIDE',
          percent: 0.3
        },
        balance2: {
          event: 'ORDER_CONFIRMED',
          time: 5,
          range: 'INSIDE',
          percent: 0.3
        },
        monthBalance: {
          event: 'ORDER_CONFIRMED',
          time: 5
        }
      },
      attachments: [],
      partyAOperator: {
        name: '',
        contactPhone: ''
      },
      partyBOperator: {
        name: '',
        contactPhone: ''
      },
      approvers: [],
      partyACompany: {
        uid: ''
      },
      partyBCompany: {
        uid: ''
      }
    });
  },
  clearQueryFormData ({dispatch, commit, state}) {
    commit('queryFormData', {
      keyword: '',
      cooperator: '',
      belongOperator: '',
      status: ''
    });
  },
  refresh ({dispatch, commit, state}) {
    const keyword = state.keyword;
    const statuses = state.statuses;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url: state.url, keyword, statuses, page: currentPageNumber, size: currentPageSize});
  },
  async refreshDetail ({dispatch, commit, state}) {
    const url = '/b2b/orders/purchase/' + state.detailData.code;
    const result = await http.get(url);
    if (!result['errors']) {
      commit('detailData', result);
    }
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  statuses: state => state.statuses,
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
