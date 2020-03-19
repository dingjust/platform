import Vue from 'vue';
import Router from 'vue-router';
// Containers
import Full from '@/containers/Full';
import {
  hasPermission
} from '@/auth/auth';

import { Message } from 'element-ui';


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
          path: '/message',
          name: '用户消息',
          component: () => import( /* webpackChunkName: 'register' */ '@/views/user/message/MessagePage')
        },
        {
          path: '/orderPurchase',
          name: '下单',
          component: () => import( /* webpackChunkName: 'orderPurchase' */ '@/views/order/purchase/OrderPurchase')
        },
        {
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
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/product/apparel/ApparelProductPage'),
              meta: {
                requiresAuth: true,
                permissions: ['PRODUCT']
              }
            },
            {
              name: '产品详情',
              path: 'apparelDetail',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/product/apparel/details/ApparelProductDetailsPage')
            },
            {
              path: 'capacity',
              name: '产能配置',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/capacity/capacityPage'),
              meta: {
                requiresAuth: true,
                permissions: ['FACTORY_CAPACITY']
              }
            }, {
              path: 'capacityPublish',
              name: '发布产能',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/capacity/capacityFormPage'),
            },
            {
              path: 'sample/sampleProduct',
              name: '样衣管理',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/sample/sampleProduct/SampleProductPage'),
              meta: {
                requiresAuth: true,
                permissions: ['PRODUCT_SAMPLEPRODUCT']
              }
            },
          ]
        },
        {
          path: 'user',
          redirect: '/user/brand',
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
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/requirement/RequirementOrderPage'),
              meta: {
                requiresAuth: true,
                permissions: ['REQUIREMENT_ORDER']
              }
            },
            {
              path: 'quote',
              name: '报价单',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/quote/QuotePage'),
              meta: {
                requiresAuth: true,
                permissions: ['QUOTE_ORDER']
              }
            },
            {
              path: 'proofing',
              name: '打样订单',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/proofing/ProofingPage'),
              meta: {
                requiresAuth: true,
                permissions: ['PROOFING_ORDER']
              }
            },
            {
              path: 'purchase',
              name: '生产订单',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/purchase/PurchaseOrderPage'),
              meta: {
                requiresAuth: true,
                permissions: ['PURCHASE_ORDER']
              }
            },
            {
              path: 'production',
              name: '生产进度',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/production/ProductionPage')
            },
            {
              path: 'sales',
              name: '销售订单',
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/sales/SalesOrderPage'),
            },
            {
              path: 'sales/:code',
              name: '销售订单详情',
              props:true,
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/sales/details/SalesOrderDetailsPage')
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
            component: () => import( /* webpackChunkName: 'reports' */ '@/views/report/production-progress/ProductionProgressReportPage'),
            meta: {
              requiresAuth: true,
              permissions: ['REPORT_PRODUCTION_PROGRESS']
            }
          }, {
            path: 'receipt',
            name: '收货单报表',
            component: () => import( /* webpackChunkName: 'reports' */ '@/views/report/receipt/ReceiptReportPage')
          }]
        },
        {
          path: 'account',
          redirect: '/account/index',
          name: '公司',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [{
              path: 'index',
              name: '主页',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/company/MyCompanyPage'),
              meta: {
                requiresAuth: true,
                permissions: ['ENT_INFO']
              }
            },
            {
              path: 'my',
              name: '我的',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/account/MyPage'),
            },
            // {
            //   path: 'authentication',
            //   name: '认证信息',
            //   component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/company/MyCompanyPage'),
            // },
            {
              path: 'Authentication',
              name: '认证中心',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/dashboard/authentication/AuthenticationPage'),
              meta: {
                requiresAuth: true,
                permissions: ['CERT']
              }
            },
            // {
            //   path: 'employee',
            //   name: '员工',
            //   component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/user/employee/EmployeePage')
            // },
            {
              path: 'user-group',
              name: '用户组',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/group/user-group/UserGroupPage')
            },
            {
              path: 'b2b-customer',
              redirect: '/account/b2b-customer',
              name: '员工',
              component: {
                render(c) {
                  return c('router-view');
                }
              },
              children: [{
                  path: '',
                  name: '员工列表',
                  component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/user/b2b-customer/B2BCustomerPage'),
                  meta: {
                    requiresAuth: true,
                    permissions: ['COMPANY_B2BCUSTOMER']
                  }
                },
                {
                  path: 'customerDetail',
                  name: '添加员工',
                  component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/user/b2b-customer/form/B2BCustomerBasicForm')
                }
              ]
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
              meta: {
                requiresAuth: true,
                permissions: ['COMPANY_ADDRESS']
              }
            },
            {
              path: 'setting',
              name: '配置',
              component: {
                render(c) {
                  return c('router-view');
                }
              },
              children: [{
                path: 'payPlan',
                name: '账务配置',
                component: {
                  render(c) {
                    return c('router-view');
                  }
                },
                children: [{
                    path: '',
                    name: '账务方案列表',
                    component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/payPlan/PayPlanPage'),
                    meta: {
                      requiresAuth: true,
                      permissions: ['FACTORY_PAYPLAN']
                    }
                  },
                  {
                    path: 'create',
                    name: '添加新方案',
                    component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/payPlan/form/PayPlanFormPage'),
                  },
                  {
                    path: 'update',
                    name: '编辑新方案',
                    component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/payPlan/form/PayPlanEditFormPage'),
                  },
                ]

              }, ]
            },
            {
              path: 'cooperator',
              redirect: '/account/cooperator',
              name: '合作商',
              component: {
                render(c) {
                  return c('router-view');
                }
              },
              children: [{
                  path: 'cooperatorCreate',
                  name: '添加合作商',
                  component: () => import( /* webpackChunkName: 'operationCourse' */ '@/views/miscs/cooperator/form/CooperatorFormPage')
                },
                {
                  path: 'cooperatorUpdate',
                  name: '编辑合作商',
                  component: () => import( /* webpackChunkName: 'operationCourse' */ '@/views/miscs/cooperator/form/CooperatorEditFormPage')
                },
                {
                  path: '',
                  name: '合作商列表',
                  component: () => import( /* webpackChunkName: 'cooperator' */ '@/views/miscs/cooperator/CooperatorPage'),
                  meta: {
                    requiresAuth: true,
                    permissions: ['COMPANY_COOPERATOR']
                  }
                }
              ]
            },
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
              path: '/miscs/sample/sampleCheckoutHist',
              name: '样衣借还记录',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/sample/sampleCheckoutHist/SampleCheckoutHistPage'),
            }, {
              path: '/miscs/operationCourse',
              name: '使用教程',
              component: () => import( /* webpackChunkName: 'operationCourse' */ '@/views/miscs/operation-course/OperationCoursePage')
            }, {
              path: '/miscs/wallet',
              name: '钱包',
              component: () => import( /* webpackChunkName: 'wallet' */ '@/views/miscs/wallet/WalletPage'),
              meta: {
                requiresAuth: true,
                permissions: ['COMPANY_WALLET']
              }
            }, {
              path: '/miscs/cashOutManager',
              name: '提现管理',
              component: () => import( /* webpackChunkName: 'cashOutManager' */ '@/views/miscs/cashOutManager/cashOutManagerPage')
            },
          ]
        },
        {
          path: '/contract',
          redirect: '/contract/manage',
          name: '合同',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [{
              path: 'manage',
              name: '合同管理',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/contract/manage/ContractPage'),
              meta: {
                requiresAuth: true,
                permissions: ['AGREEMENT']
              }
            },
            {
              path: 'template',
              name: '合同模板',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/contract/template/TemplatePage'),
              meta: {
                requiresAuth: true,
                permissions: ['AGREEMENT_TMPL']
              }
            },
            {
              path: 'templateForm',
              name: '新建合同模板',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/contract/template/components/TemplateForm')
            },
            {
              path: 'seal',
              name: '印章管理',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/contract/seal/SealPage'),
              meta: {
                requiresAuth: true,
                permissions: ['AGREEMENT_SEAL']
              }
            }, {
              path: 'sealForm',
              name: '印章创建',
              component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/contract/seal/sealForm')
            },
            // {
            //   path: '/manage/createContract',
            //   name: '创建合同',
            //   component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/contract/manage/createContract')
            // },
            // {
            //   path: '/unclassified/markDown',
            //   name: 'markdown',
            //   component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/unclassified/markDown')
            // }, {
            //   path: '/template/create',
            //   name: '创建模板',
            //   component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/contract/template/contractTemplate')
            // }
          ]
        },
      ]
    },
    {
      path: '/login',
      name: '用户登录',
      component: () => import( /* webpackChunkName: 'login' */ 'shared/account/login/LoginPage'),
    },
    {
      path: '/register',
      name: '用户注册',
      component: () => import( /* webpackChunkName: 'register' */ 'shared/account/register/RegisterPage')
    },
  ]
});

const LOGIN_URL = '/login';
const LOGOUT_URL = '/logout';
const REGISTER_URL = '/register';

//路由守卫
router.beforeEach((to, from, next) => {
  const authorized = sessionStorage.getItem('authorized');
  if (!authorized && (to.path === LOGIN_URL || to.path === LOGOUT_URL || to.path === REGISTER_URL)) {
    next();
    return;
  }

  if (authorized) {
    // TODO: 检查权限
    if (to.meta.requiresAuth) {
      if (hasPermission(to.meta.permissions)) {
        return next();
      } else {
        Message.error("无权限访问");
        return next(false);
      }
    } else {
      return next() // 确保一定要调用 next()
    }
  }

  next({
    path: LOGIN_URL,
    query: {
      backUrl: to.fullPath
    }
  });
});

export default router;
