const Selection = {
  template: `
  <el-table-column type="selection" width="55" fixed="left"></el-table-column>
`,
}

const ShippingOrderCode = {
  template: `
  <el-table-column label="发货单号" :prop="prop" min-width="120" fixed="left"></el-table-column>
  `,
  props: {
    prop: {
      type: String,
      default: 'code'
    }
  }
}

const RelationShippingOrder = {
  template: `
  <el-table-column label="关联发货单" min-width="120">
    <template slot-scope="scope">
      <el-button type="text" @click="onShipDetail(scope.row)">{{shippingName(scope.row)}}</el-button>
    </template>
  </el-table-column>
`,
  props: {
    code: {
      type: String,
      default: 'code'
    },
    id: {
      type: String,
      default: 'id'
    }
  },
  methods: {
    shippingName (row) {
      try {
        return eval('row.' + this.code);
      } catch (e) {
        return null;
      }
    },
    onShipDetail (row) {
      try {
        this.$router.push('/shipping/orders/' + eval('row.' + this.id));
      } catch (e) {
        return null;
      }
    }
  }
}

const Product = {
  template: `
  <el-table-column label="产品名称" min-width="150">
  <template slot-scope="scope">
    <el-row type="flex" justify="space-between" align="middle" :gutter="50">
      <el-col :span="6">
        <img width="54px" v-if="getProduct(scope.row)!=null" height="54px"
          :src="getProduct(scope.row).thumbnail!=null&&getProduct(scope.row).thumbnail.length!=0?getProduct(scope.row).thumbnail.url:'static/img/nopicture.png'" />
      </el-col>
      <el-col :span="16">
        <el-row>
          <span>{{getProduct(scope.row).name}}</span>s
        </el-row>
        <el-row>
          <span>货号:{{getProduct(scope.row)!=null?getProduct(scope.row).skuID:''}}</span>
        </el-row>
      </el-col>
    </el-row>
  </template>
</el-table-column>
`,
  props: {
    prop: {
      type: String,
      default: 'product'
    }
  },
  methods: {
    //获取产品
    getProduct(row) {
      return row[this.prop];
    }
  },
}

const RelationOrder = {
  template: `
  <el-table-column label="关联订单" min-width="120px">
  <template slot-scope="scope">
    <el-button type="text" v-if="getProductionOrder(scope.row)!=null"
      @click="onProductionOrderDetail(scope.row)">{{getProductionOrder(scope.row).code}}
    </el-button>
  </template>
</el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'productionTaskOrder'
    }
  },
  methods: {
    getProductionOrder(row) {
      return row[this.prop];
    },
    //跳转生产订单明细
    onProductionOrderDetail(row) {
      this.$router.push('/sales/productionOrder/' + row[this.prop].id);
    },
  }
}

const ShipParty = {
  template: `<el-table-column label="发货人" :prop="prop"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'shipParty.name'
    }
  },
}

const UnitPrice = {
  template: `
  <el-table-column label="单价">
    <template slot-scope="scope">
      <span v-if="getProductionTaskOrder(scope.row)!=null">{{getProductionTaskOrder(scope.row).unitPrice}}</span>
    </template>
  </el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'productionTaskOrder'
    }
  },
  methods: {
    getProductionTaskOrder(row) {
      return row[this.prop];
    },
  }
}

const ShipNum = {
  template: `
  <el-table-column label="发货数">
    <template slot-scope="scope">
      <span>{{getTotalNum(scope.row)}}</span>
    </template>
  </el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'packageSheets'
    }
  },
  methods: {
    //统计发货数
    getTotalNum(order) {
      let result = 0;
      if (order[this.prop] != null) {
        order[this.prop].forEach(element => {
          if (element.colorSizeEntries != null) {
            element.colorSizeEntries.forEach(entry => {
              let num = parseInt(entry.quantity);
              if (!Number.isNaN(num)) {
                result += num;
              }
            });
          }
        });
      }
      return result;
    }
  }
}

