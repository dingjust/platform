import {
  Selection,
  ShippingOrderCode,
  RelationShippingOrder,
  Product,
  RelationOrder,
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
  ReceiptDate,
  ReconsiderOrderCode,
  ReconsiderNum,
  ReconsiderOperation,
  ReturnParty,
  ReturnPerson,
  ReturnNum,
  RelationReconsiderOrder,
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
    ReceiptDate,
    ReconsiderOrderCode,
    ReconsiderNum,
    ReconsiderOperation,
    ReturnParty,
    ReturnPerson,
    ReturnNum,
    RelationReconsiderOrder,
    COMPONENT_NAME_MAP
  },
  render: function (createElement) {
    return createElement(
      
      'template', this.columns.map((entry,index) => {
        let props = entry.props != null ? entry.props : {};
        props['sortKey']=index;
        //增加排序
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
