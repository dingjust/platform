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
    },
    {
      name: '产品管理',
      url: '/product',
      // icon: 'icon-puzzle',
      children: [
        {
          name: '服装产品',
          url: '/product/apparel',
          // icon: 'iconNone',
        }
      ]
    },
    {
      name: '订单管理',
      url: '/order',
      // icon: 'icon-puzzle',
      children: [
        {
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
          name: '打样单',
          url: '/order/proofing',
          icon: 'iconNone'
        },
        {
          name: '生产订单',
          url: '/order/purchase',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '合同',
      url: '/contract',
      children: [
        {
          name: '合同管理',
          url: '/manage',
          icon: 'iconNone',
        },
        {
          name: '合同模板',
          url: '/template',
          icon: 'iconNone',
        },
        {
          name: '印章管理',
          url: '/seal',
          icon: 'iconNone',
        },
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
        // {
        //   name: 'markdown',
        //   url: '/unclassified/markDown',
        //   icon: 'iconNone',
        // },
        {
          name: '合同模板',
          url: '/template/create',
          icon: 'iconNone',
        }
      ]
    },
    {
      name: '账户管理',
      url: '/account',
      // icon: 'icon-puzzle',
      children: [
        {
          name: '认证信息',
          url: '/account/my',
          icon: 'iconNone'
        },
        {
          name: '员工',
          url: '/account/b2b-customer',
          icon: 'iconNone'
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
          name: '地址',
          url: '/account/address',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '其他',
      url: '/miscs',
      // icon: 'icon-puzzle',
      children: [
        {
          name: '合同',
          url: '/contract',
          children: [
            {
              name: '合同管理',
              url: '/manage',
              icon: 'iconNone',
            },
            {
              name: '合同模板',
              url: '/template',
              icon: 'iconNone',
            },
            {
              name: '印章管理',
              url: '/seal',
              icon: 'iconNone',
            },
            {
              name: '下单',
              url: '/unclassified/orderPurchase',
              icon: 'iconNone',
            },
            // {
            //   name: '创建合同',
            //   url: '/manage/createContract',
            //   icon: 'iconNone',
            // },
            {
              name: 'markdown',
              url: '/unclassified/markDown',
              icon: 'iconNone',
            },
            {
              name: '合同模板',
              url: '/template/create',
              icon: 'iconNone',
            }
          ]
        },
        {
          name: '认证中心',
          url: '/Authentication',
          icon: 'iconNone',
        },
        {
          name: '样衣管理',
          icon: 'fa fa-check',
          children: [
            {
              name: '样衣',
              url: '/miscs/sample/sampleProduct',
              icon: 'iconNone',
            },
            {
              name: '样衣借还记录',
              url: '/miscs/sample/sampleCheckoutHist',
              icon: 'iconNone',
            }
          ]
        },
        {
          name: '供应商',
          url: '/miscs/supplier',
          icon: 'iconNone',
        },
        {
          name: '钱包',
          url: '/miscs/wallet',
          icon: 'iconNone',
        }
      ]
    }
  ]
};
