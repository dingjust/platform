const COMMON_APIS = {
  //注册
  fastRegister(type) {
    return '/b2b/companies/register/fast/' + type;
  },
  //是否已注册
  checkRegistered(phone) {
    return '/b2b/companies/register/' + phone;
  },
  //发送短信验证码
  sendCaptcha(phone) {
    return '/b2b/sms/captcha/' + phone;
  },
  //校验短信验证码
  validateCaptcha() {
    return '/b2b/sms/validate';
  },
  getAmapTips(key, keyWord, city) {
    return '/amap/v3/assistant/inputtips?key=' + key + '&keywords=' + keyWord + '&city=' + city;
  },
  changePassword(username) {
    return '/b2b/users/' + username + '/password';
  },
  getRegions() {
    return '/b2b/addresses/CN/regions';
  },
  getCities(parentCode) {
    return '/b2b/addresses/' + parentCode + '/cities'
  },
  getDistricts(parentCode) {
    return '/b2b/addresses/' + parentCode + '/districts'
  },
  getCarriers() {
    return '/b2b/carriers';
  },
  createColor() {
    return '/b2b/colors/create';
  },
  updateColor(code) {
    return '/b2b/colors/update/' + code;
  },
  getColors() {
    return '/b2b/colors';
  },
  getColorsSearch() {
    return '/b2b/colors/search';
  },
  getColor(code) {
    return '/b2b/colors/' + code;
  },
  getColorSearch(code) {
    return '/b2b/colors/search/' + code;
  },
  getAllColors() {
    return '/b2b/colors/all';
  },
  createSize() {
    return '/b2b/sizes/create';
  },
  updateSize(code) {
    return '/b2b/sizes/update/' + code;
  },
  getSizes() {
    return '/b2b/sizes';
  },
  getSizesSearch() {
    return '/b2b/sizes/search';
  },
  getSize(code) {
    return '/b2b/sizes/' + code;
  },
  getSizeSearch(code) {
    return '/b2b/sizes/search/' + code;
  },
  getAllSizes() {
    return '/b2b/sizes/all';
  },
  createSampleProduct() {
    return '/b2b/products/sample/create';
  },
  updateSampleProduct(code) {
    return '/b2b/products/sample/update/' + code;
  },
  getSampleProducts() {
    return '/b2b/products/sample';
  },
  getSampleProduct(id) {
    return '/b2b/products/sample/' + id;
  },
  createSampleCheckoutHist() {
    return '/b2b/products/sampleCheckoutHist/create';
  },
  updateSampleCheckoutHist(id) {
    return '/b2b/products/sampleCheckoutHist/update/' + id;
  },
  getSampleCheckoutHists() {
    return '/b2b/products/sampleCheckoutHist';
  },
  getAdvanceSampleCheckoutHists() {
    return '/b2b/products/sampleCheckoutHist/search';
  },
  getSampleCheckoutHist(id) {
    return '/b2b/products/sampleCheckoutHist/' + id;
  },
  createCarousel() {
    return '/b2b/carousels/create';
  },
  updateCarousel(id) {
    return '/b2b/carousels/update/' + id;
  },
  getCarousels() {
    return '/b2b/carousels';
  },
  getCarousel(id) {
    return '/b2b/carousels/' + id;
  },
  createIndustrialCluster() {
    return '/b2b/industrialClusters/create';
  },
  getIndustrialClusters() {
    return '/b2b/industrialClusters';
  },
  getIndustrialClustersAll() {
    return '/b2b/industrialClusters/all';
  },
  getIndustrialCluster(code) {
    return '/b2b/industrialClusters/' + code;
  },
  createLabel() {
    return '/b2b/labels/create';
  },
  updateLabel() {
    return '/b2b/labels/update';
  },
  getAllLabels() {
    return '/b2b/labels/all';
  },
  getGroupLabels(group) {
    return '/b2b/labels/' + group + '/all';
  },
  getIndustrialClusterLabels() {
    return '/b2b/industrialClusters/labels';
  },
  getLabels() {
    return '/b2b/labels';
  },
  getLabel(id) {
    return '/b2b/labels/' + id;
  },
  getBrandSuppliers() {
    return '/b2b/factories/getSuppliers';
  },
  getFactoriesSuppliers() {
    return '/b2b/brands/getSuppliers';
  },
  createEmployee() {
    return '/b2b/employees/create';
  },
  updateEmployee(uid) {
    return '/b2b/employees/update/' + uid;
  },
  getEmployees() {
    return '/b2b/employees';
  },
  getEmployee(uid) {
    return '/b2b/employees/' + uid;
  },
  createBrand() {
    return '/b2b/brands/new';
  },
  updateBrand(uid) {
    return '/b2b/brands/' + uid;
  },
  getBrands() {
    return '/b2b/brands';
  },
  getBrandsByName() {
    return '/b2b/brands/searchByName';
  },
  getBrand(uid) {
    return '/b2b/brands/' + uid;
  },
  removeCertificateForCompany(uid, mediaID) {
    return '/b2b/brands/' + uid + '/certificate/' + mediaID;
  },
  createFactory() {
    return '/b2b/factories/new';
  },
  updateFactory(uid) {
    return '/b2b/factories/' + uid;
  },
  updateFactoryProfiles(uid) {
    return '/b2b/factories/' + uid + '/profiles';
  },
  getFactories() {
    return '/b2b/factories';
  },
  getFactoriesByName() {
    return '/b2b/factories/searchByName';
  },
  getFactory(uid) {
    return '/b2b/factories/' + uid;
  },
  createB2BCustomer() {
    return '/b2b/b2bCustomers/create';
  },
  updateB2BCustomer(uid) {
    return '/b2b/b2bCustomers/update/' + uid;
  },
  getB2BCustomers() {
    return '/b2b/b2bCustomers';
  },
  getB2BCustomer(uid) {
    return '/b2b/b2bCustomers/' + uid;
  },
  createRole() {
    return '/b2b/roles/create';
  },
  getRoles() {
    return '/b2b/roles';
  },
  getAllRoles() {
    return '/b2b/roles';
  },
  getRole(uid) {
    return '/b2b/roles/' + uid;
  },
  createUserGroup() {
    return '/b2b/userGroups/create';
  },
  updateUserGroup() {
    return '/b2b/userGroups/update';
  },
  getUserGroups() {
    return '/b2b/userGroups';
  },
  getUserGroup(uid) {
    return '/b2b/userGroups/' + uid;
  },
  createB2BUnit() {
    return '/b2b/b2bUnits';
  },
  getB2BUnits() {
    return '/b2b/b2bUnits';
  },
  getB2BUnit(uid) {
    return '/b2b/b2bUnits/' + uid;
  },
  createAddress() {
    return '/b2b/company/addresses';
  },
  updateAddress(id) {
    return '/b2b/company/addresses/' + id;
  },
  removeAddress(id) {
    return '/b2b/company/addresses/' + id;
  },
  getAddresses() {
    return '/b2b/company/addresses';
  },
  getAddress(id) {
    return '/b2b/company/addresses/' + id;
  },
  getCategories() {
    return '/b2b/categories/categories';
  },
  getCategory(code) {
    return '/b2b/categories/category/' + code;
  },
  createCategories() {
    return '/b2b/categories';
  },
  // 小类，级联（二级）
  getMinorCategories() {
    return '/b2b/categories/cascaded';
  },
  getMajorCategories() {
    return '/b2b/categories/majors';
  },
  getApparelProduct(code) {
    return '/b2b/products/apparel/' + code;
  },
  onShelfProduct(code) {
    return '/b2b/products/apparel/' + code + '/on';
  },
  offShelfProduct(code) {
    return '/b2b/products/apparel/' + code + '/off';
  },
  deleteProduct(code) {
    return '/b2b/products/apparel/' + code + '/deleted';
  },
  createApparelProduct() {
    return '/b2b/products/apparel/create';
  },
  updateOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code;
  },
  updateBasicOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code + '/basic';
  },
  updateVariantsOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code + '/variants';
  },
  updateAttributesOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code + '/attributes';
  },
  updateImagesOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code + '/images';
  },
  getRequirementOrder(code) {
    return '/b2b/orders/requirement/' + code;
  },
  getQuotesByRequirementOrder(code) {
    return '/b2b/orders/requirement/' + code + '/quotes';
  },
  cancelledRequirementOrder(code) {
    return '/b2b/orders/requirement/cancelled/' + code;
  },
  recommendRequirementOrderToFactory(code, uid) {
    return '/b2b/orders/requirement/' + code + '/factory/' + uid + '/recommend';
  },
  getRecommendFactories(code) {
    return '/b2b/orders/requirement/' + code + '/factories';
  },
  createRequirementOrder() {
    return '/b2b/orders/requirement/new';
  },
  updateRequirementOrder(code) {
    return '/b2b/orders/requirement/' + code + '/request';
  },
  getQuote(code) {
    return '/b2b/orders/quote/' + code;
  },
  createQuote() {
    return '/b2b/orders/quote/create';
  },
  updateQuote(code) {
    return '/b2b/orders/quote/' + code;
  },
  approveQuote(code) {
    return '/b2b/orders/quote/' + code + '/approve';
  },
  rejectQuote(code) {
    return '/b2b/orders/quote/' + code + '/reject';
  },
  cancelQuote(code) {
    return '/b2b/orders/quote/' + code + '/cancel';
  },
  getPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code;
  },
  updateDeliveryAddressOfPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code + '/deliveryAddress';
  },
  updateProgressOfPurchaseOrder(code, id) {
    return '/b2b/orders/purchase/' + code + '/progress/' + id;
  },
  updateProgressForBatch(code) {
    return '/b2b/orders/purchase/' + code + '/progresses';
  },
  //生成唯一码
  generateUniqueCode(code) {
    return '/b2b/orders/purchase/' + code + '/unique';
  },
  //根据唯一码获取订单明细
  getDetailsForUniqueCode(code) {
    return '/b2b/orders/purchase/unique/' + code;
  },
  //关联唯一码
  linkUniqueCode(code) {
    return '/b2b/orders/purchase/link/' + code;
  },
  createPurchaseOrder() {
    return '/b2b/orders/purchase/create';
  },
  createOfflinePurchaseOrder() {
    return '/b2b/orders/purchase/createByOffline';
  },
  updateOfflinePurchaseOrder() {
    return '/b2b/orders/purchase/updateByOffline';
  },
  createPurchaseOrderOfQuote(quote) {
    return '/b2b/orders/purchase/create/' + quote;
  },
  //创建发货单
  createShippingOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createShippingOrder';
  },
  //创建全部发货单
  confirmShipping(code) {
    return '/b2b/orders/purchase/' + code + '/confirmShipping';
  },
  //删除发货单
  deleteShippingOrder(id) {
    return '/b2b/orders/purchase/deleteShippingOrder/' + id;
  },
  //创建收货单
  createDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createDeliveryOrder';
  },
  //创建并提交收货单
  createAndCommitDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createAndCommitDeliveryOrder';
  },
  //提交收货单
  commitDeliveryOrder() {
    return '/b2b/orders/purchase/commitDeliveryOrder';
  },
  //保存收货单
  updateDeliveryOrder() {
    return '/b2b/orders/purchase/updateDeliveryOrder';
  },
  //撤回收货单
  withdrawDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/recallDelivery';
  },
  //确认收货单
  confirmDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/confirmDelivery';
  },
  //拒绝收货单
  rejectDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/rejectDelivery';
  },
  //创建对账单
  createReconciliationOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createReconciliationOrder';
  },
  //创建并提交对账单
  createAndCommitReconciliationOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createAndCommitReconciliationOrder';
  },
  //提交对账单
  commitReconciliationOrder() {
    return '/b2b/orders/purchase/commitReconciliationOrder';
  },
  //撤回对账单
  withdrawReconciliationOrder() {
    return '/b2b/orders/purchase/recallReconciliationOrder';
  },
  //确认对账单
  confirmReconciliation(code) {
    return '/b2b/orders/purchase/' + code + '/confirmReconciliation';
  },
  //拒绝对账单
  rejectReconciliation(code) {
    return '/b2b/orders/purchase/' + code + '/rejectReconciliation';
  },
  //确认线下生产订单
  confirmProductionByOffline(code) {
    return '/b2b/orders/purchase/' + code + '/confirmProductionByOffline';
  },
  getProductionProgressReports() {
    return '/b2b/reports/productionProgresses';
  },
  getProofing(code) {
    return '/b2b/orders/proofing/' + code;
  },
  updateDeliveryAddressOfProofing(code) {
    return '/b2b/orders/proofing/' + code + '/deliveryAddress';
  },
  createProofing(quote) {
    return '/b2b/orders/proofing/create/' + quote;
  },
  removeMedia(mediaID) {
    return '/b2b/media/' + mediaID
  },
  getAmountFlowDetail(id) {
    return '/b2b/amountFlow/' + id
  },
  findAmountFlows() {
    return '/b2b/amountFlow'
  },
  getBill(id) {
    return '/b2b/bill/' + id;
  },
  createPaymentOrder(id) {
    return '/b2b/orders/purchase/confirmPayment/' + id;
  },
  updatePaymentOrder() {
    return '/b2b/orders/purchase/updatePaymentOrder';
  },
  deletePaymentOrder(id) {
    return '/b2b/orders/purchase/deletePaymentOrder/' + id;
  },
  createReceiptOrder(id) {
    return '/b2b/orders/purchase/confirmReceipt/' + id;
  },
  updateReceiptOrder() {
    return '/b2b/orders/purchase/updateReceiptOrder';
  },
  deleteReceiptOrder(id) {
    return '/b2b/orders/purchase/deleteReceiptOrder/' + id;
  },
  getCooperators() {
    return '/b2b/cooperator';
  },
  getCooperator(id) {
    return '/b2b/cooperator/' + id;
  },
  createCooperator() {
    return '/b2b/cooperator/create';
  },
  updateCooperator() {
    return '/b2b/cooperator/update';
  },
  deleteCooperator(id) {
    return '/b2b/cooperator/delete/' + id;
  },
  getPayPlans() {
    return '/b2b/payPlan';
  },
  getPayPlan(id) {
    return '/b2b/payPlan/' + id;
  },
  createPayPlan() {
    return '/b2b/payPlan/create';
  },
  updatePayPlan(id) {
    return '/b2b/payPlan/update/' + id;
  },
  deletePayPlan(id) {
    return 'b2b/payPlan/delete/' + id;
  },
  deletePayPlan(id) {
    return 'b2b/payPlan/delete/' + id;
  },
  updateUserInfo(uid) {
    return 'b2b/b2bCustomers/' + uid + '/updateUserInfo';
  },
  //公司产能
  getCapacityList() {
    return 'b2b/factory/capacity/list';
  },
  getCapacityByCode(code) {
    return 'b2b/factory/capacity/get/' + code;
  },
  //品牌查询产能列表
  searchCapacity() {
    return 'b2b/factory/capacity/search';
  },
  //产能切换状态
  capacitySwitchStatus(code) {
    return 'b2b/factory/capacity/switch/status/' + code;
  },
  //产能刷新
  capacityRefresh(code) {
    return 'b2b/factory/capacity/refresh/' + code;
  },
  //保存
  capacitySave() {
    return 'b2b/factory/capacity/save';
  },
  ///创建生产进度单据
  createProductionProgressOrder(id){
    return 'b2b/orders/purchase/progress/'+id+'/order';
  },
  ///作废生产进度单据
  deleteProductionProgressOrder(id,orderId){
    return  'b2b/orders/purchase/progress/'+id+'/order/'+orderId;
  },
  ///修改生产进度单据
  updateProductionProgressOrder(id,orderId){
    return  'b2b/orders/purchase/progress/'+id+'/order/'+orderId;
  },
  /// 生意/订单/合同/财务统计
  reportsTab1(){
    return  'b2b/company/reports/tab1';
  },
  ///上线倒计时/交货倒计时统计
  reportsProgress(){
    return  'b2b/company/reports/progress';
  }
};

