import Vue from 'vue';
import Router from 'vue-router';
// Containers
import Full from '@/containers/Full';

Vue.use(Router);

const router = new Router({
  mode: 'hash',
  linkActiveClass: 'open active',
  scrollBehavior: () => ({y: 0}),
  routes: [
    {
      path: '/',
      redirect: '/dashboard',
      name: '首页',
      component: Full,
      children: [
        {
          path: 'dashboard',
          name: '仪表盘',
          component: () => import(/* webpackChunkName: 'Dashboard' */ '@/views/dashboard/Dashboard')
        },
        {
          path: 'product',
          redirect: '/product/apparel',
          name: '产品管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'color',
              name: '颜色',
              component: () => import(/* webpackChunkName: 'tenant-products' */ 'backoffice/product/color/ColorPage')
            },
            {
              path: 'size',
              name: '尺码',
              component: () => import(/* webpackChunkName: 'tenant-products' */ 'backoffice/product/size/SizePage')
            },
            {
              path: 'category',
              name: '分类',
              component: () => import(/* webpackChunkName: 'tenant-products' */ 'backoffice/product/category/CategoryPage')
            },
            {
              path: 'apparel',
              name: '服装产品',
              component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/product/apparel/ApparelProductPage')
            }
          ]
        },
        {
          path: 'user',
          name: '商家管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'brand',
              name: '品牌',
              component: () => import(/* webpackChunkName: 'tenant-users' */ '@/views/user/company/brand/BrandPage')
            },
            {
              path: 'factory',
              name: '工厂',
              component: () => import(/* webpackChunkName: 'tenant-users' */ '@/views/user/company/factory/FactoryPage')
            },
          ]
        },
        {
          path: 'order',
          redirect: '/order/requirement',
          name: '订单管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'requirement',
              name: '需求订单',
              component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/requirement/RequirementOrderPage')
            },
            {
              path: 'quote',
              name: '报价单',
              component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/quote/QuotePage')
            },
            {
              path: 'proofing',
              name: '打样订单',
              component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/proofing/ProofingPage')
            },
            {
              path: 'purchase',
              name: '生产订单',
              component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/purchase/PurchaseOrderPage')
            },
          ]
        },
        {
          path: 'backoffice/system',
          redirect: '/backoffice/system/carousel',
          name: '系统管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'carousel',
              name: '轮播图配置',
              component: () => import(/* webpackChunkName: 'tenant-systems' */ 'backoffice/system/carousel/CarouselPage')
            },
            {
              path: 'industrial-cluster',
              name: '产业集群配置',
              component: () => import(/* webpackChunkName: 'tenant-systems' */ 'backoffice/system/industrial-cluster/IndustrialClusterPage')
            },
            {
              path: 'label',
              name: '标签配置',
              component: () => import(/* webpackChunkName: 'tenant-systems' */ 'backoffice/system/label/LabelPage')
            },
          ]
        },
        {
          path: 'backoffice/report',
          redirect: '/backoffice/report/production-progress',
          name: '报表管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'production-progress',
              name: '生产进度报表',
              component: () => import(/* webpackChunkName: 'tenant-reports' */ 'backoffice/report/productprogress/ProductionProgressPage')
            }
          ]
        },
        {
          path: 'account',
          name: '账户管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'brand',
              name: '认证信息',
              component: () => import(/* webpackChunkName: 'brand-accounts' */ 'brand/account/store/StorePage'),
            },
            {
              path: 'factory',
              name: '认证信息',
              component: () => import(/* webpackChunkName: 'factory-accounts' */ 'factory/account/factory/FactoryPage'),
            },
            {
              path: 'employee',
              name: '员工',
              component: () => import(/* webpackChunkName: 'tenant-accounts' */ '@/views/user/user/employee/EmployeePage')
            },
            {
              path: 'group',
              name: '用户组',
              component: () => import(/* webpackChunkName: 'tenant-accounts' */ 'backoffice/account/group/GroupPage')
            },
            {
              path: 'b2bcustomer',
              name: '员工',
              component: () => import(/* webpackChunkName: 'factory-accounts' */ 'factory/account/employee/EmployeePage'),
            },
            {
              path: 'org',
              name: '组织架构',
              component: () => import(/* webpackChunkName: 'factory-accounts' */ 'factory/account/org/OrgPage'),
            },
            {
              path: 'role',
              name: '角色',
              component: () => import(/* webpackChunkName: 'factory-accounts' */ 'factory/account/role/RolePage'),
            },
            {
              path: 'address',
              name: '地址管理',
              component: () => import(/* webpackChunkName: 'brand-systems' */ 'brand/system/address/AddressPage'),
            }
          ]
        },
        {
          path: '/miscs',
          name: '其他',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: '/miscs/sample/sampleProduct',
              name: '样衣管理',
              component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/sample/sampleProduct/SampleProductPage'),
            },
            {
              path: '/miscs/sample/sampleCheckoutHist',
              name: '样衣借还记录',
              component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/sample/sampleCheckoutHist/SampleCheckoutHistPage'),
            }
          ]
        },
      ]
    },
    {
      path: '/login',
      name: '用户登录',
      component: () => import(/* webpackChunkName: 'login' */ 'shared/account/login/LoginPage')
    }
  ]
});

const LOGIN_URL = '/login';
const LOGOUT_URL = '/logout';

router.beforeEach((to, from, next) => {
  const authorized = sessionStorage.getItem('authorized');
  if (!authorized && (to.path === LOGIN_URL || to.path === LOGOUT_URL)) {
    next();
    return;
  }

  if (authorized) {
    // TODO: 检查权限
    return next();
  }

  next({path: LOGIN_URL, query: {backUrl: to.fullPath}});
});

export default router;
