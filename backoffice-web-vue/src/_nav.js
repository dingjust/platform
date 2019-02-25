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
      url: '/backoffice/dashboard',
      icon: 'icon-speedometer'
    },
    {
      name: '产品管理',
      url: '/backoffice/product',
      icon: 'icon-puzzle',
      children: [
        {
          name: '分类',
          url: '/backoffice/product/category',
          icon: 'iconNone'
        },
        {
          name: '产品',
          url: '/backoffice/product/product',
          icon: 'iconNone'
        },
        {
          name: '面辅料',
          url: '/backoffice/product/fabric',
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
        },
        {
          name: '风格',
          url: '/backoffice/product/style',
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
          url: '/backoffice/customer/brand',
          icon: 'iconNone'
        },
        {
          name: '工厂',
          url: '/backoffice/customer/factory',
          icon: 'iconNone'
        },
        {
          name: '待审核',
          url: '/backoffice/customer/audit',
          icon: 'fa fa-check',
          children: [
            {
              name: '待审核品牌商',
              url: '/backoffice/customer/audit/brand',
              icon: 'iconNone'
            },
            {
              name: '待审核工厂',
              url: '/backoffice/customer/audit/factory',
              icon: 'iconNone'
            }
          ]
        }
      ]
    },
    {
      name: '订单管理',
      url: '/backoffice/order',
      icon: 'icon-puzzle',
      children: [
        {
          name: '销售订单',
          url: '/backoffice/order/order',
          icon: 'iconNone'
        },
        {
          name: '需求订单',
          url: '/backoffice/order/request',
          icon: 'iconNone'
        },
        {
          name: '生产订单',
          url: '/backoffice/order/consignment',
          icon: 'iconNone'
        },
        {
          name: '发料单',
          url: '/backoffice/order/pick',
          icon: 'iconNone'
        }
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
      name: '系统配置管理',
      url: '/backoffice/system/carousel',
      icon: 'icon-puzzle',
      children: [
        {
          name: '轮播图配置',
          url: '/backoffice/system/carousel',
          icon: 'iconNone'
        },
        {
          name: '热销产品配置',
          url: '/backoffice/system/hot-products',
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
        {
          name: '优秀合作商配置',
          url: '/backoffice/system/partners',
          icon: 'iconNone'
        },
        {
          name: '商家轮播图配置',
          url: '/backoffice/system/collections',
          icon: 'iconNone'
        },
      ]
    }, {
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
