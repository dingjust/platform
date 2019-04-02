const COMMON_APIS = {
  changePassword(username) {
    return '/djwebservices/users/' + username + '/password';
  },
  getRegions() {
    return '/djwebservices/addresses/CN/regions';
  },
  getAllStyles() {
    return '/djwebservices/styles/all';
  },
  createColor() {
    return '/djwebservices/colors/create';
  },
  getColors() {
    return '/djwebservices/colors';
  },
  getColor(code) {
    return '/djwebservices/colors/' + code;
  },
  getAllColors() {
    return '/djwebservices/colors/all';
  },
  createSize() {
    return '/djwebservices/sizes/create';
  },
  getSizes() {
    return '/djwebservices/sizes';
  },
  getSize(code) {
    return '/djwebservices/sizes/' + code;
  },
  getAllSizes() {
    return '/djwebservices/sizes/all';
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
    return '/b2b/products/sampleCheckoutHist/update/'+id;
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
    return '/djwebservices/carousels/create';
  },
  updateCarousel(id) {
    return '/djwebservices/carousels/update/'+id;
  },
  getCarousels() {
    return '/djwebservices/carousels';
  },
  getCarousel(id) {
    return '/djwebservices/carousels/' + id;
  },
  createIndustrialCluster() {
    return '/b2b/industrialClusters/create';
  },
  getIndustrialClusters() {
    return '/b2b/industrialClusters';
  },
  getIndustrialCluster(code) {
    return '/b2b/industrialClusters/' + code;
  },
  createLabel() {
    return '/djwebservices/labels/create';
  },
  getAllLabels() {
    return '/djwebservices/labels/all';
  },
  getGroupLabels(group) {
    return '/djwebservices/labels/' + group + '/all';
  },
  getIndustrialClusterLabels() {
    return '/b2b/industrialClusters/labels';
  },
  getLabels() {
    return '/djwebservices/labels';
  },
  getLabel(id) {
    return '/djwebservices/labels/' + id;
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
    return '/b2b/employees/update/'+uid;
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
    return '/b2b/brands/'+uid;
  },
  getBrands() {
    return '/b2b/brands';
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
    return '/b2b/factories/'+uid;
  },
  getFactories() {
    return '/b2b/factories';
  },
  getFactory(uid) {
    return '/b2b/factories/' + uid;
  },
  createB2BCustomer() {
    return '/b2b/b2bCustomers/create';
  },
  updateB2BCustomer(uid) {
    return '/b2b/b2bCustomers/update/'+uid;
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
  createApparelProduct() {
    return '/b2b/products/apparel/create';
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
  getRequirementOrder(code) {
    return '/b2b/orders/requirement/' + code;
  },
  createRequirementOrder() {
    return '/b2b/orders/requirement/new';
  },
  updateRequirementOrder(code) {
    return '/b2b/orders/requirement/'+code+'/request';
  },
  getQuote(code) {
    return '/b2b/orders/quote/' + code;
  },
  createQuote() {
    return '/b2b/orders/quote/create';
  },
  updateQuote(code) {
    return '/b2b/orders/quote/'+code;
  },
  updateApprove(code) {
    return '/b2b/orders/quote/'+code+'/approve';
  },
  updateReject(code) {
    return '/b2b/orders/quote/'+code+'reject';
  },
  getPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code;
  },
  updateDeliveryAddressOfPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code + '/deliveryAddress';
  },
  updateProgressOfPurchaseOrder(code,id) {
    return '/b2b/orders/purchase/' + code + '/progress/'+id;
  },
  createPurchaseOrder() {
    return '/b2b/orders/purchase/create';
  },
  createPurchaseOrderOfQuote(quote) {
    return '/b2b/orders/purchase/create/' + quote;
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
    return '/djwebservices/media/' + mediaID
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
  getQuotes() {
    return '/b2b/orders/quote/all';
  },
  getPurchaseOrders() {
    return '/b2b/orders/purchase/all';
  },
  getProofings() {
    return '/b2b/orders/proofing/all';
  },
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
    return '/b2b/orders/purchase';
  },
  getProofings() {
    return '/b2b/orders/proofing';
  },
};
Object.assign(NONE_TENANT_APIS, COMMON_APIS);

export {
  TENANT_APIS,
  NONE_TENANT_APIS,
}
