const COMMON_APIS = {
  // 小类，级联（二级）
  getMinorCategories() {
    return '/b2b/categories/cascaded';
  },
  getMajorCategories() {
    return '/b2b/categories/majors';
  },
  getPurchaseOrder(code) {
    return '/b2b/orders/requirement/' + code;
  },
  createPurchaseOrder() {
    return '/b2b/orders/requirement/new';
  }
};

let TENANT_APIS = {
  getPurchaseOrders() {
    return '/b2b/orders/requirement/all';
  }
};
Object.assign(TENANT_APIS, COMMON_APIS);

let NON_TENANT_APIS = {
  getPurchaseOrders() {
    return '/b2b/orders/requirement';
  }
};
Object.assign(NON_TENANT_APIS, COMMON_APIS);

export {
  TENANT_APIS,
  NON_TENANT_APIS
}
