export default {
  items: [{
    name: '首页',
    url: '/dashboard',
    icon: 'el-icon-s-home'
  },
  {
    name: '任务中心',
    icon: 'el-icon-notebook-1',
    meta: {
      requiresAuth: true,
      permissions: ['TO_DO_TASK']
    },
    children: [
      //   {
      //   name: '待我处理',
      //   url: '/task/handle',
      //   icon: 'iconNone'
      // },
      {
        name: '我的审批',
        url: '/task/approval',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['AUDIT_TASK']
        }
      }
      // {
      //   name: '待我分配',
      //   url: '/task/assign',
      //   icon: 'iconNone'
      // }
    ]
  },
  {
    name: '订单管理',
    icon: 'el-icon-s-order',
    meta: {
      requiresAuth: true,
      permissions: ['ORDER']
    },
    children: [{
      name: '企划订单',
      url: '/sales/plan',
      meta: {
        requiresAuth: true,
        permissions: ['SALES_PLAN']
      }
    }, {
      name: '外接订单',
      url: '/sales/pending-order',
      meta: {
        requiresAuth: true,
        permissions: ['SALES_OUT_ORDER']
      }
    }, {
      name: '销售订单',
      url: '/order/sales',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['SALES_ORDER']
      }
    } ]
  },
  {
    name: '生产管理',
    icon: 'el-icon-notebook-2',
    meta: {
      requiresAuth: true,
      permissions: ['WORK_SHEEET']
    },
    children: [
      //   {
      //   name: '工单分配',
      //   url: '/sales/allocating/productionOrder'
      // },
      {
        name: '生产工单',
        url: '/sales/productionOrder',
        meta: {
          requiresAuth: true,
          permissions: ['PRODUCTION_TASK_ORDER']
        }
      }, {
        name: '生产进度工单',
        url: '/sales/progressOrder',
        meta: {
          requiresAuth: true,
          permissions: ['PROGRESS_WORK_ORDER']
        }
      },
      // {
      //   name: '发货任务',
      //   url: '/shipping/tasks',
      // },
      {
        name: '发货管理',
        url: '/shipping/shipping-receipt-sheet',
        meta: {
          requiresAuth: true,
          permissions: ['SHIPPING_SHEET']
        }
      }, {
        name: '差异复议',
        url: '/shipping/reconsider-order',
        meta: {
          requiresAuth: true,
          permissions: ['RECONSIDER_SHEET']
        }
      },
      //  {
      //   name: '对账任务',
      //   url: '/reconciliation/tasks/import',
      // },
      {
        name: '对账管理',
        url: '/shipping/reconciliation-manage',
        meta: {
          requiresAuth: true,
          permissions: ['RECONCILIATION_SHEET']
        }
      }
    ]
  },
  {
    name: '外发管理',
    icon: 'el-icon-notebook-2',
    meta: {
      requiresAuth: true,
      permissions: ['OUT_ORDER']
    },
    children: [{
      name: '外发订单',
      url: '/sales/outboundOrder',
      meta: {
        requiresAuth: true,
        permissions: ['SEND_SALES_OUT_ORDER']
      }
    }, {
      name: '外发生产工单',
      url: '/sales/outboundProductionOrder',
      meta: {
        requiresAuth: true,
        permissions: ['OUT_PRODUCTION_TASK_ORDER']
      }
    },
      // {
      //   name: '收货任务',
      //   url: '/receipt/tasks',
      // },
    {
      name: '收货管理',
      url: '/receipt/shipping-receipt-sheet',
      meta: {
        requiresAuth: true,
        permissions: ['RECEIPT_SHEET']
      }
    }, {
      name: '差异复议',
      url: '/receipt/reconsider-order',
      meta: {
        requiresAuth: true,
        permissions: ['RECONSIDER_SHEET_OUT']
      }
    },
      // {
      //   name: '对账任务',
      //   url: '/reconciliation/tasks/export',
      // },
    {
      name: '对账管理',
      url: '/receipt/reconciliation-manage',
      meta: {
        requiresAuth: true,
        permissions: ['RECONCILIATION_SHEET_OUT']
      }
    },
    {
      name: '出货对账',
      url: '/order/delivery-Reconciliation'
    }
    ]
  },
  {
    name: '采购管理',
    icon: 'el-icon-shopping-bag-2',
    meta: {
      requiresAuth: true,
      permissions: ['PURCHASE']
    },
    children: [{
      name: '成本单',
      url: '/purchase/cost'
    }, {
      name: '报价单',
      url: '/purchase/quote'
    }, {
      name: '盈亏分析',
      url: '/purchase/profitloss'
    }, {
      name: '采购需求',
      url: '/purchase/requirement',
      meta: {
        requiresAuth: true,
        permissions: ['PURCHASE_TASK']
      }
    }, {
      name: '采购工单',
      url: '/purchase/worksheet',
      meta: {
        requiresAuth: true,
        permissions: ['PURCHASE_WORK_ORDER']
      }
    }, {
      name: '采购单',
      url: '/purchase/order',
      meta: {
        requiresAuth: true,
        permissions: ['PURCHASE_ORDER']
      }
    }]
  },
  {
    name: '产品中心',
    icon: 'el-icon-shopping-bag-1',
    meta: {
      requiresAuth: true,
      permissions: ['PRODUCT']
    },
    children: [
      {
        name: 'B2B产品',
        url: '/product/apparel',
        meta: {
          requiresAuth: true,
          permissions: ['PRODUCTION_PRODUCT']
        }
      }, {
        name: '款式管理',
        url: '/product/sample',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['SAMPLE_CLOTHES_PRODUCT']
        }
      },
      {
        name: '物料管理',
        url: '/product/material',
        icon: 'iconNone'
      },
      {
        name: '库存管理',
        url: '/product/inventory',
        icon: 'iconNone'
      }
    ]
  },
  {
    name: '财务管理',
    icon: 'el-icon-s-finance',
    meta: {
      requiresAuth: true,
      permissions: ['FINANCE']
    },
    children: [{
      name: '应收账款',
      url: '/financial/receivable',
      meta: {
        requiresAuth: true,
        permissions: ['PAYMENT_BILL_RECEIVABLES']
      }
    }, {
      name: '应付账款',
      url: '/financial/payable',
      meta: {
        requiresAuth: true,
        permissions: ['PAYMENT_BILL']
      }
    }, {
      name: '付款申请单(财务)',
      url: '/financial/finance/paymentRequest',
      meta: {
        requiresAuth: true,
        permissions: ['PAYMENT_REQUEST_FINANCE']
      }
    }, {
      name: '付款申请单(跟单)',
      url: '/financial/merchandiser/paymentRequest',
      meta: {
        requiresAuth: true,
        permissions: ['PAYMENT_REQUEST']
      }
    }]
  },
  {
    name: '企业管理',
    icon: 'el-icon-office-building',
    meta: {
      requiresAuth: true,
      permissions: ['COMPANY']
    },
    children: [
      // {
      //   name: '认证信息',
      //   url: '/account/authentication',
      //   icon: 'iconNone'
      // },
      {
        name: '公司介绍',
        url: '/account/index',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['COMPANY_INFO']
        }
      },
      {
        name: '认证中心',
        url: '/account/Authentication',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['CERT']
        }
      },
      {
        name: '员工管理',
        url: '/account/personnel',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['COMPANY_CUSTOMER']
        }
      },
      {
        name: '组织架构',
        url: '/account/organization',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['COMPANY_B2BDEPT']
        }
      },
      {
        name: '角色管理',
        url: '/account/organizationRole',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['COMPANY_ROLE']
        }
      },
      {
        name: '合作商管理',
        url: '/account/cooperator',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['COMPANY_COOPERATOR']
        }
      }
    ]
  },
  {
    name: '合同管理',
    // url: '/contract',
    icon: 'el-icon-s-marketing',
    meta: {
      requiresAuth: true,
      permissions: ['AGREEMENT']
    },
    children: [{
      name: '合同签订',
      url: '/contract/manage',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['COMPANY_AGREEMENT']
      }
    },
    {
      name: '模板管理',
      url: '/contract/template',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['AGREEMENT_TPML']
      }
    },
    {
      name: '印章管理',
      url: '/contract/seal',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['AGREEMENT_SEAL']
      }
    }
    ]
  },
  {
    name: '物流管理',
    icon: 'el-icon-truck',
    children: [
      {
        name: '物流单号管理',
        url: '/logistics/list'
      }
    ]
  },
  {
    name: '设置',
    icon: 'el-icon-setting',
    meta: {
      requiresAuth: true,
      permissions: ['SETTING']
    },
    children: [{
      name: '节点配置',
      url: '/account/setting/progress-plan',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['PROGRESS_PLAN']
      }
    }, {
      name: '对账配置',
      url: '/account/setting/reconciliation-plan',
      icon: 'iconNone'
      // meta: {
      //   requiresAuth: true,
      //   permissions: ['RECONCILIATION_PLAN']
      // }
    }, {
      name: '账务配置',
      url: '/account/setting/payPlan',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['PAY_PLAN']
      }
    }, {
      name: '我的钱包',
      url: '/miscs/wallet',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['COMPANY_WALLET']
      }
    }, {
      name: '地址管理',
      url: '/account/address',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['COMPANY_ADDRESS']
      }
    }, {
      name: '银行卡配置',
      url: '/account/setting/bank',
      icon: 'iconNone'
    }]
  },
  {
    name: '其他',
    // url: '/miscs',
    icon: 'el-icon-coin',
    children: [{
      name: '需求订单',
      url: '/order/requirement',
      icon: 'iconNone'
    }, {
      name: '报价订单',
      url: '/order/quote',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['QUOTE_ORDER']
      }
    },
    {
      name: '打样订单',
      url: '/order/proofing',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['PROOFING_ORDER']
      }
    },
    {
      name: '生产订单',
      url: '/order/purchase',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['PURCHASE_ORDER']
      }
    },
    {
      name: '产能配置',
      url: '/product/capacity',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['FACTORY_CAPACITY']
      }
    },
    {
      name: '生产进度',
      url: '/report/production-progress',
      icon: 'iconNone',
      meta: {
        requiresAuth: true,
        permissions: ['REPORT_PRODUCTION_PROGRESS']
      }
    }
      // {
      //   name: '生产进度',
      //   url: '/order/production',
      //   icon: 'iconNone'
      // }
    ]
  }
  ]
};
