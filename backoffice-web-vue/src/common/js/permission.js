// 需求订单
const requirementOrder = ['REQUIREMENT_ORDER']
const requirementOrderPublish = ['REQUIREMENT_ORDER_PUBLISH']
const requirementOrderDetail = ['REQUIREMENT_ORDER_DETAIL']
const requirementOrderRecommended = ['REQUIREMENT_ORDER_RECOMMENDED']
const requirementOrderClose = ['REQUIREMENT_ORDER_CLOSE']
const requirementOrderChooseFactory = ['REQUIREMENT_ORDER_CHOOSEFACTORY']
const requirementOrderModify = ['REQUIREMENT_ORDER_MODIFY']

// 报价订单
const quoteOrder = ['QUOTE_ORDER']
const quoteOrderDetail = ['QUOTE_ORDER_DETAIL']
const proofingOrderCreate = ['PROOFING_ORDER_CREATE']
const purchaseOrderCreate = ['PURCHASE_ORDER_CREATE']
const quoteOrderClose = ['QUOTE_ORDER_CLOSE']

// 打样订单
const proofingOrder = ['PROOFING_ORDER']
const proofingOrderView = ['PROOFING_ORDER_VIEW']
const proofingOrderDeliveryAddress = ['PROOFING_ORDER_DELIVERYADDRESS']
const proofingOrderClose = ['PROOFING_ORDER_CLOSE']

// 生产订单
const purchaseOrder = ['PURCHASE_ORDER']
const purchaseOrderDetail = ['PURCHASE_ORDER_DETAIL']
const purchaseOrderOperate = ['PURCHASE_ORDER_OPERATE']
const purchaseOrderPayplanOp = ['PURCHASE_ORDER_PAYPLAN_OP']
const purchaseOrderClose = ['PURCHASE_ORDER_CLOSE']
const purchaseOrderOfflineCreate = ['PURCHASE_ORDER_OFFLINE_CREATE']
const purchaseOrderUniqueCodeImport = ['PURCHASE_ORDER_UNIQUECODE_IMPORT']
const purchaseOrderConfirmDelivering = ['PURCHASE_ORDER_CONFIRM_DELIVERING']
const purchaseOrderConfirmReceived = ['PURCHASE_ORDER_CONFIRM_RECEIVED']
const purchaseOrderConfirm = ['PURCHASE_ORDER_CONFIRM']
const purchaseOrderReconciliation = ['PURCHASE_ORDER_RECONCILIATION']

// 合同管理
const agreement = ['AGREEMENT']
const agreementSign = ['AGREEMENT_SIGN']

// 合同模板
const agreementTmpl = ['AGREEMENT_TMPL']
const agreementTmplCreate = ['AGREEMENT_TMPL_CREATE']
const agreementTmplView = ['AGREEMENT_TMPL_VIEW']
const agreementTmplDelete = ['AGREEMENT_TMPL_DELETE']

// 签章管理
const agreementSeal = ['AGREEMENT_SEAL']
const agreementSealCreate = ['AGREEMENT_SEAL_CREATE']
const agreementSealRemove = ['AGREEMENT_SEAL_REMOVE']

// 产品管理
const product = ['PRODUCT']
const productCreate = ['PRODUCT_CREATE']
const productDelete = ['PRODUCT_DELETE']
const productModify = ['PRODUCT_MODIFY']

// 样衣管理
const productSampleProduct = ['PRODUCT_SAMPLEPRODUCT']
const productSampleProductCreate = ['PRODUCT_SAMPLEPRODUCT_CREATE']

// 产能配置（工厂）
const factoryCapacity = ['FACTORY_CAPACITY']
const factoryCapacityModify = ['FACTORY_CAPACITY_MODIFY']
const factoryCapacityPublish = ['FACTORY_CAPACITY_PUBLISH']

// 主页

// 认证中心
const cert = ['CERT']

// 员工
const companyB2bCustomer = ['COMPANY_B2BCUSTOMER']
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

const companyB2bDeptCR = ['COMPANY_B2BDEPT_CREATE', 'COMPANY_B2BDEPT_REMOVE']
const companyB2bRoleMR = ['COMPANY_B2BROLE_CREATE', 'COMPANY_B2BROLE_MODIFY']

// 合作商
const companyCooperator = ['COMPANY_COOPERATOR']
const companyCooperatorCreate = ['COMPANY_COOPERATOR_CREATE']
const companyCooperatorRemove = ['COMPANY_COOPERATOR_REMOVE']
const companyCooperatorModify = ['COMPANY_COOPERATOR_MODIFY']

// 地址管理
const companyAddress = ['COMPANY_ADDRESS']
const companyAddressCreate = ['COMPANY_ADDRESS_CREATE']
const companyAddressRemove = ['COMPANY_ADDRESS_REMOVE']

// 财务配置
const factoryPayplan = ['FACTORY_PAYPLAN']
const factoryPayplanCreate = ['FACTORY_PAYPLAN_CREATE']
const factoryPayplanModify = ['FACTORY_PAYPLAN_MODIFY']
const factoryPayplanRemove = ['FACTORY_PAYPLAN_REMOVE']

// 生产进度
const reportProductionProgress = ['REPORT_PRODUCTION_PROGRESS']

// 其他
const companyWallet = ['COMPANY_WALLET']
const msgDelete = ['MSG_DELETE']

export default {
  // 需求订单
  requirementOrder,
  requirementOrderPublish,
  requirementOrderDetail,
  requirementOrderRecommended,
  requirementOrderClose,
  requirementOrderChooseFactory,
  requirementOrderModify,

  // 报价订单
  quoteOrder,
  quoteOrderDetail,
  proofingOrderCreate,
  purchaseOrderCreate,
  quoteOrderClose,

  // 打样订单
  proofingOrder,
  proofingOrderView,
  proofingOrderDeliveryAddress,
  proofingOrderClose,

  // 生产订单
  purchaseOrder,
  purchaseOrderDetail,
  purchaseOrderOperate,
  purchaseOrderPayplanOp,
  purchaseOrderClose,
  purchaseOrderOfflineCreate,
  purchaseOrderUniqueCodeImport,
  purchaseOrderConfirmDelivering,
  purchaseOrderConfirmReceived,
  purchaseOrderConfirm,
  purchaseOrderReconciliation,

  // 合同管理
  agreement,
  agreementSign,

  // 合同模板
  agreementTmpl,
  agreementTmplCreate,
  agreementTmplView,
  agreementTmplDelete,

  // 签章管理
  agreementSeal,
  agreementSealCreate,
  agreementSealRemove,

  // 产品管理
  product,
  productCreate,
  productDelete,
  productModify,

  // 样衣管理
  productSampleProduct,
  productSampleProductCreate,

  // 产能配置（工厂）
  factoryCapacity,
  factoryCapacityModify,
  factoryCapacityPublish,

  // 主页

  // 认证中心
  cert,

  // 员工
  companyB2bCustomer,
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
  companyB2bDeptCR,
  companyB2bRoleMR,

  // 合作商
  companyCooperator,
  companyCooperatorCreate,
  companyCooperatorRemove,
  companyCooperatorModify,

  // 地址管理
  companyAddress,
  companyAddressCreate,
  companyAddressRemove,

  // 财务配置
  factoryPayplan,
  factoryPayplanCreate,
  factoryPayplanModify,
  factoryPayplanRemove,

  // 生产进度
  reportProductionProgress,

  // 其他
  companyWallet,
  msgDelete
}
