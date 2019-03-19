export default {
  items: [
    {
      title: true,
      name: '品牌',
      class: '',
      wrapper: {
        element: 'span',
        attributes: {}
      }
    },
    {
      name: '产品管理',
      url: '/brand/product',
      icon: 'icon-puzzle',
      children: [
        {
          name: '产品',
          icon: 'fa fa-check',
          children: [
            {
              name: '产品',
              url: '/brand/product/apparel',
              icon: 'iconNone',
            },
            {
              name: '产品（已删除）',
              url: '/brand/product/deleted',
              icon: 'iconNone',
            }
          ]
        },
        {
          name: '库存',
          url: '/brand/product/inventory',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '订单管理',
      url: '/order',
      icon: 'icon-puzzle',
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
      name: '店铺管理',
      url: '/brand/account',
      icon: 'icon-puzzle',
      children: [
        {
          name: '店铺',
          url: '/brand/account/store',
          icon: 'iconNone'
        },
        {
          name: '员工',
          url: '/brand/account/employee',
          icon: 'iconNone'
        },
        {
          name: '会员',
          url: '/brand/account/member',
          icon: 'iconNone'
        },
        {
          name: '组织架构',
          url: '/brand/account/org',
          icon: 'iconNone'
        },
        {
          name: '角色',
          url: '/brand/account/role',
          icon: 'iconNone'
        },
        {
          name: '我的关注',
          url: '/brand/account/follower',
          icon: 'iconNone'
        }
      ]
    }, {
      name: '系统管理',
      url: '/brand/system/zone',
      icon: 'icon-puzzle',
      children: [
        {
          name: '运费模板',
          url: '/brand/system/zone',
          icon: 'iconNone'
        },
        {
          name: '地址管理',
          url: '/brand/system/address',
          icon: 'iconNone'
        }
      ]
    }
  ]
};
