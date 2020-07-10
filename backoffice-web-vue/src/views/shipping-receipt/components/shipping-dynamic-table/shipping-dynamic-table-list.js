import {
  Selection,
  ShippingOrderCode,
  RelationShippingOrder,
  Product,
  RelationOrder,
  UnitPrice,
  ShipParty,
  ShipNum,
  ShipDate,
  ReceiptOrder,
  ReceiptOrderCreator,
  RelationReceiptOrder,
  ReceiptNum,
  ReturnOrder,
  ReturnOrderCreator,
  ReturnNum,
  RelationReturnOrder,
  ReturnReceiptNum,
  DifferentNum,
  ShippingOperation,
  ReceiptOperation,
  ReturnOperation,
  ShipReceNum,
  ReceiptDate,
  ReconsiderOrderCode,
  ReconsiderNum,
  ReconsiderOperation,
  COMPONENT_NAME_MAP
} from "./table-constants";

const ShippingDynamicTableList = {
  props: {
    columns: {
      type: Array,
      default: () => {
        return ["发货单号", "产品名称", "关联订单"];
      }
    }
  },
  components: {
    Selection,
    ShippingOrderCode,
    RelationShippingOrder,
    Product,
    RelationOrder,
    UnitPrice,
    ShipParty,
    ShipNum,
    ShipDate,
    ReceiptOrder,
    ReceiptOrderCreator,
    RelationReceiptOrder,
    ReceiptNum,
    ReturnOrder,
    ReturnOrderCreator,
    ReturnNum,
    RelationReturnOrder,
    ReturnReceiptNum,
    DifferentNum,
    ShippingOperation,
    ReceiptOperation,
    ReturnOperation,
    ShipReceNum,
    ReceiptDate,
    ReconsiderOrderCode,
    ReconsiderNum,
    ReconsiderOperation,
    COMPONENT_NAME_MAP
  },
  render: function (createElement) {
    return createElement(
      'template', this.columns.map(entry => {
        return createElement(COMPONENT_NAME_MAP[entry.key], {
          props: entry.props != null ? entry.props : {}
        });
      })
    );
  }
}

export {
  ShippingDynamicTableList
}
