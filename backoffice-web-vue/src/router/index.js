import Vue from 'vue';
import Router from 'vue-router';
// Containers
import Full from '@/containers/Full';
import {
  hasPermission
} from '@/auth/auth';

import {
  Message
} from 'element-ui';

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
          component: () => import( /* webpackChunkName: 'message' */ '@/views/user/message/MessagePage')
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
          name: '产品',
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
              path: 'sample',
              name: '样衣',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/product/sample/SampleProductsPage')
              // meta: {
              //   requiresAuth: true,
              //   permissions: ['PRODUCT']
              // }
            },
            {
              name: '样衣详情',
              path: 'sampleDetail',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/product/sample/details/SampleProductDetailsPage')
            },
            {
              name: '产品详情',
              path: 'apparelDetail',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/product/apparel/details/ApparelProductDetailsPage')
            },
            {
              path: 'capacity',
              name: '产能配置',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/capacity/capacityPage'),
              meta: {
                requiresAuth: true,
                permissions: ['FACTORY_CAPACITY']
              }
            }, {
              path: 'capacityPublish',
              name: '发布产能',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/capacity/capacityFormPage')
            },
            {
              path: 'sample/sampleProduct',
              name: '样衣管理',
              component: () => import( /* webpackChunkName: 'tenant-products' */ '@/views/miscs/sample/sampleProduct/SampleProductPage'),
              meta: {
                requiresAuth: true,
                permissions: ['PRODUCT_SAMPLEPRODUCT']
              }
            },
            {
              path: 'material',
              redirect: '/product/material',
              name: '物料',
              component: {
                render(c) {
                  return c('router-view');
                }
              },
              children: [{
                  path: '',
                  name: '物料管理',
                  component: () => import( /* webpackChunkName: 'material' */ '@/views/product/material/MaterialPage')
                },
                {
                  path: 'detail',
                  name: '物料详情',
                  component: () => import( /* webpackChunkName: 'material' */ '@/views/product/material/details/MaterialDetailsPage')
                },
                {
                  path: 'create',
                  name: '添加物料',
                  component: () => import( /* webpackChunkName: 'material' */ '@/views/product/material/details/MaterialDetailsPage')
                }
              ]
            }
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
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/sales/SalesOrderPage')
            },
            {
              path: 'sales/:code',
              name: '销售订单详情',
              props: true,
              component: () => import( /* webpackChunkName: 'tenant-orders' */ '@/views/order/sales/details/SalesOrderDetailsPage')
            }
          ]
        },
        {
          path: 'sales',
          redirect: '/sales/plan',
          name: '销售计划',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [{
              path: 'plan',
              name: '计划列表',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/SalesProduction')
            },
            {
              path: 'create/plan',
              name: '录入销售计划',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/form/SalesPlanForm')
            },
            {
              path: 'plan/:id',
              name: '销售计划详情',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/details/SalesPlanDetail')
            },
            {
              path: 'create/order',
              name: '录入销售订单',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/order/salesProduction/form/SalesOrderForm')
            },
            {
              path: 'order/:id',
              name: '销售订单详情',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/details/SalesOrderDetail')
            },
            {
              path: 'entry/:id',
              name: '生产明细',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-task/details/ProductionEntryDetail')
            },
            {
              path: 'create/production',
              name: '创建生产任务',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-task/ProductionTaskForm')
            },
            {
              path: 'production',
              name: '生产任务列表',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-task/ProductionTaskPage')
            },
            {
              path: 'production/:id',
              name: '生产任务详情',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-task/details/ProductionTaskDetail')
            },
            {
              path: 'outboundOrder',
              name: '外发订单列表',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/outbound-order/OutboundOrderPage')
            },
            {
              path: 'create/outboundOrder',
              name: '创建外发订单',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/outbound-order/form/OutboundOrderForm')
            },
            {
              path: 'outboundOrder/:code',
              name: '外发订单详情',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/outbound-order/details/OutboundOrderDetail')
            },
            {
              path: 'purchaseTask',
              name: '采购任务列表',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/purchase-task/PurchaseTaskPage')
            },
            {
              path: 'create/purchaseTask',
              name: '创建采购任务',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/purchase-task/form/PurchaseTaskForm')
            },
            {
              path: 'purchaseTask/:code',
              name: '采购任务详情',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/purchase-task/details/PurchaseTaskDetail')
            },
            {
              path: 'materials/detail',
              name: '物料单',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/purchase-task/materials-bill/MaterialsBillPage')
            },
            {
              path: 'progressOrder',
              name: '进度工单列表',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/progress-order/ProgressOrderPage')
            },
            {
              path: 'progressOrder/:code/edit',
              name: '编辑进度工单',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/progress-order/form/ProgressOrderForm')
            },
            {
              path: 'progressOrder/:code',
              name: '进度工单详情',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/progress-order/details/ProgressOrderDetail')
            },
            {
              path: 'productionOrder',
              name: '生产工单列表',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-order/ProductionOrders')
            },
            {
              path: 'create/productionOrder',
              name: '创建生产工单',
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-order/form/ProductionOrderForm')
            },
            {
              path: 'productionOrder/:code',
              name: '生产工单详情',
              props: true,
              component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-order/details/ProductionOrderDetail')
            }
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
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/account/MyPage')
            },
            // {
            //   path: 'authentication',
            //   name: '认证信息',
            //   component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/company/MyCompanyPage'),
            // },
            {
              path: 'Authentication',
              name: '认证中心',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/dashboard/authentication/AuthenticationPage'),
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
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/group/b2b-unit/B2BUnitPage')
            },
            {
              path: 'role',
              name: '角色',
              component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/role/RolePage')
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
                    component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/payPlan/form/PayPlanFormPage')
                  },
                  {
                    path: 'update',
                    name: '编辑新方案',
                    component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/payPlan/form/PayPlanEditFormPage')
                  }
                ]
              }, {
                path: 'progress-plan',
                name: '节点配置',
                redirect: '/account/setting/progress-plan',
                component: {
                  render(c) {
                    return c('router-view');
                  }
                },
                children: [{
                    path: '',
                    name: '节点方案列表',
                    component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/progress-plan/ProgressPlanPage'),
                  },
                  {
                    path: 'create',
                    name: '添加新节点',
                    component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/progress-plan/form/ProgressPlanForm')
                  },
                  {
                    path: 'update',
                    name: '编辑节点',
                    component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/progress-plan/form/ProgressPlanForm')
                  }
                ]
              }]
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
                  component: () => import( /* webpackChunkName: 'cooperator' */ '@/views/miscs/cooperator/form/CooperatorFormPage')
                },
                {
                  path: 'cooperatorUpdate',
                  name: '编辑合作商',
                  component: () => import( /* webpackChunkName: 'cooperator' */ '@/views/miscs/cooperator/form/CooperatorEditFormPage')
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
            }
          ]
        },
        {
          path: '/task',
          name: '任务',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [{
            path: 'handle',
            name: '待我处理',
            component: () => import( /* webpackChunkName: 'task' */ '@/views/task/handle/TaskHandlePage')
          }, {
            path: 'approval',
            name: '我的审批',
            component: () => import( /* webpackChunkName: 'task' */ '@/views/task/approval/TaskApprovalPage')
          }, {
            path: 'assign',
            name: '待我分配',
            component: () => import( /* webpackChunkName: 'task' */ '@/views/task/assign/TaskAssignPage')
          }]
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
              path: 'promote',
              name: '产品运营活动',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/promote/PromoteProductPage')
            },
            {
              path: 'label',
              name: '标签配置',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/label/LabelPage')
            },
            {
              path: '/miscs/sample/sampleCheckoutHist',
              name: '样衣借还记录',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/sample/sampleCheckoutHist/SampleCheckoutHistPage')
            }, {
              path: '/miscs/operationCourse',
              name: '使用教程',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/operation-course/OperationCoursePage')
            }, {
              path: '/miscs/wallet',
              name: '钱包',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/wallet/WalletPage'),
              meta: {
                requiresAuth: true,
                permissions: ['COMPANY_WALLET']
              }
            }, {
              path: '/miscs/cashOutManager',
              name: '提现管理',
              component: () => import( /* webpackChunkName: 'miscs' */ '@/views/miscs/cashOutManager/cashOutManagerPage')
            }
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
              component: () => import( /* webpackChunkName: 'contract' */ '@/views/contract/manage/ContractPage'),
              meta: {
                requiresAuth: true,
                permissions: ['AGREEMENT']
              }
            },
            {
              path: 'template',
              name: '合同模板',
              component: () => import( /* webpackChunkName: 'contract' */ '@/views/contract/template/TemplatePage'),
              meta: {
                requiresAuth: true,
                permissions: ['AGREEMENT_TMPL']
              }
            },
            {
              path: 'templateForm',
              name: '新建合同模板',
              component: () => import( /* webpackChunkName: 'contract' */ '@/views/contract/template/components/TemplateForm')
            },
            {
              path: 'seal',
              name: '印章管理',
              component: () => import( /* webpackChunkName: 'contract' */ '@/views/contract/seal/SealPage'),
              meta: {
                requiresAuth: true,
                permissions: ['AGREEMENT_SEAL']
              }
            }, {
              path: 'sealForm',
              name: '印章创建',
              component: () => import( /* webpackChunkName: 'contract' */ '@/views/contract/seal/sealForm')
            }
            // {
            //   path: '/manage/createContract',
            //   name: '创建合同',
            //   component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/contract/manage/createContract')
            // },
            //  {
            //   path: '/template/create',
            //   name: '创建模板',
            //   component: () => import( /* webpackChunkName: 'sealManagement' */ '@/views/contract/template/contractTemplate')
            // }
          ]
        },
        {
          path: 'shipping',
          redirect: '/shipping/orders',
          name: '发货',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [
            {
              path: 'tasks',
              name: '发货任务列表',
              component: () => import( /* webpackChunkName: 'shipping' */ '@/views/shipping/shipping-task/ShippingTasksPage')
            }, 
            {
              path: 'tasks/:id',
              name: '创建发货单',
              props: true,
              component: () => import( /* webpackChunkName: 'shipping' */ '@/views/shipping/shipping-task/details/ShippingTasksDetail')
            }, 
            // {
            //   path: 'orders',
            //   name: '发货单',
            //   component: () => import( /* webpackChunkName: 'shipping' */ '@/views/shipping/shipping-order/ShippingOrdersPage')
            // }, 
            // {
            //   path: 'orders/:id',
            //   name: '创建发货单',
            //   props: true,
            //   component: () => import( /* webpackChunkName: 'shipping' */ '@/views/shipping/shipping-order/details/ShippingOrdersDetail')
            // }, 
          ]
        },
        {
          path: 'receipt',
          redirect: '/receipt/orders',
          name: '收货',
          component: {
            render(c) {
              return c('router-view');
            }
          },
          children: [{
            path: 'orders',
            name: '收货单',
            component: () => import( /* webpackChunkName: 'shipping' */ '@/views/receipt/receipt-order/ReceiptOrdersPage')
          }, ]
        },
      ]
    },
    {
      path: '/login',
      name: '用户登录',
      component: () => import( /* webpackChunkName: 'login' */ 'shared/account/login/LoginPage')
    },
    {
      path: '/register',
      name: '用户注册',
      component: () => import( /* webpackChunkName: 'register' */ 'shared/account/register/RegisterPage')
    }
  ]
});

const LOGIN_URL = '/login';
const LOGOUT_URL = '/logout';
const REGISTER_URL = '/register';

// 路由守卫
router.beforeEach((to, from, next) => {
  const authorized = sessionStorage.getItem('authorized');
  if (!authorized && (to.path === LOGIN_URL || to.path === LOGOUT_URL || to.path === REGISTER_URL)) {
    next();
    return;
  }

  if (authorized) {
    //   // TODO: 检查权限
    //   if (to.meta.requiresAuth) {
    //     if (hasPermission(to.meta.permissions)) {
    //       return next();
    //     } else {
    //       Message.error("无权限访问");
    //       return next(false);
    //     }
    //   } else {
    return next() // 确保一定要调用 next()
    //   }
  }

  next({
    path: LOGIN_URL,
    query: {
      backUrl: to.fullPath
    }
  });
});

export default router;
