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
    code: '',
    product: {
      thumbnail: '',
      category: {
        name: ''
      }
    },
    cooperator: {
      partner: {
        name: ''
      }
    },
    status: 'PENDING_CONFIRM',
    supplier: {},
    user: {},
    deliveryAddress: {
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
    entries: [],
    attachments: [],
    remarks: '',
    salesApplication: 'BELOW_THE_LINE',
    totalPrice: 0,
    totalQuantity: 0,
    unitPrice: 0,
    purchaser: {},
    belongTo: {
      uid: '',
      name: ''
    },
    creator: {},
    progresses: [],
    companyOfSeller: '',
    contactPersonOfSeller: '',
    contactOfSeller: '',
    payPlan: {
      payPlanType: '',
      isHaveDeposit: true,
      payPlanItems: []
    },
    factoryOperator: {
      name: ''
    },
    brandOperator: {
      name: ''
    }
  },
  queryFormData: {
    code: '',
    requirementOrderCode: '',
    skuID: '',
    statuses: [],
    expectedDeliveryDateFrom: null,
    expectedDeliveryDateTo: null,
    createdDateFrom: null,
    createdDateTo: null,
    // belongTos: [],
    // purchasers:[],
    keyword: '',
    categories: [],
    orderType: ''
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

  },
  colorSizeData: [],
  createFormData: {
    cooperator: {
      id: '',
      partner: {
        id: '',
        name: '',
        contactPerson: '',
        contactPhone: ''
      }
    },
    isSelfProduction: false,
    productionTask: {
      id: '',
      product: {
        name: '',
        colorSizeEntries: []
      }
    },
    expectedDeliveryDate: '',
    deliveryAddress: {},
    machiningType: 'LABOR_AND_MATERIAL',
    invoiceNeeded: false,
    invoiceTaxPoint: 0.03,
    freightPayer: 'PARTYA',
    progressWorkSheet: {
      name: '',
      progresses: []
    },
    payPlan: {
      payPlanType: 'PHASEONE',
      isHaveDeposit: false,
      payPlanItems: [],
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
    remarks: '',
    partyAOperator: {
      id: ''
    },
    attachments: [],
    entries: [{
      productionTask: {
        id: ''
      }
    }]
  }
};

const mutations = {
  url: (state, url) => state.url = url,
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  statuses: (state, statuses) => state.statuses = statuses,
  queryFormData: (state, queryFormData) => state.queryFormData = queryFormData,
  page: (state, page) => state.page = page,
  isAdvancedSearch: (state, isAdvancedSearch) => state.isAdvancedSearch = isAdvancedSearch,
  detailData: (state, detailData) => state.detailData = detailData,
  formData: (state, formData) => state.formData = formData,
  colorSizeData: (state, colorSizeData) => state.colorSizeData = colorSizeData,
  createFormData: (state, createFormData) => state.createFormData = createFormData
};

const actions = {
  async search({
    dispatch,
    commit,
    state
  }, {
    url,
    keyword,
    statuses,
    page,
    size
  }) {
    console.log(keyword + 'test' + page + 'test' + size);
    commit('url', url);
    commit('keyword', keyword);
    commit('statuses', statuses);
    if (page || page === 0) {
      console.log(page);
      commit('currentPageNumber', page);
    }

    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword,
      statuses: state.statuses
    }, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  async searchAdvanced({
    dispatch,
    commit,
    state
  }, {
    url,
    query,
    page,
    size
  }) {
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
  refresh({
    dispatch,
    commit,
    state
  }) {
    const keyword = state.keyword;
    const statuses = state.statuses;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {
      url: state.url,
      keyword,
      statuses,
      page: currentPageNumber,
      size: currentPageSize
    });
  },
  // async getDetail({
  //   dispatch,
  //   commit,
  //   state
  // }, {
  //   code
  // }) {
  //   // const url = '/b2b/orders/production/work/' + code;
  //   const url = '/b2b/orders/purchase/' + code;
  //   const result = await http.get(url);
  //   if (!result['errors']) {
  //     commit('formData', result);
  //   }
  // },
  async refreshDetail({
      dispatch,
      commit,
      state
    },
    id
  ) {
    const url = '/b2b/production/task/order/' + id;
    const result = await http.get(url);
    if (!result['errors'] && result.code == 1) {
      commit('formData', result.data);
    }
  },
  clearQueryFormData({
    dispatch,
    commit,
    state
  }) {
    commit('queryFormData', {
      code: '',
      requirementOrderCode: '',
      skuID: '',
      statuses: [],
      expectedDeliveryDateFrom: null,
      expectedDeliveryDateTo: null,
      createdDateFrom: null,
      createdDateTo: null,
      keyword: '',
      categories: [],
      orderType: ''
    })
  },
  clearCreateFormData({
    dispatch,
    commit,
    state
  }) {
    commit('createFormData', {
      cooperator: {
        id: '',
        partner: {
          id: '',
          name: '',
          contactPerson: '',
          contactPhone: ''
        }
      },
      isSelfProduction: false,
      productionTask: {
        id: '',
        product: {
          name: '',
          colorSizeEntries: []
        }
      },
      expectedDeliveryDate: '',
      deliveryAddress: {},
      machiningType: 'LABOR_AND_MATERIAL',
      invoiceNeeded: false,
      invoiceTaxPoint: 0.03,
      freightPayer: 'PARTYA',
      progressWorkSheet: {
        name: '',
        progresses: []
      },
      payPlan: {
        payPlanType: 'PHASEONE',
        isHaveDeposit: false,
        payPlanItems: [],
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
      remarks: '',
      partyAOperator: {
        id: ''
      },
      attachments: [],
      entries: [{
        productionTask: {
          id: ''
        }
      }]
    })
  }
};

const getters = {
  url: state => state.url,
  keyword: state => state.keyword,
  statuses: state => state.statuses,
  isAdvancedSearch: state => state.isAdvancedSearch,
  queryFormData: state => state.queryFormData,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  detailData: state => state.detailData,
  formData: state => state.formData,
  colorSizeData: state => state.colorSizeData,
  createFormData: state => state.createFormData
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
