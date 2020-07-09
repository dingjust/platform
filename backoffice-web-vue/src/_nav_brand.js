export default {
  items: [
    // {
    //   title: true,
    //   name: '品牌',
    //   class: '',
    //   wrapper: {
    //     element: 'span',
    //     attributes: {}
    //   }
    // },
    {
      name: '首页',
      url: '/dashboard',
      icon: 'el-icon-s-home'
    },
    {
      name: '任务中心',
      // url: '/task',
      icon: 'el-icon-notebook-1',
      children: [{
        name: '待我处理',
        url: '/task/handle',
        icon: 'iconNone'
      }, {
        name: '我的审批',
        url: '/task/approval',
        icon: 'iconNone'
      }, {
        name: '待我分配',
        url: '/task/assign',
        icon: 'iconNone'
      }]
    },
    {
      name: '订单管理',
      // url: '/sales',
      icon: 'el-icon-s-order',
      children: [{
        name: '业务订单',
        url: '/sales/plan'
      }, {
        name: '外接订单',
        url: '/sales/pending-order'
      }]
    },
    {
      name: '生产管理',
      // url: '/sales',
      icon: 'el-icon-notebook-2',
      children: [{
          name: '待分配工单',
          url: '/sales/allocating/productionOrder'
        }, {
          name: '生产工单',
          url: '/sales/productionOrder',
        }, {
          name: '生产进度工单',
          url: '/sales/progressOrder'
        }
      ]
    },
    {
      name: '外发管理',
      // url: '/sales',
      icon: 'el-icon-notebook-2',
      children: [{
        name: '外发订单',
        url: '/sales/outboundOrder',
      }, {
        name: '外发生产工单',
        url: '/sales/outboundProductionOrder'
      }]
    },
    {
      name: '采购中心',
      // url: '/sales',
      icon: 'el-icon-shopping-cart-1',
      children: [{
        name: '采购任务',
        url: '/sales/purchaseTask'
      }]
    },
    {
      name: '产品中心',
      // url: '/product',
      icon: 'el-icon-shopping-bag-1',
      children: [{
        name: '销售产品',
        url: '/product/apparel',
        meta: {
          requiresAuth: true,
          permissions: ['PRODUCT']
        }
      }, {
        name: '款式管理',
        url: '/product/sample',
        icon: 'iconNone'
      }]
    },
    {
      name: '订单发货',
      // url: '/shipping',
      icon: 'el-icon-box',
      children: [{
        name: '收发任务单',
        url: '/shipping/tasks',
      }, {
        name: '收发货列表',
        url: '/shipping/shipping-receipt-sheet',
      }, {
        name: '差异复议',
        url: '/shipping/reconsider-order',
      }, {
        name: '对账任务',
        url: '/reconciliation/tasks/import',
      }, {
        name: '对账管理',
        url: '/reconciliation/manage/import',
      }]
    },
    {
      name: '外发收货',
      // url: '/receipt',
      icon: 'el-icon-receiving',
      children: [{
        name: '收发任务单',
        url: '/receipt/tasks',
      }, {
        name: '收发货列表',
        url: '/receipt/shipping-receipt-sheet',
      }, {
        name: '差异复议',
        url: '/shipping/reconsiders/export',
      }, {
        name: '对账任务',
        url: '/reconciliation/tasks/export',
      }, {
        name: '对账管理',
        url: '/reconciliation/manage/export',
      }]
    },
    {
      name: '资料中心',
      // url: '/product',
      icon: 'el-icon-tickets',
      children: [{
        name: '物料管理',
        url: '/product/material',
        icon: 'iconNone'
      }, {
        name: '节点配置',
        url: '/account/setting/progress-plan',
        icon: 'iconNone'
      }]
    },
    {
      name: '公司介绍',
      // url: '/account',
      icon: 'el-icon-office-building',
      children: [{
          name: '主页',
          url: '/account/index',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['ENT_INFO']
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
          name: '员工',
          url: '/account/b2b-customer',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['COMPANY_B2BCUSTOMER']
          }
        },
        {
          name: '合作商',
          url: '/account/cooperator',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['COMPANY_COOPERATOR']
          }
        },
        {
          name: '组织架构',
          url: '/account/b2b-unit',
          icon: 'iconNone'
        },
        {
          name: '角色',
          url: '/account/role',
          icon: 'iconNone'
        },
        {
          name: '地址管理',
          url: '/account/address',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['COMPANY_ADDRESS']
          }
        },
        {
          name: '账务配置',
          url: '/account/setting/payPlan',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['FACTORY_PAYPLAN']
          }
        }
      ]
    },
    {
      name: '报表中心',
      // url: '/report',
      icon: 'el-icon-s-data',
      children: [{
          name: '生产进度',
          url: '/report/production-progress',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['REPORT_PRODUCTION_PROGRESS']
          }
        }
        // {
        //   name: '收货单',
        //   url: 'receipt',
        //   icon: 'iconNone',
        // },
      ]
    },
    {
      name: '订单',
      // url: '/order',
      icon: 'el-icon-s-order',
      children: [{
          name: '需求订单',
          url: '/order/requirement',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['REQUIREMENT_ORDER']
          }
        },
        // {
        //   name: '报价单',
        //   url: '/order/quote',
        //   icon: 'iconNone'
        // },
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
          name: '销售订单',
          url: '/order/sales',
          icon: 'iconNone'
        },
        {
          name: '销售计划',
          url: '/order/salesProduction',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '合同',
      // url: '/contract',
      icon: 'el-icon-s-marketing',
      children: [{
          name: '合同管理',
          url: '/contract/manage',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['AGREEMENT']
          }
        },
        {
          name: '合同模板',
          url: '/contract/template',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['AGREEMENT_TMPL']
          }
        },
        {
          name: '签章管理',
          url: '/contract/seal',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['AGREEMENT_SEAL']
          }
        }
        // {
        //   name: '下单',
        //   url: '/orderPurchase',
        //   icon: 'iconNone',
        // },
        // {
        //   name: '创建合同',
        //   url: '/manage/createContract',
        //   icon: 'iconNone',
        // },
      ]
    },
    {
      name: '产品',
      // url: '/product',
      icon: 'el-icon-goods',
      children: [{
          name: '产品管理',
          url: '/product/apparel',
          meta: {
            requiresAuth: true,
            permissions: ['PRODUCT']
          }
          // icon: 'iconNone',
        },
        {
          name: '样衣管理',
          url: '/product/sample',
          icon: 'iconNone'
          // meta: {
          //   requiresAuth: true,
          //   permissions: ['PRODUCT_SAMPLEPRODUCT']
          // }
        },
        {
          name: '物料管理',
          url: '/product/material',
          icon: 'iconNone'
        }
        // {
        //   name: '样衣借还记录',
        //   url: '/miscs/sample/sampleCheckoutHist',
        //   icon: 'iconNone',
        // }
      ]
    },
    {
      name: '其他',
      // url: '/miscs',
      icon: 'el-icon-coin',
      children: [{
        name: '钱包',
        url: '/miscs/wallet',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['COMPANY_WALLET']
        }
      }]
    }
  ]
};
