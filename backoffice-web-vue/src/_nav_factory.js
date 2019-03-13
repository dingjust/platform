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
      url: '/factory/dashboard',
      icon: 'icon-speedometer'
    },
    {
      name: '产品管理',
      url: '/factory/product',
      icon: 'icon-puzzle',
      children: [
        {
          name: '产品',
          icon: 'fa fa-check',
          children:[
            {
              name: '产品',
              url: '/factory/product/apparel',
              icon: 'iconNone',
            },
            {
              name: '产品（已删除）',
              url: '/factory/product/deleted',
              icon: 'iconNone',
            }
          ]
        },
        {
          name: '面辅料',
          url: '/factory/product/fabric',
          icon: 'iconNone'
        },
        {
          name: '库存',
          url: '/factory/product/inventory',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '订单管理',
      url: '/factory/order',
      icon: 'icon-puzzle',
      children: [
        {
          name: '生产订单',
          url: '/factory/order/consignment',
          icon: 'iconNone'
        },
        {
          name: '报价单',
          url: '/factory/order/quote',
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
        }
      ]
    }
  ]
}
