const COMMON_APIS = {
  getAllStyles() {
    return '/djwebservices/styles/all';
  },
  createColor() {
    return '/djwebservices/colors';
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
    return '/djwebservices/sizes';
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
    return '/b2b/products/sample';
  },
  getSampleProducts() {
    return '/b2b/products/sample';
  },
  getSampleProduct(id) {
    return '/b2b/products/sample/' + id;
  },
  createSampleCheckoutHist() {
    return '/b2b/products/sampleCheckoutHist';
  },
  getSampleCheckoutHists() {
    return '/b2b/products/sampleCheckoutHist';
  },
  getSampleCheckoutHist(id) {
    return '/b2b/products/sampleCheckoutHist/' + id;
  },
  createCarousel() {
    return '/b2b/carousels';
  },
  getCarousels() {
    return '/b2b/carousels';
  },
  getCarousel(id) {
    return '/b2b/carousel/' + id;
  },
  createIndustrialCluster() {
    return '/b2b/industrialClusters';
  },
  getIndustrialClusters() {
    return '/b2b/industrialClusters';
  },
  getIndustrialCluster(code) {
    return '/b2b/industrialClusters/' + code;
  },
  createLabel() {
    return '/b2b/labels';
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
    return '/b2b/employees';
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
  getFactories() {
    return '/b2b/factories';
  },
  getFactory(uid) {
    return '/b2b/factories/' + uid;
  },
  createB2BCustomer() {
    return '/b2b/b2bCustomers';
  },
  getB2BCustomers() {
    return '/b2b/b2bCustomers';
  },
  getB2BCustomer(uid) {
    return '/b2b/b2bCustomers/' + uid;
  },
  createRole() {
    return '/b2b/roles';
  },
  getRoles() {
    return '/b2b/roles';
  },
  getRole(uid) {
    return '/b2b/roles/' + uid;
  },
  createUserGroup() {
    return '/b2b/userGroups';
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
    return '/b2b/addresses';
  },
  getAddresses() {
    return '/b2b/addresses';
  },
  getAddress(uid) {
    return '/b2b/addresses/' + uid;
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
  createApparelProduct() {
    return '/b2b/products/apparel/create';
  },
  getRequirementOrder(code) {
    return '/b2b/orders/requirement/' + code;
  },
  createRequirementOrder() {
    return '/b2b/orders/requirement/new';
  },
  getQuote(code) {
    return '/b2b/orders/quote/' + code;
  },
  createQuote() {
    return '/b2b/orders/quote/create';
  },
  getPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code;
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
};
Object.assign(NONE_TENANT_APIS, COMMON_APIS);

export {
  TENANT_APIS,
  NONE_TENANT_APIS
}
