///权限枚举
enum Authorization {
  //************************页面相关**************************

  ///需求订单
  REQUIREMENT_ORDER,

  ///报价订单（工厂）
  QUOTE_ORDER,

  ///打样订单
  PROOFING_ORDER,

  ///生产订单
  PURCHASE_ORDER,

  ///合同管理
  AGREEMENT,

  ///合同模板
  AGREEMENT_TMPL,

  ///签章管理
  AGREEMENT_SEAL,

  ///产品管理
  PRODUCT,

  ///样衣管理
  PRODUCT_SAMPLEPRODUCT,

  ///产能配置（工厂）
  FACTORY_CAPACITY,

  ///认证中心
  CERT,

  ///员工
  COMPANY_B2BCUSTOMER,

  ///合作商
  COMPANY_COOPERATOR,

  ///地址管理
  COMPANY_ADDRESS,

  ///账务配置
  FACTORY_PAYPLAN,

  ///生产进度
  REPORT_PRODUCTION_PROGRESS,

  ///钱包
  COMPANY_WALLET,

  //************************操作相关**************************

  //*************************订单 */

  ///发布需求
  REQUIREMENT_ORDER_PUBLISH,

  ///邀请报价
  REQUIREMENT_ORDER_RECOMMENDED,

  ///需求订单详情
  REQUIREMENT_ORDER_DETAIL,

  ///关闭需求订单
  REQUIREMENT_ORDER_CLOSE,

  ///确认工厂
  REQUIREMENT_ORDER_CHOOSEFACTORY,

  ///修改需求
  REQUIREMENT_ORDER_MODIFY,

  ///关闭报价订单
  QUOTE_ORDER_CLOSE,

  ///创建打样订单
  PROOFING_ORDER_CREATE,

  ///关闭打样订单
  PROOFING_ORDER_CLOSE,

  ///创建生产订单
  PURCHASE_ORDER_CREATE,

  ///关闭生产订单
  PURCHASE_ORDER_CLOSE,

  ///填写物流
  PROOFING_ORDER_DELIVERYADDRESS,

  ///报工操作
  PURCHASE_ORDER_OPERATE,

  ///财务操作
  PURCHASE_ORDER_PAYPLAN_OP,

  ///创建线下订单
  PURCHASE_ORDER_OFFLINE_CREATE,

  ///唯一码导入
  PURCHASE_ORDER_UNIQUECODE_IMPORT,

  ///确认发货
  PURCHASE_ORDER_CONFIRM_DELIVERING,

  ///确认收货
  PURCHASE_ORDER_CONFIRM_RECEIVED,

  ///确认订单（接单/拒单）
  PURCHASE_ORDER_CONFIRM,

  ///发起对账
  PURCHASE_ORDER_RECONCILIATION,

  //*************************合同 */

  ///创建模板
  AGREEMENT_TMPL_CREATE,

  ///新建
  AGREEMENT_SEAL_CREATE,

  ///签订合同
  AGREEMENT_SIGN,

  ///编辑模板
  AGREEMENT_TMPL_VIEW,

  ///删除
  AGREEMENT_SEAL_REMOVE,

  ///删除合同模板
  AGREEMENT_TPML_DELETE,

  //*************************产品 */

  ///创建产品
  PRODUCT_CREATE,

  ///创建样衣
  PRODUCT_SAMPLEPRODUCT_CREATE,

  ///编辑产能
  FACTORY_CAPACITY_MODIFY,

  ///删除产品
  PRODUCT_DELETE,

  ///发布产能
  FACTORY_CAPACITY_PUBLISH,

  ///修改产品
  PRODUCT_MODIFY,

  //*************************公司 */

  ///新增员工
  COMPANY_B2BCUSTOMER_CREATE,

  ///删除员工
  COMPANY_B2BCUSTOMER_REMOVE,

  ///新增合作商
  COMPANY_COOPERATOR_CREATE,

  ///删除合作商
  COMPANY_COOPERATOR_REMOVE,

  ///编辑合作商
  COMPANY_COOPERATOR_MODIFY,

  ///新增地址
  COMPANY_ADDRESS_CREATE,

  ///删除地址
  COMPANY_ADDRESS_REMOVE,

  ///新增财务方案
  FACTORY_PAYPLAN_CREATE,

  ///编辑财务方案
  FACTORY_PAYPLAN_MODIFY,

  ///删除财务方案
  FACTORY_PAYPLAN_REMOVE,

  ///启用/禁用
  COMPANY_B2BCUSTOMER_ENABLESTATE,

  ///工作交接
  COMPANY_B2BCUSTOMER_HANDOFF,

  ///部门改名
  COMPANY_B2BDEPT_RENAME,

  ///新增部门
  COMPANY_B2BDEPT_CREATE,

  ///删除部门
  COMPANY_B2BDEPT_REMOVE,

  ///新增角色
  COMPANY_B2BROLE_CREATE,

  ///删除角色
  COMPANY_B2BROLE_REMOVE,

  ///编辑角色权限
  COMPANY_B2BROLE_MODIFY,

  ///编辑员工信息
  COMPANY_B2BCUSTOMER_MODIFY,

  ///设置部门负责人
  COMPANY_B2BDEPT_SET_MANAGER,

  ////////////////////////////////////////////////////////////////////////////

  ///确认收货
  ROLE_PROOFING_ORDER_CONFIRM_RECEIVED,

  ///删除消息
  ROLE_MSG_DELETE,

  ///消息
  ROLE_MSG,

  ///签订合同
  ROLE_AGREEMENT_SIGN,

  ///其他
  ROLE_OTHERS,

  ///订单
  ROLE_ORDER,

  ///报表
  ROLE_REPORT,

  ///公司
  ROLE_COMPANY,

  ///产品
  ROLE_PRODUCT,

  ///合同
  ROLE_AGREEMENT,

  ///未知权限
  UNKNOWNVALUE,
}
