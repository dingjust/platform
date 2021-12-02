export default {
  items: [
    // {
    //   title: true,
    //   name: '平台',
    //   class: '',
    //   wrapper: {
    //     element: 'span',
    //     attributes: {}
    //   }
    // },
    {
      name: '主页',
      url: '/dashboard',
      icon: 'el-icon-s-home'
    },
    {
      name: '任务',
      icon: 'el-icon-notebook-1',
      children: [
        {
          name: '工厂审阅',
          url: '/task/factory/review',
          icon: 'iconNone'
        },
        {
          name: '代运营审阅',
          url: '/task/agent-operation/review',
          icon: 'iconNone'
        },
        {
          name: '需求审阅',
          url: '/task/requirement/review',
          icon: 'iconNone'
        },
        {
          name: '账号注销审阅',
          url: '/task/account/logoff',
          icon: 'iconNone'
        },
        {
          name: '托管申请处理',
          url: '/task/trusteeship'
        }
      ]
    },
    {
      name: '产品',
      url: '/product',
      icon: 'el-icon-goods',
      children: [{
        name: '服装产品',
        url: '/product/apparel',
        icon: 'iconNone'
      },
      {
        name: '分类',
        url: '/product/category',
        icon: 'iconNone'
      },
      {
        name: '颜色',
        url: '/product/color',
        icon: 'iconNone'
      },
      {
        name: '尺码',
        url: '/product/size',
        icon: 'iconNone'
      }
      ]
    },
    {
      name: '商家',
      url: '/backoffice/customer',
      icon: 'el-icon-money',
      children: [{
        name: '品牌',
        url: '/user/brand',
        icon: 'iconNone'
      },
      {
        name: '工厂',
        url: '/user/factory',
        icon: 'iconNone'
      }, {
        name: '用户列表',
        url: '/user/customer',
        icon: 'iconNone'
      }
      ]
    },
    {
      name: '合同',
      icon: 'el-icon-s-marketing',
      children: [
        {
          name: '合同管理',
          url: '/contract/backstage',
          icon: 'iconNone'
        },
        {
          name: '模板管理',
          url: '/contract/template/backstage',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '订单',
      icon: 'el-icon-s-order',
      url: '/order',
      children: [{
        name: '需求订单',
        url: '/order/requirement',
        icon: 'iconNone'
      },
      {
        name: '报价单',
        url: '/order/quote',
        icon: 'iconNone'
      },
      {
        name: '生产订单',
        url: '/order/purchase',
        icon: 'iconNone'
      },
      {
        name: '打样订单',
        url: '/order/proofing',
        icon: 'iconNone'
      }, {
        name: '交易订单',
        url: '/order/pend-out',
        icon: 'iconNone'
      }, {
        name: '支付订单',
        url: '/order/payment',
        icon: 'iconNone'
      }, {
        name: '对账单',
        url: '/order/reconciliation-view',
        icon: 'iconNone'
      }
      ]
    },
    {
      name: '公司',
      url: '/account',
      icon: 'el-icon-user-solid',
      children: [
        {
          name: '员工',
          url: '/account/employee',
          icon: 'el-icon-user'
        },
        {
          name: '用户组',
          url: '/account/user-group',
          icon: 'iconNone'
        },
        {
          name: '角色',
          url: '/account/role',
          icon: 'iconNone'
        }
      ]
    },
    // {
    //   name: '报表',
    //   url: '/report',
    //   icon: 'el-icon-s-data',
    //   children: [{
    //       name: '生产进度',
    //       url: '/report/production-progress',
    //       icon: 'iconNone',
    //     },
    //     // {
    //     //   name: '收货单',
    //     //   url: 'receipt',
    //     //   icon: 'iconNone',
    //     // },
    //   ]
    // },
    {
      name: '活动',
      url: '/activity',
      icon: 'el-icon-collection',
      children: [
        {
          name: '积分记录',
          url: '/activity/points/record',
          icon: 'iconNone'
        },
        {
          name: '积分申请',
          url: '/activity/points/exchange',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '其他',
      url: '/miscs',
      icon: 'el-icon-coin',
      children: [
        // {
        //   name: '合同',
        //   icon: 'iconNone',
        //   children: [{
        //       name: '合同',
        //       url: '/contract/manage/contract',
        //       icon: 'iconNone',
        //     },
        //     {
        //       name: '合同模板',
        //       url: '/contract/template/template',
        //       icon: 'iconNone',
        //     },
        //     {
        //       name: '印章',
        //       url: '/contract/seal/seal',
        //       icon: 'iconNone',
        //     },
        //   ]
        // },
        {
          name: '轮播图配置',
          url: '/miscs/carousel',
          icon: 'iconNone'
        },
        {
          name: '产业集群配置',
          url: '/miscs/industrial-cluster',
          icon: 'iconNone'
        },
        {
          name: '标签配置',
          url: '/miscs/label',
          icon: 'iconNone'
        },
        {
          name: '使用教程',
          url: '/miscs/operationCourse',
          icon: 'iconNone'
        },
        {
          name: '提现',
          url: '/miscs/cashOutManager',
          icon: 'iconNone'
        },
        {
          name: '产品运营活动',
          url: '/miscs/promote',
          icon: 'iconNone'
        },
        {
          name: '公告',
          url: '/miscs/notice',
          icon: 'iconNone'
        },
        {
          name: '热门推荐',
          url: '/miscs/recommend/word',
          icon: 'iconNone'
        }
        // {
        //   name: '未分类',
        //   icon: 'iconNone',
        //   children: [{
        //       name: '下单',
        //       url: '/orderPurchase',
        //       icon: 'iconNone',
        //     },
        //     {
        //       name: '印章',
        //       url: '/unclassified/sealManagement',
        //       icon: 'iconNone',
        //     },
        //     // {
        //     //   name: '创建合同',
        //     //   url: '/unclassified/createContract',
        //     //   icon: 'iconNone',
        //     // },
        //     {
        //       name: '合同模板',
        //       url: '/unclassified/contractTemplate',
        //       icon: 'iconNone',
        //     }
        //   ]
        // },
      ]
    }
  ]
};