let TENANT_APIS = {
  getApparelProducts() {
    return '/b2b/products/apparel/all';
  },
  getRequirementOrders() {
    return '/b2b/orders/requirement/all';
  },
  getAllRequirementOrders() {
    return this.getRequirementOrders();
  },
  getAllQuotes() {
    return '/b2b/orders/quote/all';
  },
  getPurchaseOrders() {
    return '/b2b/orders/purchase/all';
  },
  getProofings() {
    return '/b2b/orders/proofing/all';
  },
  createOperationCourse() {
    return '/b2b/guideline/create';
  },
  updateOperationCourse() {
    return '/b2b/guideline/update';
  },
  deleteOperationCourse(id) {
    return '/b2b/guideline/delete/' + id;
  },
  getOperationCourses() {
    return '/b2b/guideline';
  },
  getOperationCourse(id) {
    return '/b2b/guideline/' + id;
  },
  synchronizeProgress(code, targetCode) {
    return '/b2b/orders/purchase/' + code + '/synchronizeProgress/' + targetCode;
  },
  rejectedCashOut(id) {
    return '/b2b/companyWallet/cashOutRejected/' + id;
  },
  completedCashOut(id) {
    return '/b2b/companyWallet/cashOutCompleted/' + id;
  },
  findBills() {
    return '/b2b/bill/all'
  },
  getContractsList() {
    return '/b2b/user/agreement/list';
  },
  getContractDetail(code) {
    return '/b2b/user/agreement/get/' + code;
  },
  getSeals() {
    return '/b2b/user/seal/list';
  },
  getTemplatesListPt() {
    return '/b2b/agreement/temp/list';
  },
  getTemplates(code) {
    return '/b2b/user/agreement/temp/get/' + code;
  },
  getTemplatesList() {
    return '/b2b/user/agreement/temp/list';
  },
  saveTemplate() {
    return '/b2b/user/agreement/temp/save';
  },
  deleteTemplate(code) {
    return '/b2b/user/agreement/temp/delete/' + code;
  },
  saveSeal() {
    return '/b2b/user/seal/save';
  },
  delSeal(code) {
    return '/b2b/user/seal/delete/' + code;
  },
  saveContract() {
    return '/b2b/user/agreement/save';
  },
  saveContract() {
    return '/b2b/user/agreement/save';
  },
  personalAuthentication() {
    return '/b2b/fdd/api/save/personal/verify/data';
  },
  enterpriseAuthentication() {
    return '/b2b/fdd/api/save/enterprise/verify/data';
  },
  getAuthenticationState() {
    return '/b2b/cert/state';
  },
  getAuthenticationInfo() {
    return '/b2b/cert/personal/cert/info';
  },
  getAuthenticationEnterprise() {
    return '/b2b/cert/enterprise/cert/info';
  },
  refuseContract(code) {
    return '/b2b/user/agreement/reject/sign/' + code;
  },
  revokeContract(code) {
    return '/b2b/user/agreement/revoke/' + code;
  },
  previewPdf(code) {
    return '/b2b/user/agreement/preview/pdf/' + code;
  },
  orderContractClick() {
    return '/b2b/user/agreement/order/validate';
  }
};
Object.assign(TENANT_APIS, COMMON_APIS);

