// 需求订单
const requirementOrderPage = ['REQUIREMENT_ORDER_PAGE']
const requirementOrderPublish = ['REQUIREMENT_ORDER_PUBLISH']
const requirementOrderDetail = ['REQUIREMENT_ORDER_DETAIL']
const requirementOrderRecommended = ['REQUIREMENT_ORDER_RECOMMENDED']
const requirementOrderClose = ['REQUIREMENT_ORDER_CLOSE']
const requirementOrderChooseFactory = ['REQUIREMENT_ORDER_CHOOSEFACTORY']
const requirementOrderModify = ['REQUIREMENT_ORDER_MODIFY']

// 报价订单
const qutoOrderPage = ['QUTO_ORDER_PAGE']
const qutoOrderDetail = ['QUTO_ORDER_DETAIL']
const proofingOrderCreate = ['PROOFING_ORDER_CREATE']
const purchaseOrderCreate = ['PURCHASE_ORDER_CREATE']
const qutoOrderClose = ['QUTO_ORDER_CLOSE']

// 打样订单
const proofingOrderPage = ['PROOFING_ORDER_PAGE']
const proofingOrderView = ['PROOFING_ORDER_VIEW']
const proofingOrderDeliveryAddress = ['PROOFING_ORDER_DELIVERY_ADDRESS']
const proofingOrderClose = ['PROOFING_ORDER_CLOSE']

// 生产订单
const purchaseOrderPage = ['PURCHASE_ORDER_PAGE']
const purchaseOrderDetail = ['PURCHASE_ORDER_DETAIL']
const purchaseOrderOperate = ['PURCHASE_ORDER_OPERATE']
const purchaseOrderPayplanOp = ['PURCHASE_ORDER_PAYPLAN_OP']
const purchaseOrderClose = ['PURCHASR_ORDER_CLOSE']
const purchaseOrderAccept = ['PURCHASR_ORDER_ACCEPT']
const purchaseOrderReject = ['PURCHASR_ORDER_REJECT']
const purchaseOrderOfflineCreate = ['PURCHASR_ORDER_OFFLINE_CREATE']
const purchaseOrderUniqueCodeImport = ['PURCHASR_ORDER_UNIQUECODE_IMPORT']

// 合同管理
const agreementPage = ['AGREEMENT_PAGE']
const agreementSign = ['AGREEMENT_SIGN']

// 合同模板
const agreementTmplPage = ['AGREEMENT_TMPL_PAGE']
const agreementTmplCreate = ['AGREEMENT_TMPL_CREATE']
const agreementTmplView = ['AGREEMENT_TMPL_VIEW']
const agreementTmplDelete = ['AGREEMENT_TMPL_DELETE']

// 签章管理
const agreementSealPage = ['AGREEMENT_SEAL_PAGE']
const agreementSealCreate = ['AGREEMENT_SEAL_CREATE']
const agreementSealRemove = ['AGREEMENT_SEAL_REMOVE']

// 产品管理
const productPage = ['PRODUCT_PAGE']
const productCreate = ['PRODUCT_CREATE']
const productDelete = ['PRODUCT_DELETE']
const productModify = ['PRODUCT_MODIFY']

// 样衣管理
const productSampleProductPage = ['PRODUCT_SAMPLEPRODUCT_PAGE']
const productSampleProductCreate = ['PRODUCT_SAMPLEPRODUCT_CREATE']

// 产能配置（工厂）
const factoryCapacityPage = ['FACTORY_CAPACITY_PAGE']
const factoryCapacityModify = ['FACTORY_CAPACITY_MODIFY']
const factoryCapacityPublish = ['FACTORY_CAPACITY_PUBLISH']

// 主页

// 认证中心
const certPage = ['CERT_PAGE']

