const state = {
  requirementOrderStatuses: [{
    code: 'PENDING_QUOTE',
    name: '报价中'
  }, {
    code: 'COMPLETED',
    name: '已完成'
  }, {
    code: 'CANCELLED',
    name: '已失效'
  }],
  requirementOrderStatusFlow: {
    PENDING_QUOTE: 0,
    COMPLETED: 1,
    CANCELLED: 1
  },
  salesOrderStatuses: [{
    code: 'PENDING_PAYMENT',
    name: '待付款'
  }, {
    code: 'PENDING_DELIVERY',
    name: '待发货'
  }, {
    code: 'SHIPPED',
    name: '已发货'
  }, {
    code: 'COMPLETED',
    name: '已完成'
  }],
  salesOrderStatusProcessFlow: {
    'PENDING_PAYMENT': 0,
    'PENDING_DELIVERY': 1,
    'SHIPPED': 2,
    'COMPLETED': 3
  },
  quoteStates: [
    {
      code: 'SELLER_SUBMITTED',
      name: '待处理'
    },
    {
      code: 'BUYER_APPROVED',
      name: '通过'
    },
    {
      code: 'BUYER_REJECTED',
      name: '拒绝'
    }
  ],
  approvalStatuses: [{
    code: 'approved',
    name: '上架'
  }, {
    code: 'unapproved',
    name: '下架'
  }],
  machiningTypes: [{
    code: 'LABOR_AND_MATERIAL',
    name: '包工包料'
  }, {
    code: 'LIGHT_PROCESSING',
    name: '清加工'
  }],
  labelGroups: [
    {
      code: 'FACTORY',
      name: '工厂打标'
    },
    {
      code: 'PLATFORM',
      name: '平台打标'
    }
  ]
};

const mutations = {};

const actions = {
  getEnumByCode({dispatch, commit, state}, {enumsName, code}) {
    return state[enumsName].find(e => e.code === code);
  }
};

const getters = {
  approvalStatuses: state => state.approvalStatuses,
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
