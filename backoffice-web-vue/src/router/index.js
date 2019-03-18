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
      name: '首页',
      component: Full,
      children: [
        {
          path: 'backoffice/dashboard',
          name: '仪表盘',
          component: () => import(/* webpackChunkName: 'Dashboard' */ 'backoffice/Dashboard')
        },
        {
          path: 'backoffice/product',
          redirect: '/backoffice/product/product',
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
              name: '产品',
              component: () => import(/* webpackChunkName: 'tenant-products' */ 'backoffice/product/apparel/ApparelProductPage')
            },
            {
              path: 'fabric',
              name: '面辅料',
              component: () => import(/* webpackChunkName: 'tenant-products' */ 'backoffice/product/fabric/FabricProductPage')
            }
          ]
        },
        {
          path: 'backoffice/customer',
          redirect: '/backoffice/customer/brand',
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
              component: () => import(/* webpackChunkName: 'tenant-customers' */ 'backoffice/customer/brand/BrandPage')
            },
            {
              path: 'factory',
              name: '工厂',
              component: () => import(/* webpackChunkName: 'tenant-customers' */ 'backoffice/customer/factory/FactoryPage')
            },
            {
              path: 'audit/brand',
              name: '待审核品牌商',
              component: () => import(/* webpackChunkName: 'tenant-customers' */ 'backoffice/account/audit/BrandAuditPage')
            },
            {
              path: 'audit/factory',
              name: '待审核工厂',
              component: () => import(/* webpackChunkName: 'tenant-customers' */ 'backoffice/account/audit/FactoryAuditPage')
            }
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
          path: 'backoffice/account',
          redirect: '/backoffice/account/audit/brand',
          name: '账户管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'employee',
              name: '员工',
              component: () => import(/* webpackChunkName: 'tenant-accounts' */ 'backoffice/account/employee/EmployeePage')
            },
            {
              path: 'group',
              name: '用户组',
              component: () => import(/* webpackChunkName: 'tenant-accounts' */ 'backoffice/account/group/GroupPage')
            },
            {
              path: 'role',
              name: '角色',
              component: () => import(/* webpackChunkName: 'tenant-accounts' */ 'backoffice/account/role/RolePage')
            }
          ]
        },
        {
          path: 'backoffice/system',
          redirect: '/backoffice/system/carousel',
          name: '系统配置管理',
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
          path: 'brand/dashboard',
          name: '仪表盘',
          component: () => import(/* webpackChunkName: 'Dashboard' */ 'brand/Dashboard')
        },
        {
          path: 'brand/product',
          redirect: '/brand/product/apparel',
          name: '产品管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'apparel',
              name: '产品',
              component: () => import(/* webpackChunkName: 'brand-products' */ 'brand/product/apparel/ApparelProductPage'),
            },
            {
              path: 'deleted',
              name: '已删除产品',
              component: () => import(/* webpackChunkName: 'brand-products' */ 'brand/product/apparel/ApparelProductDeletedPage'),
            }
          ]
        },
        {
          path: 'brand/account',
          redirect: '/brand/account/employee',
          name: '店铺管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'store',
              name: '店铺',
              component: () => import(/* webpackChunkName: 'brand-accounts' */ 'brand/account/store/StorePage'),
            },
            {
              path: 'employee',
              name: '员工',
              component: () => import(/* webpackChunkName: 'brand-accounts' */ 'brand/account/employee/EmployeePage'),
            },
            {
              path: 'member',
              name: '会员',
              component: () => import(/* webpackChunkName: 'brand-accounts' */ 'brand/account/member/MemberPage'),
            },
            {
              path: 'org',
              name: '组织架构',
              component: () => import(/* webpackChunkName: 'brand-accounts' */ 'brand/account/org/OrgPage'),
            },
            {
              path: 'role',
              name: '角色',
              component: () => import(/* webpackChunkName: 'brand-accounts' */ 'brand/account/role/RolePage'),
            },
            {
              path: 'follower',
              name: '我的关注',
              component: () => import(/* webpackChunkName: 'brand-accounts' */ 'brand/account/follower/MyFollowersPage'),
            }
          ]
        },
        {
          path: 'brand/system',
          redirect: '/brand/system/zone',
          name: '系统管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'zone',
              name: '运费模板',
              component: () => import(/* webpackChunkName: 'brand-systems' */ 'brand/system/zone/ZoneDeliveryPage'),
            },
            {
              path: 'address',
              name: '地址管理',
              component: () => import(/* webpackChunkName: 'brand-systems' */ 'brand/system/address/AddressPage'),
            }
          ]
        },
        {
          path: 'factory/product',
          redirect: '/factory/product/apparel',
          name: '产品管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'apparel',
              name: '产品',
              component: () => import(/* webpackChunkName: 'brand-products' */ 'factory/product/apparel/ApparelProductPage'),
            },
            {
              path: 'deleted',
              name: '已删除产品',
              component: () => import(/* webpackChunkName: 'brand-products' */ 'factory/product/apparel/ApparelProductDeletedPage'),
            },
            {
              path: 'fabric',
              name: '面辅料',
              component: () => import(/* webpackChunkName: 'factory-products' */ 'factory/product/fabric/FabricProductPage'),
            },
            {
              path: 'inventory',
              name: '库存',
              component: () => import(/* webpackChunkName: 'factory-products' */ 'factory/product/inventory/InventoryPage'),
            }
          ]
        },
        {
          path: 'factory/account',
          redirect: '/factory/account/factory',
          name: '工厂管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'factory',
              name: '工厂设置',
              component: () => import(/* webpackChunkName: 'factory-accounts' */ 'factory/account/factory/FactoryPage'),
            },
            {
              path: 'employee',
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
            }
          ]
        }
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
