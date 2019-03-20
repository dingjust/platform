export default {
  items: [
    {
      title: true,
      name: '平台',
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
          icon: 'iconNone'
        },
        {
          name: '分类',
          url: '/backoffice/product/category',
          icon: 'iconNone'
        },
        {
          name: '颜色',
          url: '/backoffice/product/color',
          icon: 'iconNone'
        },
        {
          name: '尺码',
          url: '/backoffice/product/size',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '商家管理',
      url: '/backoffice/customer',
      icon: 'icon-puzzle',
      children: [
        {
          name: '品牌',
          url: '/user/brand',
          icon: 'iconNone'
        },
        {
          name: '工厂',
          url: '/user/factory',
          icon: 'iconNone'
        },
      ]
    },
    {
      name: '订单管理',
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
          name: '生产订单',
          url: '/order/purchase',
          icon: 'iconNone'
        },
        {
          name: '打样订单',
          url: '/order/proofing',
          icon: 'iconNone'
        },
      ]
    },
    {
      name: '账户管理',
      url: '/backoffice/account',
      icon: 'icon-puzzle',
      children: [
        {
          name: '员工',
          url: '/backoffice/account/employee',
          icon: 'iconNone'
        },
        {
          name: '用户组',
          url: '/backoffice/account/group',
          icon: 'iconNone'
        },
        {
          name: '角色',
          url: '/backoffice/account/role',
          icon: 'iconNone'
        }
      ]
    }, {
      name: '系统管理',
      url: '/backoffice/system/carousel',
      icon: 'icon-puzzle',
      children: [
        {
          name: '轮播图配置',
          url: '/backoffice/system/carousel',
          icon: 'iconNone'
        },
        {
          name: '产业集群配置',
          url: '/backoffice/system/industrial-cluster',
          icon: 'iconNone'
        },
        {
          name: '标签配置',
          url: '/backoffice/system/label',
          icon: 'iconNone'
        },
      ]
    },
    {
      name: '报表管理',
      url: '/backoffice/report',
      icon: 'icon-puzzle',
      children: [
        {
          name: '生产进度报表',
          url: '/backoffice/report/production-progress',
          icon: 'iconNone',
        },
      ]
    }
  ]
};
