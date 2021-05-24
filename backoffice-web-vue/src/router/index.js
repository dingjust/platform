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
    component: Full,
    children: [{
      path: '/message',
      name: '用户消息',
      component: () => import(/* webpackChunkName: 'message' */ '@/views/user/message/MessagePage')
    },
    {
      path: '/orderPurchase',
      name: '下单',
      component: () => import(/* webpackChunkName: 'orderPurchase' */ '@/views/order/purchase/OrderPurchase')
    },
    {
      path: 'dashboard',
      name: '首页',
      component: () => import(/* webpackChunkName: 'Dashboard' */ '@/views/dashboard/Dashboard')
    },
    {
      path: 'product',
      redirect: '/product/apparel',
      name: '产品中心',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'color',
        name: '颜色',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/product/color/ColorPage')
      },
      {
        path: 'size',
        name: '尺码',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/product/size/SizePage')
      },
      {
        path: 'category',
        name: '分类',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/product/category/CategoryPage')
      },
      {
        path: 'apparel',
        name: 'B2B产品',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/product/apparel/ApparelProductPage')
      },
      {
        path: 'sample',
        name: '款式管理',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/product/sample/SampleProductsPage')
        // meta: {
        //   requiresAuth: true,
        //   permissions: ['PRODUCT']
        // }
      },
      {
        name: '样衣详情',
        path: 'sampleDetail',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/product/sample/details/SampleProductDetailsPage')
      },
      {
        name: '产品详情',
        path: 'apparelDetail',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/product/apparel/details/ApparelProductDetailsPage')
      },
      {
        path: 'capacity',
        name: '产能配置',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/capacity/capacityPage'),
        meta: {
          breadCrumbParentUrl: '/order/quote',
          breadCrumbParentName: '其他'
        }
      }, {
        path: 'capacityPublish',
        name: '发布产能',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/capacity/capacityFormPage')
      },
      {
        path: 'sample/sampleProduct',
        name: '样衣管理',
        component: () => import(/* webpackChunkName: 'tenant-products' */ '@/views/miscs/sample/sampleProduct/SampleProductPage')
      },
      {
        path: 'material',
        redirect: '/product/material',
        name: '物料',
        component: {
          render (c) {
            return c('router-view');
          }
        },
        children: [{
          path: '',
          name: '物料管理',
          component: () => import(/* webpackChunkName: 'material' */ '@/views/product/material/MaterialPage'),
          meta: {
            breadCrumbParentUrl: '/product',
            breadCrumbParentName: '产品中心',
            breadCrumbSkip: 1
          }
        },
        {
          path: 'detail',
          name: '物料详情',
          component: () => import(/* webpackChunkName: 'material' */ '@/views/product/material/details/MaterialDetailsPage')
        },
        {
          path: 'create',
          name: '添加物料',
          component: () => import(/* webpackChunkName: 'material' */ '@/views/product/material/details/MaterialDetailsPage')
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
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'brand',
        name: '品牌',
        component: () => import(/* webpackChunkName: 'tenant-users' */ '@/views/user/company/brand/BrandPage')
      },
      {
        path: 'factory',
        name: '工厂',
        component: () => import(/* webpackChunkName: 'tenant-users' */ '@/views/user/company/factory/FactoryPage')
      }, {
        path: 'customer',
        name: '用户列表',
        component: () => import(/* webpackChunkName: 'tenant-users' */ '@/views/user/company/customer/CustomerPage')
      }
      ]
    },
    {
      path: 'contract',
      redirect: '/contract/backstage',
      name: '合同',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [
        {
          path: 'backstage',
          name: '合同管理',
          component: () => import(/* webpackChunkName: 'contract-backstage' */ '@/views/contract/backManage/ContractBackPage')
        },
        {
          path: 'template/backstage',
          name: '模板管理',
          component: () => import(/* webpackChunkName: 'contract-backstage' */ '@/views/contract/backTemp/ContractBackTemp')
        }
      ]
    },
    {
      path: 'order',
      redirect: '/sales',
      name: '订单管理',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'requirement',
        name: '需求订单',
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/requirement/RequirementOrderPage')
      },
      {
        path: 'quote',
        name: '报价单',
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/quote/QuotePage'),
        meta: {
          breadCrumbParentUrl: '/order/quote',
          breadCrumbParentName: '其他'
        }
      },
      {
        path: 'proofing',
        name: '打样订单',
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/proofing/ProofingPage'),
        meta: {
          breadCrumbParentUrl: '/order/quote',
          breadCrumbParentName: '其他'
        }
      },
      {
        path: 'purchase',
        name: '生产订单',
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/purchase/PurchaseOrderPage'),
        meta: {
          breadCrumbParentUrl: '/order/quote',
          breadCrumbParentName: '其他'
        }
      },
      {
        path: 'production',
        name: '生产进度',
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/production/ProductionPage')
      },
      {
        path: 'sales',
        name: '销售订单',
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/sales/SalesOrderPage')
      },
      {
        path: 'sales/:code',
        name: '销售订单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/sales/details/SalesOrderDetailsPage')
      },
      {
        path: 'delivery-Reconciliation',
        name: '出货对账',
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/delivery-recon/DeliveryReconciliationPage')
      },
      {
        path: 'delivery/create',
        name: '创建出货单',
        props: true,
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/delivery-recon/delivery/form/DeliveryOrdersForm')
      },
      {
        path: 'delivery/:id',
        name: '出货单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/delivery-recon/delivery/detail/DeliveryOrdersDetail')
      },
      {
        path: 'reconciliation/create',
        name: '创建出货对账单',
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/delivery-recon/reconciliation/form/ReconciliationOrdersFormV2')
      },
      {
        path: 'reconciliation/:id',
        name: '出货对账单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'tenant-orders' */ '@/views/order/delivery-recon/reconciliation/detail/ReconciliationOrdersDetailV2')
      }
      ]
    },
    {
      path: 'sales',
      redirect: '/sales/plan',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'plan',
        name: '企划订单',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/SalesProduction')
      },
      {
        path: 'pending-order',
        name: '外接订单',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/PendingSalesProduction')
      },
      {
        path: 'create/plan',
        name: '录入企划订单',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/form/SalesPlanForm')
      },
      {
        path: 'plan/:id',
        name: '销售计划详情',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/details/SalesPlanDetail')
      },
      {
        path: 'create/order',
        name: '录入外接订单',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/order/salesProduction/form/SalesOrderForm')
      },
      {
        path: 'order/:id',
        name: '外接订单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/details/SalesOrderDetail')
      },
      {
        path: 'entry/:id',
        name: '生产明细',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-task/details/ProductionEntryDetail')
      },
      {
        path: 'create/production',
        name: '创建生产任务',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-task/ProductionTaskForm')
      },
        // {
        //   path: 'production',
        //   name: '生产任务列表',
        //   component: () => import( /* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-task/ProductionTaskPage')
        // },
      {
        path: 'production/:id',
        name: '生产任务详情',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-task/details/ProductionTaskDetail')
      },
      {
        path: 'outboundOrder',
        name: '外发订单列表',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/outbound-order/OutboundOrderPage'),
        meta: {
          breadCrumbParentUrl: '/sales/outboundOrder',
          breadCrumbParentName: '外发管理'
        }
      },
      {
        path: 'create/outboundOrder',
        name: '创建外发订单',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/outbound-order/form/OutboundOrderForm')
      },
      {
        path: 'create/outboundOrder/product',
        name: '创建产品外发',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/outbound-order/form/ProductOutboundOrderForm')
      },
      {
        path: 'outboundOrder/:code',
        name: '外发订单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/outbound-order/details/OutboundOrderDetail')
      },
      {
        path: 'progressOrder',
        name: '进度工单列表',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/progress-order/ProgressOrderPage'),
        meta: {
          breadCrumbParentUrl: '/sales/productionOrder',
          breadCrumbParentName: '生产管理'
        }
      },
      {
        path: 'progressOrder/create',
        name: '创建进度工单',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/progress-order/form/ProgressOrderForm')
      },
      {
        path: 'progressOrder/:code/edit',
        name: '编辑进度工单',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/progress-order/form/ProgressOrderForm')
      },
      {
        path: 'progressOrder/:code',
        name: '进度工单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/progress-order/details/ProgressOrderDetail'),
        meta: {
          breadCrumbParentUrl: '/sales/productionOrder',
          breadCrumbParentName: '生产管理'
        }
      },
      {
        path: 'productionOrder',
        name: '生产工单列表',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-order/ProductionOrders'),
        meta: {
          breadCrumbParentUrl: '/sales/productionOrder',
          breadCrumbParentName: '生产管理'
        }
      },
      {
        path: 'allocating/productionOrder',
        name: '待分配工单',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-order/AllocatingProductionOrders')
      },
      {
        path: 'outboundProductionOrder',
        name: '外发生产工单列表',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-order/OutboundProductionOrders'),
        meta: {
          breadCrumbParentUrl: '/sales/outboundOrder',
          breadCrumbParentName: '外发管理'
        }
      },
      {
        path: 'create/productionOrder',
        name: '创建生产工单',
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-order/form/ProductionOrderForm')
      },
      {
        path: 'productionOrder/:id',
        name: '生产工单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'sales' */ '@/views/order/salesProduction/production-order/details/ProductionOrderDetail'),
        meta: {
          breadCrumbParentUrl: '/sales/productionOrder',
          breadCrumbParentName: '生产管理'
        }
      }
      ]
    },
    {
      path: 'report',
      redirect: '/report/production-progress',
      name: '报表管理',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'production-progress',
        name: '生产进度报表',
        component: () => import(/* webpackChunkName: 'reports' */ '@/views/report/production-progress/ProductionProgressReportPage'),
        meta: {
          breadCrumbParentUrl: '/order/quote',
          breadCrumbParentName: '其他'
        }
      }, {
        path: 'receipt',
        name: '收货单报表',
        component: () => import(/* webpackChunkName: 'reports' */ '@/views/report/receipt/ReceiptReportPage')
      }]
    },
    {
      path: 'financial',
      redirect: '/financial/receivable',
      name: '财务管理',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'receivable',
        name: '应收账款',
        component: () => import(/* webpackChunkName: 'financial' */ '@/views/financial/receivable/ReceivablePage')
      }, {
        path: 'receivable/:id',
        name: '应收账款详情',
        props: true,
        component: () => import(/* webpackChunkName: 'financial' */ '@/views/financial/receivable/detail/ReceivableDetail')
      }, {
        path: 'payable',
        name: '应付账款',
        component: () => import(/* webpackChunkName: 'financial' */ '@/views/financial/payable/PayablePage')
      }, {
        path: 'payable/:id',
        name: '应付账款详情',
        props: true,
        component: () => import(/* webpackChunkName: 'financial' */ '@/views/financial/payable/detail/PayableDetail')
      }, {
        path: 'merchandiser/paymentRequest',
        name: '付款申请单(跟单员)',
        component: () => import(/* webpackChunkName: 'financial' */ '@/views/financial/payment-request/PaymentRequestMerchandiserPage')
      }, {
        path: 'finance/paymentRequest',
        name: '付款申请单(财务)',
        component: () => import(/* webpackChunkName: 'financial' */ '@/views/financial/payment-request/PaymentRequestFinancePage')
      }, {
        path: 'create/paymentRequest',
        name: '创建付款申请单',
        props: true,
        component: () => import(/* webpackChunkName: 'financial' */ '@/views/financial/payment-request/form/PaymentRequestForm')
      }, {
        path: 'merchandiser/paymentRequest/:id',
        name: '付款申请单详情（跟单）',
        props: true,
        component: () => import(/* webpackChunkName: 'financial' */ '@/views/financial/payment-request/detail/PaymentRequestDetailMerchandiser')
      }, {
        path: 'finance/paymentRequest/:id',
        name: '付款申请单详情（财务）',
        props: true,
        component: () => import(/* webpackChunkName: 'financial' */ '@/views/financial/payment-request/detail/PaymentRequestDetailFinance')
      }]
    },
    {
      path: 'purchase',
      redirect: '/purchase/requirement',
      name: '采购管理',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'requirement',
        name: '采购需求',
        component: () => import(/* webpackChunkName: 'purchase' */ '@/views/purchase/requirement/PurchaseRequirement')
      }, {
        path: 'requirement/create',
        name: '创建采购需求',
        component: () => import(/* webpackChunkName: 'purchase */ '@/views/purchase/requirement/form/PurchaseRequirementForm')
      }, {
        path: 'requirement/:id',
        name: '采购需求详情',
        props: true,
        component: () => import(/* webpackChunkName: 'purchase */ '@/views/purchase/requirement/details/PurchaseRequirementDetail')
      }, {
        path: 'worksheet',
        name: '采购工单',
        component: () => import(/* webpackChunkName: 'purchase' */ '@/views/purchase/worksheet/PurchaseWorksheetPage')
      }, {
        path: 'worksheet/:id',
        name: '采购工单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'purchase' */ '@/views/purchase/worksheet/details/PurchaseWorksheetDetail')
      }, {
        path: 'order',
        name: '采购单',
        component: () => import(/* webpackChunkName: 'purchase' */ '@/views/purchase/order/PurchaseOrderPage')
      }, {
        path: 'order/create',
        name: '创建采购单',
        props: true,
        component: () => import(/* webpackChunkName: 'purchase' */ '@/views/purchase/order/form/PurchaseOrderForm')
      }, {
        path: 'order/:id',
        name: '采购单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'purchase' */ '@/views/purchase/order/details/PurchaseOrderDetail')
      }, {
        path: 'cost',
        name: '成本单',
        component: () => import(/* webpackChunkName: 'cost' */ '@/views/purchase/cost/CostOrderPage')
      }, {
        path: 'cost/create',
        name: '创建成本单',
        component: () => import(/* webpackChunkName: 'cost' */ '@/views/purchase/cost/form/CostOrderForm')
      }, {
        path: 'cost/:id',
        name: '成本单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'cost' */ '@/views/purchase/cost/details/CostOrderDetail')
      },
      {
        path: 'cost/edit/:id',
        name: '编辑成本单',
        props: true,
        component: () => import(/* webpackChunkName: 'cost' */ '@/views/purchase/cost/form/CostOrderForm')
      },
      {
        path: 'quote',
        name: '报价单（新）',
        component: () => import(/* webpackChunkName: 'quote' */ '@/views/purchase/quoteV2/QuoteOrderPageV2')
      },
      {
        path: 'quote/create',
        name: '创建报价单',
        component: () => import(/* webpackChunkName: 'quote' */ '@/views/purchase/quoteV2/form/QuoteOrderFormV2')
      },
      {
        path: 'quote/:id',
        name: '报价单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'quote' */ '@/views/purchase/quoteV2/detail/QuoteOrderDetailV2')
      },
      {
        path: 'quote/edit/:id',
        name: '编辑报价单',
        props: true,
        component: () => import(/* webpackChunkName: 'quote' */ '@/views/purchase/quoteV2/form/QuoteOrderFormV2')
      },
      {
        path: 'profitloss',
        name: '盈亏分析',
        component: () => import(/* webpackChunkName: 'profitloss' */ '@/views/purchase/profit-loss/ProfitLossPage')
      },
      {
        path: 'profitloss/create',
        name: '创建盈亏分析',
        component: () => import(/* webpackChunkName: 'profitloss' */ '@/views/purchase/profit-loss/form/ProfitLossForm')
      }, {
        path: 'profitloss/edit/:id',
        name: '编辑盈亏分析',
        props: true,
        component: () => import(/* webpackChunkName: 'profitloss' */ '@/views/purchase/profit-loss/form/ProfitLossForm')
      }, {
        path: 'profitloss/:id',
        name: '盈亏分析详情',
        props: true,
        component: () => import(/* webpackChunkName: 'profitloss' */ '@/views/purchase/profit-loss/detail/ProfitLossDetail')
      }
      ]
    },
    {
      path: 'account',
      redirect: '/account/index',
      name: '企业管理',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'index',
        name: '公司介绍',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/company/MyCompanyPage'),
        meta: {
          breadCrumbParentUrl: '/account/index',
          breadCrumbParentName: '资料中心'
        }
      },
      {
        path: 'my',
        name: '我的',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/account/MyPage')
      },
        // {
        //   path: 'authentication',
        //   name: '认证信息',
        //   component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/company/MyCompanyPage'),
        // },
      {
        path: 'Authentication',
        name: '认证中心',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/dashboard/authentication/AuthenticationPage'),
        meta: {
          breadCrumbParentUrl: '/account/index',
          breadCrumbParentName: '企业管理'
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
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/group/user-group/UserGroupPage')
      },
        // {
        //   path: 'b2b-customer',
        //   redirect: '/account/b2b-customer',
        //   name: '员工',
        //   component: {
        //     render(c) {
        //       return c('router-view');
        //     }
        //   },
        //   children: [{
        //       path: '',
        //       name: '员工列表',
        //       component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/user/b2b-customer/B2BCustomerPage'),
        //       meta: {
        //         breadCrumbParentUrl:'/account/index',
        //         breadCrumbParentName:'企业管理',
        //         breadCrumbSkip:1
        //       }
        //     },
        //     {
        //       path: 'customerDetail',
        //       name: '添加员工',
        //       component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/user/b2b-customer/form/B2BCustomerBasicForm')
        //     }
        //   ]
        // },
        // {
        //   path: 'b2b-unit',
        //   name: '组织架构',
        //   component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/group/b2b-unit/B2BUnitPage')
        // },
      {
        path: 'organization',
        name: '组织架构',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/organization/OrganizationPage')
      },
        // {
        //   path: 'role',
        //   name: '角色',
        //   component: () => import( /* webpackChunkName: 'accounts' */ '@/views/user/role/RolePage')
        // },
      {
        path: 'organizationRole',
        name: '角色管理',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/organization/role/OrganizationRolePage')
      },
      {
        path: 'create/organizationRole',
        name: '创建角色',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/organization/role/form/OrganizationRoleForm')
      },
      {
        path: 'organizationRole/:id/edit',
        name: '编辑角色',
        props: true,
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/organization/role/form/OrganizationRoleForm')
      },
      {
        path: 'personnel',
        name: '员工管理',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/organization/personnel/PersonnelPage')
      },
      {
        path: 'create/personnel',
        name: '创建员工',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/organization/personnel/form/PersonnelForm')
      },
      {
        path: 'personnel/:id',
        name: '员工详情',
        props: true,
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/organization/personnel/Detail/PersonnelDetail')
      },
      {
        path: 'address',
        name: '地址管理',
        component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/address/AddressPage'),
        meta: {
          breadCrumbParentUrl: '/account/setting/progress-plan',
          breadCrumbParentName: '设置'
        }
      },
      {
        path: 'setting',
        name: '配置',
        component: {
          render (c) {
            return c('router-view');
          }
        },
        children: [{
          path: 'payPlan',
          component: {
            render (c) {
              return c('router-view');
            }
          },
          children: [{
            path: '',
            name: '账务方案列表',
            component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/payPlan/PayPlanPage'),
            meta: {
              breadCrumbParentUrl: '/account/setting/progress-plan',
              breadCrumbParentName: '设置',
              breadCrumbSkip: 2
            }
          },
          {
            path: 'create',
            name: '添加财务方案',
            component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/payPlan/form/PayPlanFormPage')
          },
          {
            path: 'update',
            name: '编辑财务方案',
            component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/payPlan/form/PayPlanEditFormPage')
          }
          ]
        }, {
          path: 'progress-plan',
          name: '节点配置',
          redirect: '/account/setting/progress-plan',
          component: {
            render (c) {
              return c('router-view');
            }
          },
          children: [{
            path: '',
            name: '节点方案列表',
            component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/progress-plan/ProgressPlanPage'),
            meta: {
              breadCrumbParentUrl: '/account/setting/progress-plan',
              breadCrumbParentName: '设置',
              breadCrumbSkip: 2
            }
          },
          {
            path: 'create',
            name: '添加新节点',
            component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/progress-plan/form/ProgressPlanForm')
          },
          {
            path: 'update',
            name: '编辑节点',
            component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/progress-plan/form/ProgressPlanForm')
          }
          ]
        },
        {
          path: 'reconciliation-plan',
          name: '对账配置',
          redirect: '/account/setting/reconciliation-plan',
          component: {
            render (c) {
              return c('router-view');
            }
          },
          children: [{
            path: '',
            name: '对账方案列表',
            component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/reconciliation-plan/ReconciliationPlanPage'),
            meta: {
              breadCrumbParentUrl: '/account/setting/reconciliation-plan',
              breadCrumbParentName: '设置',
              breadCrumbSkip: 2
            }
          },
          {
            path: 'create',
            name: '添加新方案',
            component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/reconciliation-plan/form/ReconciliationPlanForm')
          },
          {
            path: 'update',
            name: '编辑方案',
            component: () => import(/* webpackChunkName: 'accounts' */ '@/views/user/reconciliation-plan/form/ReconciliationPlanForm')
          }
          ]
        }
        ]
      },
      {
        path: 'cooperator',
        redirect: '/account/cooperator',
        name: '合作商',
        component: {
          render (c) {
            return c('router-view');
          }
        },
        children: [{
          path: 'cooperatorCreate',
          name: '添加合作商',
          component: () => import(/* webpackChunkName: 'cooperator' */ '@/views/miscs/cooperator/form/CooperatorFormPage')
        },
        {
          path: 'cooperatorUpdate',
          name: '编辑合作商',
          component: () => import(/* webpackChunkName: 'cooperator' */ '@/views/miscs/cooperator/form/CooperatorFormPage')
        },
        {
          path: '',
          name: '合作商列表',
          component: () => import(/* webpackChunkName: 'cooperator' */ '@/views/miscs/cooperator/CooperatorPage'),
          meta: {
            breadCrumbParentUrl: '/account/index',
            breadCrumbParentName: '企业管理',
            breadCrumbSkip: 1
          }
        }
        ]
      }
      ]
    },
    {
      path: '/task',
      name: '任务中心',
      redirect: '/task/handle',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [
        {
          path: 'handle',
          name: '待我处理',
          component: () => import(/* webpackChunkName: 'task' */ '@/views/task/handle/TaskHandlePage')
        }, {
          path: 'approval',
          name: '我的审批',
          component: () => import(/* webpackChunkName: 'task' */ '@/views/task/approval/TaskApprovalPage')
        }, {
          path: 'assign',
          name: '待我分配',
          component: () => import(/* webpackChunkName: 'task' */ '@/views/task/assign/TaskAssignPage')
        }, {
          path: 'factory/review',
          name: '工厂审阅',
          component: () => import(/* webpackChunkName: 'task' */ '@/views/task/factory-review/FactoryReview')
        }
      ]
    },
    {
      path: '/miscs',
      name: '其他',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'carousel',
        name: '轮播图配置',
        component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/carousel/CarouselPage')
      },
      {
        path: 'industrial-cluster',
        name: '产业集群配置',
        component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/industrial-cluster/IndustrialClusterPage')
      },
      {
        path: 'promote',
        name: '产品运营活动',
        component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/promote/PromoteProductPage')
      },
      {
        path: 'label',
        name: '标签配置',
        component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/label/LabelPage')
      },
      {
        path: '/miscs/sample/sampleCheckoutHist',
        name: '样衣借还记录',
        component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/sample/sampleCheckoutHist/SampleCheckoutHistPage')
      }, {
        path: '/miscs/operationCourse',
        name: '使用教程',
        component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/operation-course/OperationCoursePage')
      }, {
        path: '/miscs/wallet',
        name: '钱包',
        component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/wallet/WalletPage'),
        meta: {
          breadCrumbParentUrl: '/account/setting/progress-plan',
          breadCrumbParentName: '设置'
        }
      }, {
        path: '/miscs/cashOutManager',
        name: '提现管理',
        component: () => import(/* webpackChunkName: 'miscs' */ '@/views/miscs/cashOutManager/cashOutManagerPage')
      }
      ]
    },
    {
      path: '/contract',
      redirect: '/contract/manage',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'manage',
        name: '合同签订',
        component: () => import(/* webpackChunkName: 'contract' */ '@/views/contract/manage/ContractPage')
      },
      {
        path: 'template',
        name: '合同模板',
        component: () => import(/* webpackChunkName: 'contract' */ '@/views/contract/template/TemplatePage')
      },
      {
        path: 'templateForm',
        name: '新建合同模板',
        component: () => import(/* webpackChunkName: 'contract' */ '@/views/contract/template/components/TemplateForm')
      },
      {
        path: 'seal',
        name: '印章管理',
        component: () => import(/* webpackChunkName: 'contract' */ '@/views/contract/seal/SealPage')
      }, {
        path: 'SealForm',
        name: '印章创建',
        component: () => import(/* webpackChunkName: 'contract' */ '@/views/contract/seal/SealForm')
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
      redirect: '/shipping/tasks',
      name: '发货',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'tasks',
        name: '发货任务',
        component: () => import(/* webpackChunkName: 'shipping' */ '@/views/shipping-receipt/page/import/ImportShippingTasksPage'),
        meta: {
          breadCrumbParentUrl: '/sales/productionOrder',
          breadCrumbParentName: '生产管理'
        }
      },
      {
        path: 'tasks/:id',
        name: '任务详情',
        props: true,
        component: () => import(/* webpackChunkName: 'shipping' */ '@/views/shipping-receipt/shipping-task/details/ShippingTasksDetail')
      },
      {
        path: 'create/orders',
        name: '创建发货单',
        component: () => import(/* webpackChunkName: 'shipping' */ '@/views/shipping-receipt/shipping-order/form/ShippingOrdersForm')
      },
      {
        path: 'orders/:id',
        name: '发货单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'shipping' */ '@/views/shipping-receipt/shipping-order/details/ShippingOrdersDetail')
      },
      {
        path: 'shipping-receipt-sheet',
        name: '发货管理',
        component: () => import(/* webpackChunkName: 'shipping' */ '@/views/shipping-receipt/page/import/ImportShippingReceiptPage'),
        meta: {
          breadCrumbParentUrl: '/sales/productionOrder',
          breadCrumbParentName: '生产管理'
        }
      },
      {
        path: 'reconsider-order',
        name: '发货差异复议',
        component: () => import(/* webpackChunkName: 'shipping' */ '@/views/shipping-receipt/page/import/ImportReconsiderOrderPage'),
        meta: {
          breadCrumbParentUrl: '/sales/productionOrder',
          breadCrumbParentName: '生产管理'
        }
      },
      {
        path: 'reconciliation-manage',
        name: '发货对账管理',
        props: true,
        component: () => import(/* webpackChunkName: 'shipping' */ '@/views/shipping-receipt/page/import/ImportReconciliationManagePage'),
        meta: {
          breadCrumbParentUrl: '/sales/productionOrder',
          breadCrumbParentName: '生产管理'
        }
      }
      ]
    },
    {
      path: 'receipt',
      redirect: '/receipt/tasks',
      name: '收货',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'tasks',
        name: '收货任务',
        component: () => import(/* webpackChunkName: 'receipt' */ '@/views/shipping-receipt/page/export/ExportShippingTasksPage'),
        meta: {
          breadCrumbParentUrl: '/sales/outboundOrder',
          breadCrumbParentName: '外发管理'
        }
      },
      {
        path: 'shipping-receipt-sheet',
        name: '收货管理',
        component: () => import(/* webpackChunkName: 'receipt' */ '@/views/shipping-receipt/page/export/ExportShippingReceiptPage'),
        meta: {
          breadCrumbParentUrl: '/sales/outboundOrder',
          breadCrumbParentName: '外发管理'
        }
      },
      {
        path: 'orders/:id',
        name: '收货单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'receipt' */ '@/views/shipping-receipt/receipt-order/details/ReceiptOrderDetail')
      },
      {
        path: 'create/orders',
        name: '创建收货单',
        component: () => import(/* webpackChunkName: 'receipt' */ '@/views/shipping-receipt/receipt-order/form/ReceiptOrderForm')
      },
      {
        path: 'create/orders/self',
        name: '创建自管收货单',
        props: true,
        component: () => import(/* webpackChunkName: 'receipt' */ '@/views/shipping-receipt/receipt-order/form/SelfReceiptOrderForm')
      },
      {
        path: 'reconsider-order',
        name: '收货差异复议',
        component: () => import(/* webpackChunkName: 'receipt' */ '@/views/shipping-receipt/page/Export/ExportReconsiderOrderPage'),
        meta: {
          breadCrumbParentUrl: '/sales/outboundOrder',
          breadCrumbParentName: '外发管理'
        }
      },
      {
        path: 'reconciliation-manage',
        name: '收货对账管理',
        props: true,
        component: () => import(/* webpackChunkName: 'receipt' */ '@/views/shipping-receipt/page/export/ExportReconciliationManagePage'),
        meta: {
          breadCrumbParentUrl: '/sales/outboundOrder',
          breadCrumbParentName: '外发管理'
        }
      }
      ]
    },
    {
      path: 'returned',
      redirect: '/returned/orders',
      name: '退货',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'orders/:id',
        name: '退货单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'returned' */ '@/views/shipping-receipt/return-order/details/ReturnOrderDetail')
      },
      {
        path: 'create/orders',
        name: '创建退货单',
        component: () => import(/* webpackChunkName: 'returned' */ '@/views/shipping-receipt/return-order/form/ReturnOrdersForm')
      }
      ]
    },
    {
      path: 'reconsiders',
      redirect: '/reconsiders/orders',
      name: '复议',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'orders/:mode',
        name: '复议单列表',
        props: true,
        component: () => import(/* webpackChunkName: 'reconsiders' */ '@/views/shipping-receipt/reconsider-order/ReconsiderOrdersPage')
      },
      {
        path: 'create/orders/:id',
        name: '复议单表单',
        props: true,
        component: () => import(/* webpackChunkName: 'reconsiders' */ '@/views/shipping-receipt/reconsider-order/form/ReconsiderOrderForm')
      },
      {
        path: 'orders/detail/:id',
        name: '复议单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'reconsiders' */ '@/views/shipping-receipt/reconsider-order/details/ReconsiderOrderDetail')
      }
      ]
    },
    {
      path: 'reconciliation',
      redirect: '/reconciliation/orders',
      name: '对账',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [{
        path: 'orders',
        name: '对账单',
        component: () => import(/* webpackChunkName: 'reconciliation' */ '@/views/shipping-receipt/reconciliation-order/ReconciliationOrdersPage')
      }, {
        path: 'create/orders',
        name: '创建对账单',
        props: true,
        component: () => import(/* webpackChunkName: 'reconciliation' */ '@/views/shipping-receipt/reconciliation-order/form/ReconciliationOrdersForm')
      }, {
        path: 'orders/:id',
        name: '对账单详情',
        props: true,
        component: () => import(/* webpackChunkName: 'reconciliation' */ '@/views/shipping-receipt/reconciliation-order/details/ReconciliationOrdersDetail')
      }, {
        path: 'tasks/export',
        name: '外发对账任务',
        component: () => import(/* webpackChunkName: 'reconciliation' */ '@/views/shipping-receipt/page/export/ExportReconciliationTasksPage'),
        meta: {
          breadCrumbParentUrl: '/sales/outboundOrder',
          breadCrumbParentName: '外发管理'
        }
      }, {
        path: 'tasks/import',
        name: '订单对账任务',
        component: () => import(/* webpackChunkName: 'reconciliation' */ '@/views/shipping-receipt/page/import/ImportReconciliationTasksPage'),
        meta: {
          breadCrumbParentUrl: '/sales/productionOrder',
          breadCrumbParentName: '生产管理'
        }
      }, {
        path: 'tasks/detail/:id',
        name: '对账任务详情',
        props: true,
        component: () => import(/* webpackChunkName: 'reconciliation' */ '@/views/shipping-receipt/reconciliation-task/details/ReconciliationTasksDetail')
      }]
    },
    {
      path: 'activity',
      redirect: '/activity/points/record',
      name: '活动',
      component: {
        render (c) {
          return c('router-view');
        }
      },
      children: [
        {
          path: 'points/record',
          name: '积分记录',
          component: () => import(/* webpackChunkName: 'activity' */ '@/views/activity/points/PointsRecordPage')
        },
        {
          path: 'points/exchange',
          name: '积分申请',
          component: () => import(/* webpackChunkName: 'activity' */ '@/views/activity/points/PointsExchangePage')
        }
      ]
    }
    ]
  },
  {
    path: '/login',
    name: '用户登录',
    component: () => import(/* webpackChunkName: 'login' */ 'shared/account/login/LoginPage')
  },
  {
    path: '/register',
    name: '用户注册',
    component: () => import(/* webpackChunkName: 'register' */ 'shared/account/register/RegisterPage')
  },
  {
    path: '/password',
    name: '密码',
    component: {
      render (c) {
        return c('router-view');
      }
    },
    children: [{
      path: 'reset',
      name: '密码重置',
      component: () => import(/* webpackChunkName: 'password' */ 'shared/account/password/PasswordResetPage')
    },
    {
      path: 'success',
      name: '密码重置成功',
      component: () => import(/* webpackChunkName: 'password' */ 'shared/account/password/ResetSuccessPage')
    }
    ]
  },
  {
    path: '/404',
    component: () => import('@/views/error-page/404'),
    hidden: true
  },
  {
    path: '*',
    redirect: '/404',
    hidden: true
  }
  ]
});

// const LOGIN_URL = '/login';
// const LOGOUT_URL = '/logout';
// const REGISTER_URL = '/register';
// const PASSWORD_RESET_URL = '/password/reset';
// const RESET_SUCCESS_URL = '/password/success';

// 公开路径,不校验
const OPEN_URL = [
  '/login', '/logout', '/register', '/password/reset', '/password/success'
];

// 路由守卫
router.beforeEach((to, from, next) => {
  const authorized = sessionStorage.getItem('authorized');
  if (!authorized && (OPEN_URL.findIndex(val => val === to.path) !== -1)) {
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
    path: '/login',
    query: {
      backUrl: to.fullPath
    }
  });
});

export default router;