const ShipDate = {
  template: `<el-table-column label="发货日期">
  <template slot-scope="scope">
    <span>{{scope.row[prop] | timestampToTime}}</span>
  </template>
</el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'creationtime'
    }
  },
}

const ReceiptOrder = {
  template: `<el-table-column label="收货单" :prop="prop" fixed="left"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'code'
    }
  }
}

//收货单创建人
const ReceiptOrderCreator = {
  template: `<el-table-column label="创建人"></el-table-column>`
}

const RelationReceiptOrder = {
  template: `
  <el-table-column label="关联收货单" fixed="left" min-width="110px">
    <template slot-scope="scope">
      <template v-for="item in scope.row.receiptSheets">
        <el-button type="text" @click="onReceiptDetail(item)" :key="item.id">{{item.code}}</el-button>
      </template>
    </template>
  </el-table-column>
  `,
  methods: {
    onReceiptDetail (item) {
      this.$router.push('/receipt/orders/' + item.id);
    }
  }
}

const ShipReceNum = {
  template: `
  <el-table-column label="发货数/收货数">
    <template slot-scope="scope">
      <span>{{getShipNum(scope.row)}}/{{getTotalNum(scope.row)}}</span>
    </template> 
  </el-table-column>`,
  props: {
    ///发货数
    shipProp: {
      type: String,
      default: 'totalQuantity'
    },
    receSheetProp: {
      type: String,
      default: 'receiptSheets'
    }
  },
  methods: {    
    //发货数
    getShipNum(row) {
      let num = 0;
      try {
        if (eval('row.' + this.shipProp) != null) {
          num = eval('row.' + this.shipProp);
        }
      } catch (e) {
        // TODO:空值处理        
      }
      return num;
    },
    //统计收货数
    getTotalNum(row) {
      let result = 0;
      try {
        let sheets = eval('row.' + this.receSheetProp);
        if (sheets != null) {
          sheets.forEach(element => {
            if (element.totalQuantity != null) {
              let num = parseInt(element.totalQuantity);
              if (!Number.isNaN(num)) {
                result += num;
              }
            }
          });
        }
      } catch (e) {
        // TODO:空值处理        
      }
      return result;
    }
  },
}

const ReceiptNum = {
  template: `
    <el-table-column label="收货数">
      <template slot-scope="scope">
        <span>{{receiptNum(scope.row)}}</span>
      </template>
    </el-table-column>
  `,
  props: {
    prop: {
      type: String,
      default: 'receiptSheets'
    }
  },
  methods: {
    receiptNum (row) {
      let result = 0;
      try {
        let sheets = eval('row.' + this.prop);
        if (sheets != null) {
          sheets.forEach(element => {
            if (element.totalQuantity != null) {
              let num = parseInt(element.totalQuantity);
              if (!Number.isNaN(num)) {
                result += num;
              }
            }
          });
        }
      } catch (e) {

      }
      return result;
    }
  }
}

const ReceiptDate = {
  template: `
  <el-table-column label="收货日期">
    <template slot-scope="scope">
      <span v-if="getReceiptDate(scope.row)!=null">{{getReceiptDate(scope.row) | formatDate}}</span>
    </template>
  </el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'receiptSheets'
    }
  },
  methods: {
    //收货时间
    getReceiptDate(row) {
      try {
        return eval('row.' + this.prop + '[0].creationtime');
      } catch (e) {
        return null
      }
    }
  },
}

const ReturnOrder = {
  template: `<el-table-column label="退货单" :prop="prop" fixed="left"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'code'
    }
  }
}

const RelationReturnOrder = {
  template: `
  <el-table-column label="关联退货单" min-width="110px">
    <template slot-scope="scope">
      <template v-for="item in scope.row.returnSheets">
        <el-button type="text" @click="onDetail(item)">{{item.code}}</el-button>
      </template>
    </template>
  </el-table-column>
  `,
  methods: {
    onDetail (item) {
      this.$router.push('/returned/orders/' + item.id);
    }
  }
}

const ReturnNum = {
  template: `<el-table-column label="退货数" prop="totalQuantity"></el-table-column>`
}

//退货单创建人
const ReturnOrderCreator = {
  template: `<el-table-column label="创建人" prop="creator.name"></el-table-column>`
}

