import {
  Selection,
  ShippingOrderCode,
  ShipState,
  RelationShippingOrder,
  Product,
  RelationOrder,
  RelationOutOrder,
  UnitPrice,
  ShipParty,
  ShipPerson,
  ShipNum,
  ShipDate,
  ReceiptOrder,
  Creator,
  RelationReceiptOrder,
  ReceiptNum,
  ReturnOrder,
  RelationReturnOrder,
  ReturnReceiptNum,
  DifferentNum,
  ShippingOperation,
  ReceiptOperation,
  ReturnOperation,
  ShipReceNum,
  ShipReceNumV2,
  ReceiptDate,
  ReceiptDateV2,
  ReconsiderOrderCode,
  ReconsiderNum,
  ReconsiderOperation,
  ReturnParty,
  ReturnPerson,
  ReturnNum,
  RelationReconsiderOrder,
  ShippingCooperator,
  ReceiptCooperator,
  Merchandiser,
  OriginMerchandiser,
  ReturnDate,
  DifferentReconsider,
  DifferentReconsiderAdopt,
  SupplierShipParty,
  SupplierReceParty,
  //对账单
  ReconciliationOrderCode,
  ReconciliationShipOrders,
  ReconciliationNum,
  ReconciliationAmount,
  ReconciliationDeduct,
  ReconciliationIncrease,
  ReconciliationDate,
  ReconciliationState,
  ReconciliationDetail,
  ReconciliationAmountDue,
  //MAP
  COMPONENT_NAME_MAP
} from './table-constants';

const ShippingDynamicTableList = {
  props: {
    columns: {
      type: Array,
      default: () => {
        return ['发货单号', '产品名称', '关联订单'];
      }
    }
  },
  components: {
    Selection,
    ShippingOrderCode,
    ShipState,
    RelationShippingOrder,
    Product,
    RelationOrder,
    RelationOutOrder,
    UnitPrice,
    ShipParty,
    ShipPerson,
    ShipNum,
    ShipDate,
    ReceiptOrder,
    Creator,
    RelationReceiptOrder,
    ReceiptNum,
    ReturnOrder,
    RelationReturnOrder,
    ReturnReceiptNum,
    DifferentNum,
    ShippingOperation,
    ReceiptOperation,
    ReturnOperation,
    ShipReceNum,
    ShipReceNumV2,
    ReceiptDate,
    ReceiptDateV2,
    ReconsiderOrderCode,
    ReconsiderNum,
    ReconsiderOperation,
    ReturnParty,
    ReturnPerson,
    ReturnNum,
    RelationReconsiderOrder,
    ShippingCooperator,
    ReceiptCooperator,
    Merchandiser,
    OriginMerchandiser,
    ReturnDate,
    DifferentReconsider,
    DifferentReconsiderAdopt,
    SupplierShipParty,
    SupplierReceParty,
    //对账单
    ReconciliationOrderCode,
    ReconciliationShipOrders,
    ReconciliationNum,
    ReconciliationAmount,
    ReconciliationDeduct,
    ReconciliationIncrease,
    ReconciliationDate,
    ReconciliationState,
    ReconciliationDetail,
    ReconciliationAmountDue,
    //MAP
    COMPONENT_NAME_MAP
  },
  render: function (createElement) {
    return createElement(
      'template', this.columns.map((entry, index) => {
        let props = entry.props != null ? entry.props : {};
        props['sortKey'] = index + 2;
        // 增加排序
        return createElement(COMPONENT_NAME_MAP[entry.key], {
          props: props
        });
      })
    );
  }
}

export {
  ShippingDynamicTableList
}
