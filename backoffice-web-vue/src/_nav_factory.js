export default {
  items: [{
      name: '首页',
      url: '/dashboard',
      icon: 'el-icon-s-home'
    },
    {
      name: '任务中心',
      icon: 'el-icon-notebook-1',
      children: [
        //   {
        //   name: '待我处理',
        //   url: '/task/handle',
        //   icon: 'iconNone'
        // }, 
        {
          name: '我的审批',
          url: '/task/approval',
          icon: 'iconNone'
        },
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
      children: [{
        name: '企划订单',
        url: '/sales/plan'
      }, {
        name: '外接订单',
        url: '/sales/pending-order'
      }, {
        name: '销售订单',
        url: '/order/sales',
        icon: 'iconNone'
      }, ]
    },
    {
      name: '生产管理',
      icon: 'el-icon-notebook-2',
      children: [
        //   {
        //   name: '工单分配',
        //   url: '/sales/allocating/productionOrder'
        // }, 
        {
          name: '生产工单',
          url: '/sales/productionOrder',
        }, {
          name: '生产进度工单',
          url: '/sales/progressOrder'
        },
        //  {
        //   name: '发货任务',
        //   url: '/shipping/tasks',
        // }, 
        {
          name: '发货管理',
          url: '/shipping/shipping-receipt-sheet',
        }, {
          name: '差异复议',
          url: '/shipping/reconsider-order',
        },
        // {
        //   name: '对账任务',
        //   url: '/reconciliation/tasks/import',
        // },
        {
          name: '对账管理',
          url: '/shipping/reconciliation-manage',
        }
      ]
    },
    {
      name: '外发管理',
      icon: 'el-icon-notebook-2',
      children: [{
          name: '外发订单',
          url: '/sales/outboundOrder',
        }, {
          name: '外发生产工单',
          url: '/sales/outboundProductionOrder'
        },
        // {
        //   name: '收货任务',
        //   url: '/receipt/tasks',
        // }, 
        {
          name: '收货管理',
          url: '/receipt/shipping-receipt-sheet',
        },
        {
          name: '差异复议',
          url: '/receipt/reconsider-order',
        },
        // {
        //   name: '对账任务',
        //   url: '/reconciliation/tasks/export',
        // }, 
        {
          name: '对账管理',
          url: '/receipt/reconciliation-manage',
        }
      ]
    },
    {
      name: '产品中心',
      icon: 'el-icon-shopping-bag-1',
      children: [{
        name: 'B2B产品',
        url: '/product/apparel',
        meta: {
          requiresAuth: true,
          permissions: ['PRODUCT']
        }
      }, {
        name: '款式管理',
        url: '/product/sample',
        icon: 'iconNone'
        // meta: {
        //   requiresAuth: true,
        //   permissions: ['PRODUCT_SAMPLEPRODUCT']
        // }
      }, {
        name: '物料管理',
        url: '/product/material',
        icon: 'iconNone'
      }, ]
    },
    {
      name: '财务管理',
      icon: 'el-icon-s-finance',
      children: [{
        name: '应收账款',
        url: '/financial/receivable'
      }, {
        name: '应付账款',
        url: '/financial/payable'
      }, {
        name: '付款申请单(财务)',
        url: '/financial/finance/paymentRequest'
      }, {
        name: '付款申请单(跟单)',
        url: '/financial/merchandiser/paymentRequest'
      }]
    },
    {
      name: '企业管理',
      icon: 'el-icon-office-building',
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
          name: '员工管理',
          url: '/account/personnel',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['COMPANY_B2BCUSTOMER']
          }
        },
        {
          name: '组织架构',
          url: '/account/organization',
          icon: 'iconNone'
        },
        {
          name: '角色管理',
          url: '/account/organizationRole',
          icon: 'iconNone'
        },
        {
          name: '供应商管理',
          url: '/account/cooperator',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['COMPANY_COOPERATOR']
          }
        },
      ]
    },
    {
      name: '合同管理',
      // url: '/contract',
      icon: 'el-icon-s-marketing',
      children: [{
          name: '合同签订',
          url: '/contract/manage',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['AGREEMENT']
          }
        },
        {
          name: '模板管理',
          url: '/contract/template',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['AGREEMENT_TMPL']
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
      name: '设置',
      icon: 'el-icon-setting',
      children: [{
        name: '节点配置',
        url: '/account/setting/progress-plan',
        icon: 'iconNone'
      }, {
        name: '账务配置',
        url: '/account/setting/payPlan',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['FACTORY_PAYPLAN']
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
      }, ]
    },
    {
      name: '其他',
      // url: '/miscs',
      icon: 'el-icon-coin',
      children: [{
          name: '需求订单',
          url: '/order/requirement',
          icon: 'iconNone',
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
        // {
        //     name: '采购任务',
        //     url: '/sales/purchaseTask'
        //   }
      ]
    }
  ]
}