const ReturnReceiptNum = {
  template: `
  <el-table-column label="退货数/收退货数">
    <template slot-scope="scope">
      <span>{{getReturnTotalNum(scope.row)}}/{{getReceReturnlNum(scope.row)}}</span>
    </template>
  </el-table-column>`,
  props: {
    //退货字段
    prop: {
      type: String,
      default: 'returnSheets'
    },
  },
  methods: {

    //统计退货数
    getReturnTotalNum(row) {
      let result = 0;
      try {
        let sheets = eval('row.' + this.prop);
        if (sheets != null) {
          sheets.forEach(element => {
            if (element.totalQuantity != null) {
              let num = parseInt(element.totalQuantity);
              if (!Number.isNaN(num)) {
                result += num;
              }
            }
          });
        }
      } catch (e) {
        //TODO:空值处理
      }
      return result;
    },
    //统计收退货数
    getReceReturnlNum(row) {
      let result = 0;
      try {
        let sheets = eval('row.' + this.prop);
        if (sheets != null) {
          sheets.filter(sheet => sheet.state == 'RETURN_RECEIVED').forEach(element => {
            if (element.totalQuantity != null) {
              let num = parseInt(element.totalQuantity);
              if (!Number.isNaN(num)) {
                result += num;
              }
            }
          });
        }
      } catch (e) {
        //TODO:空值处理
      }
      return result;
    }
  }
}

const DifferentNum = {
  template: `<el-table-column label="差异数" :prop="prop"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'diffQuantity'
    }
  }
}

const ShippingOperation = {
  template: `<el-table-column label="操作" fixed="right">
  <template slot-scope="scope">
    <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
  </template>
</el-table-column>`,
  methods: {
    onDetail(row) {
      this.$router.push('/shipping/orders/' + row.id);
    }
  }
}

const ReceiptOperation = {
  template: `<el-table-column label="操作" fixed="right">
  <template slot-scope="scope">
    <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
  </template>
</el-table-column>`,
  methods: {
    onDetail(row) {
      this.$router.push('/shipping/orders/' + row.id);
    }
  }
}

const ReturnOperation = {
  template: `<el-table-column label="操作" fixed="right">
  <template slot-scope="scope">
    <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
  </template>
</el-table-column>`,
  methods: {
    onDetail(row) {
      this.$router.push('/returned/orders/' + row.id);
    }
  }
}

//////////////////////////////////////////////////复议

//复议单号
const ReconsiderOrderCode = {
  template: `
  <el-table-column label="复议单号" prop="code" min-width="120" fiexd></el-table-column>
`
}

//复议数
const ReconsiderNum = {
  template: `
  <el-table-column label="复议数" prop="reconsiderQuantity"></el-table-column>
`
}

const ReconsiderOperation = {
  template: `<el-table-column label="操作" fixed="right">
  <template slot-scope="scope">
    <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
  </template>
</el-table-column>`,
  methods: {
    onDetail(row) {
      this.$router.push('/reconsiders/orders/detail/' + row.id);
    }
  }
}

const COMPONENT_NAME_MAP = {
  '多选': 'selection',
  '发货单号': 'shipping-order-code',
  '关联发货单': 'relation-shipping-order',
  '产品名称': 'product',
  '关联订单': 'relation-order',
  '发货人': 'ship-party',
  '单价': 'unit-price',
  '发货数': 'ship-num',
  '发货日期': 'ship-date',
  '收货单': 'receipt-order',
  '收货单创建人': 'receipt-order-creator',
  '收货数': 'receipt-num',
  '退货单': 'return-order',
  '退货数': 'return-num',
  '退货单创建人': 'return-order-creator',
  '关联退货单': 'relation-return-order',
  '退货收货数': 'return-receipt-num',
  '差异数': 'different-num',
  '发货操作': 'shipping-operation',
  '收货操作': 'receipt-operation',
  '退货操作': 'return-operation',
  '发货收货数': 'ship-rece-num',
  '收货日期': 'receipt-date',
  //复议
  '复议单号': 'reconsider-order-code',
  '复议数': 'reconsider-num',
  '复议单操作':'reconsider-operation'
}


export {
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
}
