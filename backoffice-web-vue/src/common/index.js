const COMMON_APIS = {
  // 小类，级联（二级）
  getMinorCategories() {
    return '/b2b/categories/cascaded';
  },
  getMajorCategories() {
    return '/b2b/categories/majors';
  },
  getAllStyles() {
    return '/djwebservices/styles/all';
  },
  getAllColors() {
    return '/djwebservices/colors/all';
  },
  getAllSizes() {
    return '/djwebservices/sizes/all';
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
