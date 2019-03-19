export default {
  items: [
    {
      title: true,
      name: '云工厂',
      class: '',
      wrapper: {
        element: 'span',
        attributes: {}
      }
    },
    {
      name: '仪表盘',
      url: '/dashboard',
      icon: 'icon-speedometer'
    },
    {
      name: '产品管理',
      url: '/product',
      icon: 'icon-puzzle',
      children: [
        {
          name: '服装产品',
          url: '/product/apparel',
          icon: 'iconNone',
        }
      ]
    },
    {
      name: '订单管理',
      url: '/order',
      icon: 'icon-puzzle',
      children: [
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
          name: '打样单',
          url: '/order/proofing',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '工厂管理',
      url: '/factory/account',
      icon: 'icon-puzzle',
      children: [
        {
          name: '工厂设置',
          url: '/factory/account/factory',
          icon: 'iconNone'
        },
        {
          name: '员工',
          url: '/factory/account/employee',
          icon: 'iconNone'
        },
        {
          name: '组织架构',
          url: '/factory/account/org',
          icon: 'iconNone'
        },
        {
          name: '角色',
          url: '/factory/account/role',
          icon: 'iconNone'
        },
      ]
    },
    {
      name: '系统管理',
      url: '/system',
      icon: 'icon-puzzle',
      children: [
        {
          name: '地址管理',
          url: '/system/address',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '其他',
      url: 'miscs',
      icon: 'icon-puzzle',
      children: [
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
        }
      ]
    }
  ]
}