let NONE_TENANT_APIS = {
  getApparelProducts() {
    return '/b2b/products/apparel';
  },
  getRequirementOrders() {
    return '/b2b/orders/requirement';
  },
  getAllRequirementOrders() {
    return '/b2b/orders/requirement/all';
  },
  getQuotes() {
    return '/b2b/orders/quote';
  },
  getPurchaseOrders() {
    return '/b2b/orders/purchase/search';
  },
  //   getPurchaseOrders() {
  //   return '/b2b/orders/purchase';
  // },
  confirmDeliveringOfProductionOrder(code) {
    return '/b2b/orders/purchase/' + code + '/delivering';
  },
  getProofings() {
    return '/b2b/orders/proofing';
  },
  confirmDeliveringOfProofing(code) {
    return '/b2b/orders/proofing/' + code + '/delivering';
  },
  cancellingOfProofing(code) {
    return '/b2b/orders/proofing/' + code + '/cancelling';
  },
  cancellingOfPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code + '/cancelling';
  },
  changeCannelStatus(code) {
    return '/b2b/orders/purchase/' + code + '/changeCannelStatus';
  },
  completedOfPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code + '/shipped';
  },
  completedOfProofing(code) {
    return '/b2b/orders/proofing/' + code + '/shipped';
  },
  payProofings(code) {
    return '/b2b/orders/proofing/' + code + '/paid';
  },
  payProofingsImage(code) {
    return '/b2b/checkout/multi/wechat/pay/' + code;
  },
  cashOutCanceled(code) {
    return '/b2b/checkout/multi/wechat/pay/' + code;
  },
  cashOutApply(amount) {
    return '/b2b/amountFlow/cashOut/' + amount;
  },
  getBills() {
    return '/b2b/bill';
  },
  getWallet() {
    return '/b2b/companyWallet';
  },
  getContractsList() {
    return '/b2b/user/agreement/list';
  },
  getSealsList() {
    return '/b2b/user/seal/list';
  },
  getTemplatesListPt() {
    return '/b2b/agreement/temp/list';
  },
  getTemplates(code) {
    return '/b2b/user/agreement/temp/get/' + code;
  },
  getTemplatesList() {
    return '/b2b/user/agreement/temp/list';
  },
  saveTemplate() {
    return '/b2b/user/agreement/temp/save';
  },
  deleteTemplate(code) {
    return '/b2b/user/agreement/temp/delete/' + code;
  },
  saveSeal() {
    return '/b2b/user/seal/save';
  },
  delSeal(code) {
    return '/b2b/user/seal/delete/' + code;
  },
  saveContract() {
    return '/b2b/user/agreement/save';
  },
  deleteContract(code) {
    return '/b2b/user/agreement/delete/' + code;
  },
  downContract(code) {
    return '/b2b/user/agreement/get/download/token/' + code;
  },
  flowContract(code, sealCode) {
    return '/b2b/user/agreement/start/flow/' + code + '?sealCode=' + sealCode;
  },
  personalAuthentication() {
    return '/b2b/fdd/api/save/personal/verify/data';
  },
  enterpriseAuthentication() {
    return '/b2b/fdd/api/save/enterprise/verify/data';
  },
  getAuthenticationState() {
    return '/b2b/cert/state';
  },
  getAuthenticationInfo() {
    return '/b2b/cert/personal/cert/info';
  },
  getAuthenticationEnterprise() {
    return '/b2b/cert/enterprise/cert/info';
  },
  getContractDetail(code) {
    return '/b2b/user/agreement/get/' + code;
  },
  refuseContract(code) {
    return '/b2b/user/agreement/reject/sign/' + code;
  },
  revokeContract(code) {
    return '/b2b/user/agreement/revoke/' + code;
  },
  previewPdf(code) {
    return '/b2b/user/agreement/preview/pdf/' + code;
  },
  orderContractClick() {
    return '/b2b/user/agreement/order/validate';
  }
};
Object.assign(NONE_TENANT_APIS, COMMON_APIS);

export {
  TENANT_APIS,
  NONE_TENANT_APIS
}
