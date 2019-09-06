import Vue from 'vue';
import Router from 'vue-router';
// Containers
import Full from '@/containers/Full';

Vue.use(Router);

const router = new Router({
  mode: 'hash',
  linkActiveClass: 'open active',
  scrollBehavior: () => ({
    y: 0
  }),
  routes: [{
      path: '/',
      redirect: '/dashboard',
      name: '首页',
      component: Full,
      children: [{
          path: 'dashboard',
          name: '仪表盘',
          component: () => import( /* webpackChunkName: 'Dashboard' */ '@/views/dashboard/Dashboard')
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
          children: [{
              path: 'color',
              name: '颜色',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/product/color/ColorPage')
            },
            {
              path: 'size',
              name: '尺码',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/product/size/SizePage')
            },
            {
              path: 'category',
              name: '分类',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/product/category/CategoryPage')
            },
            {
              path: 'apparel',
              name: '服装产品',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/product/apparel/ApparelProductPage')
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
          children: [{
              path: 'brand',
              name: '品牌',
              component: () => import( /* webpackChunkName: 'tenant-users' */ '@/views/user/company/brand/BrandPage')
            },
            {
              path: 'factory',
              name: '工厂',
              component: () => import( /* webpackChunkName: 'tenant-users' */ '@/views/user/company/factory/FactoryPage')
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
          children: [{
              path: 'requirement',
              name: '需求订单',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/requirement/RequirementOrderPage')
            },
            {
              path: 'quote',
              name: '报价单',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/quote/QuotePage')
            },
            {
              path: 'proofing',
              name: '打样订单',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/proofing/ProofingPage')
            },
            {
              path: 'purchase',
              name: '生产订单',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/purchase/PurchaseOrderPage')
            },
            {
              path: 'production',
              name: '生产进度',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/production/ProductionPage')
            },
          ]
        },
        {
          path: 'report',
          redirect: '/report/production-progress',
          name: '报表管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [{
            path: 'production-progress',
            name: '生产进度报表',
            component: () => import( /* webpackChunkName: 'reports' */ '@/views/report/production-progress/ProductionProgressReportPage')
          }]
        },
        {
          path: 'account',
          name: '账户管理',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [{
              path: 'my',
              name: '认证信息',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/company/MyCompanyPage'),
            },
            {
              path: 'employee',
              name: '员工',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/user/employee/EmployeePage')
            },
            {
              path: 'user-group',
              name: '用户组',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/group/user-group/UserGroupPage')
            },
            {
              path: 'b2b-customer',
              name: '员工',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/user/b2b-customer/B2BCustomerPage'),
            },
            {
              path: 'b2b-unit',
              name: '组织架构',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/group/b2b-unit/B2BUnitPage'),
            },
            {
              path: 'role',
              name: '角色',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/role/RolePage'),
            },
            {
              path: 'address',
              name: '地址管理',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/address/AddressPage'),
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
          children: [{
              path: 'carousel',
              name: '轮播图配置',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/carousel/CarouselPage')
            },
            {
              path: 'industrial-cluster',
              name: '产业集群配置',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/industrial-cluster/IndustrialClusterPage')
            },
            {
              path: 'label',
              name: '标签配置',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/label/LabelPage')
            },
            {
              path: '/miscs/sample/sampleProduct',
              name: '样衣管理',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/sample/sampleProduct/SampleProductPage'),
            },
            {
              path: '/miscs/sample/sampleCheckoutHist',
              name: '样衣借还记录',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/sample/sampleCheckoutHist/SampleCheckoutHistPage'),
            }, {
              path: '/miscs/supplier',
              name: '供应商',
              component: () => import( /* webpackChunkName: 'supplier' */ '@/views/miscs/supplier/SupplierPage')
            }, {
              path: '/miscs/operationCourse',
              name: '使用教程',
              component: () => import( /* webpackChunkName: 'operationCourse' */ '@/views/miscs/operation-course/OperationCoursePage')
            }, {
              path: '/miscs/wallet',
              name: '钱包',
              component: () => import( /* webpackChunkName: 'wallet' */ '@/views/miscs/wallet/WalletPage')
            }, {
              path: '/miscs/cashOutManager',
              name: '提现管理',
              component: () => import( /* webpackChunkName: 'cashOutManager' */ '@/views/miscs/cashOutManager/cashOutManagerPage')
            },
            {
              path: '/Authentication',
              name: '认证中心',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/dashboard/authentication/AuthenticationPage')
            },
          ]
        },
        {
          path: '/contract',
          redirect: '/manage',
          name: '合同',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [{
              path: '/manage',
              name: '合同管理',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/contract/manage/ContractPage')
            },
            {
              path: '/template',
              name: '合同模板',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/contract/template/TemplatePage')
            },
            {
              path: '/templateForm',
              name: '新建合同模板',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/contract/template/components/TemplateForm')
            },
            {
              path: '/seal',
              name: '印章管理',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/contract/seal/SealPage')
            }, {
              path: '/orderPurchase',
              name: '下单',
              component: () => import( /* webpackChunkName: 'orderPurchase' */ '@/views/order/purchase/OrderPurchase')
            }, {
              path: '/sealForm',
              name: '印章创建',
              component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/contract/seal/sealForm')
            },
            // {
            //   path: '/manage/createContract',
            //   name: '创建合同',
            //   component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/contract/manage/createContract')
            // },
            {
              path: '/unclassified/markDown',
              name: 'markdown',
              component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/unclassified/markDown')
            }, {
              path: '/template/create',
              name: '创建模板',
              component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/contract/template/contractTemplate')
            }
          ]
        }
      ]
    },
    {
      path: '/login',
      name: '用户登录',
      component: () => import( /* webpackChunkName: 'login' */ 'shared/account/login/LoginPage')
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

  next({
    path: LOGIN_URL,
    query: {
      backUrl: to.fullPath
    }
  });
});

export default router;