// 员工
const companyB2bCustomerPage = ['COMPANY_B2BCUSTOMER_PAGE']
const companyB2bCustomerCreate = ['COMPANY_B2BCUSTOMER_CREATE']
const companyB2bCustomerRemove = ['COMPANY_B2BCUSTOMER_REMOVE']
const companyB2bCustomerModify = ['COMPANY_B2BCUSTOMER_MODIFY']
const companyB2bCustomerEnableState = ['COMPANY_B2BCUSTOMER_ENABLESTATE']
const companyB2bCustomerHandOff = ['COMPANY_B2BCUSTOMER_HANDOFF']
const companyB2bDeptRename = ['COMPANY_B2BDEPT_RENAME']
const companyB2bDeptCreate = ['COMPANY_B2BDEPT_CREATE']
const companyB2bDeptRemove = ['COMPANY_B2BDEPT_REMOVE']
const companyB2bDeptSetManager = ['COMPANY_B2BDEPT_SET_MANAGER']
const companyB2bRoleCreate = ['COMPANY_B2BROLE_CREATE']
const companyB2bRoleRemove = ['COMPANY_B2BROLE_REMOVE']
const companyB2bRoleModify = ['COMPANY_B2BROLE_MODIFY']

// 合作商
const companyCooperatorPage = ['COMPANY_COOPERATOR_PAGE']
const companyCooperatorCreate = ['COMPANY_COOPERATOR_CREATE']
const companyCooperatorRemove = ['COMPANY_COOPERATOR_REMOVE']
const companyCooperatorModify = ['COMPANY_COOPERATOR_MODIFY']

// 地址管理
const companyAddressPage = ['COMPANY_ADDRESS_PAGE']
const companyAddressCreate = ['COMPANY_ADDRESS_CREATE']
const companyAddressRemove = ['COMPANY_ADDRESS_REMOVE']

// 财务配置
const factoryPayplanPage = ['FACTORY_PAYPLAN_PAGE']
const factoryPayplanCreate = ['FACTORY_PAYPLAN_CREATE']
const factoryPayplanModify = ['FACTORY_PAYPLAN_Modify']
const factoryPayplanRemove = ['FACTORY_PAYPLAN_REMOVE']

// 生产进度
const reportProductionProgressPage = ['REPORT_PRODUCTION_PROGRESS_PAGE']

// 钱包
const companyWalletPage = ['COMPANY_WALLET_PAGE']

export default {
  // 需求订单
  requirementOrderPage,
  requirementOrderPublish,
  requirementOrderDetail,
  requirementOrderRecommended,
  requirementOrderClose,
  requirementOrderChooseFactory,
  requirementOrderModify,

  // 报价订单
  qutoOrderPage,
  qutoOrderDetail,
  proofingOrderCreate,
  purchaseOrderCreate,
  qutoOrderClose,

  // 打样订单
  proofingOrderPage,
  proofingOrderView,
  proofingOrderDeliveryAddress,
  proofingOrderClose,

  // 生产订单
  purchaseOrderPage,
  purchaseOrderDetail,
  purchaseOrderOperate,
  purchaseOrderPayplanOp,
  purchaseOrderClose,
  purchaseOrderAccept,
  purchaseOrderReject,
  purchaseOrderOfflineCreate,
  purchaseOrderUniqueCodeImport,

  // 合同管理
  agreementPage,
  agreementSign,

  // 合同模板
  agreementTmplPage,
  agreementTmplCreate,
  agreementTmplView,
  agreementTmplDelete,

  // 签章管理
  agreementSealPage,
  agreementSealCreate,
  agreementSealRemove,

  // 产品管理
  productPage,
  productCreate,
  productDelete,
  productModify,

  // 样衣管理
  productSampleProductPage,
  productSampleProductCreate,

  // 产能配置（工厂）
  factoryCapacityPage,
  factoryCapacityModify,
  factoryCapacityPublish,

  // 主页

  // 认证中心
  certPage,

  // 员工
  companyB2bCustomerPage,
  companyB2bCustomerCreate,
  companyB2bCustomerRemove,
  companyB2bCustomerModify,
  companyB2bCustomerEnableState,
  companyB2bCustomerHandOff,
  companyB2bDeptRename,
  companyB2bDeptCreate,
  companyB2bDeptRemove,
  companyB2bDeptSetManager,
  companyB2bRoleCreate,
  companyB2bRoleRemove,
  companyB2bRoleModify,

  // 合作商
  companyCooperatorPage,
  companyCooperatorCreate,
  companyCooperatorRemove,
  companyCooperatorModify,

  // 地址管理
  companyAddressPage,
  companyAddressCreate,
  companyAddressRemove,

  // 财务配置
  factoryPayplanPage,
  factoryPayplanCreate,
  factoryPayplanModify,
  factoryPayplanRemove,

  // 生产进度
  reportProductionProgressPage,

  // 钱包
  companyWalletPage
}
