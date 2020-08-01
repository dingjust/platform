import {
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
  RECONCILIATION_COMPONENT_NAME_MAP
} from './reconciliation-table-constants';

import ProductionOrderDetail from '../../../order/salesProduction/production-order/details/ProductionOrderDetail'
import ShippingOrdersDetail from '../../shipping-order/details/ShippingOrdersDetail'
import ReceiptOrderDetail from '../../receipt-order/details/ReceiptOrderDetail'

// const Selection = {
//   template: `
//   <el-table-column type="selection" :key='sortKey'></el-table-column>
// `,
//   props: {
//     sortKey: {
//       default: 10
//     }
//   }
// }

const ShippingOrderCode = {
  template: `
  <el-table-column label="发货单" :prop="prop" min-width="110px" :key="sortKey"></el-table-column>
  `,
  props: {
    prop: {
      type: String,
      default: 'code'
    },
    sortKey: {
      default: 10
    }
  }
}

const RelationShippingOrder = {
  template: `
  <el-table-column label="发货单" min-width="120" :key="sortKey">
    <template slot-scope="scope">
      <el-button type="text" @click="onShipDetail(scope.row)">{{shippingName(scope.row)}}</el-button>
    </template>
    <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" append-to-body
    :close-on-click-modal="false">
    <shipping-orders-detail :id="openId" v-if="dialogVisible" />
    </el-dialog>
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
    },
    sortKey: {
      default: 10
    }
  },
  components: {
    ShippingOrdersDetail
  },
  data() {
    return {
      openId: null,
      dialogVisible: false
    }
  },
  methods: {
    shippingName(row) {
      try {
        return eval('row.' + this.code);
      } catch (e) {
        return null;
      }
    },
    onShipDetail(row) {
      try {
        // this.$router.push('/shipping/orders/' + eval('row.' + this.id));
        this.openId = eval('row.' + this.id);
        this.dialogVisible = true;
      } catch (e) {
        return null;
      }
    }
  }
}

const Product = {
  template: `
  <el-table-column label="产品名称" min-width="150" :key="sortKey" :show-overflow-tooltip="true">
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
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    // 获取产品
    getProduct(row) {
      return row[this.prop];
    }
  },
}

//发货单状态
const ShipState = {
  template: `
  <el-table-column label="状态" :key="sortKey">
  <template slot-scope="scope">
    <span>{{getState(scope.row)}}</span>
  </template>
</el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'state'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    getState(row) {
      let result = '';
      try {
        let state = eval('row.' + this.prop);
        result = this.getEnum('ShippingSheetState', state);
      } catch (e) {
        // TODO:空值处理
      }
      return result;
    }
  }
}


const RelationOrder = {
  template: `
  <el-table-column :label="label" min-width="120px" :key="sortKey">
  <template slot-scope="scope">
    <el-button type="text" v-if="getProductionOrder(scope.row)!=null"
      @click="onProductionOrderDetail(scope.row)">{{getProductionOrder(scope.row).code}}
    </el-button>
  </template>
  <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" append-to-body
  :close-on-click-modal="false">
  <production-order-detail :id="openId" v-if="dialogVisible" />
  </el-dialog>
</el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'productionTaskOrder'
    },
    sortKey: {
      default: 10
    },
    label:{
      type:String,
      default:'生产工单'
    }
  },
  components: {
    ProductionOrderDetail
  },
  data() {
    return {
      openId: null,
      dialogVisible: false
    }
  },
  methods: {
    getProductionOrder(row) {
      let order = {
        code: ''
      };
      try {
        if (eval('row.' + this.prop) != null) {
          order = eval('row.' + this.prop);
        }
      } catch (e) {
        // TODO:空值处理        
      }
      return order;
    },
    // 跳转生产订单明细
    onProductionOrderDetail(row) {
      this.openId = this.getProductionOrder(row).id;
      this.dialogVisible = true;
    }
  }
}

const RelationOutOrder = {
  template: `
  <el-table-column label="外发生产工单" min-width="120px" :key="sortKey">
  <template slot-scope="scope">
    <el-button type="text" v-if="getProductionOrder(scope.row)!=null"
      @click="onProductionOrderDetail(scope.row)">{{getProductionOrder(scope.row).code}}
    </el-button>
  </template>
  <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" append-to-body
  :close-on-click-modal="false">
  <production-order-detail :id="openId" v-if="dialogVisible" />
  </el-dialog>
</el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'productionTaskOrder'
    },
    sortKey: {
      default: 10
    }
  },
  components: {
    ProductionOrderDetail
  },
  data() {
    return {
      openId: null,
      dialogVisible: false
    }
  },
  methods: {
    getProductionOrder(row) {
      let order = {
        code: ''
      };
      try {
        if (eval('row.' + this.prop) != null) {
          order = eval('row.' + this.prop);
        }
      } catch (e) {
        // TODO:空值处理        
      }
      return order;
    },
    // 跳转生产订单明细
    onProductionOrderDetail(row) {
      this.openId = this.getProductionOrder(row).id;
      this.dialogVisible = true;
    }
  }
}

const ShipParty = {
  template: `<el-table-column label="发货方" :prop="prop" :key="sortKey"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'shipParty.name'
    },
    sortKey: {
      default: 10
    }
  },
}

const ShipPerson = {
  template: `<el-table-column label="发货人" :prop="prop" :key="sortKey"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'creator.name'
    },
    sortKey: {
      default: 10
    }
  },
}

const UnitPrice = {
  template: `
  <el-table-column label="单价" :key="sortKey" :prop="prop">    
  </el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'productionTaskOrder.unitPrice'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {

  }
}

const ShipNum = {
  template: `
  <el-table-column label="发货数" :key="sortKey">
    <template slot-scope="scope">
      <span>{{getTotalNum(scope.row)}}</span>
    </template>
  </el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'packageSheets'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    // 统计发货数
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
  template: `<el-table-column label="发货日期" :key="sortKey">
  <template slot-scope="scope">
    <span>{{scope.row[prop] | timestampToTime}}</span>
  </template>
</el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'creationtime'
    },
    sortKey: {
      default: 10
    }
  },
}

const ReceiptOrder = {
  template: `<el-table-column label="收货单" :prop="prop" :key="sortKey"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'code'
    },
    sortKey: {
      default: 10
    }
  }
}

// 收货单创建人
const Creator = {
  template: `<el-table-column label="创建人" :prop="prop" :key="sortKey" :show-overflow-tooltip="true"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'creator.name'
    },
    sortKey: {
      default: 10
    }
  },
}

const RelationReceiptOrder = {
  template: `
  <el-table-column label="收货单" min-width="110px" :key="sortKey">
    <template slot-scope="scope">
      <el-row v-for="item in scope.row.receiptSheets" :key="item.id">
        <el-button type="text" @click="onReceiptDetail(item)">{{item.code}}</el-button>
      </el-row>
    </template>
    <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" append-to-body
    :close-on-click-modal="false">
    <receipt-order-detail :id="openId" v-if="dialogVisible" />
    </el-dialog>
  </el-table-column>
  `,
  components: {
    ReceiptOrderDetail
  },
  data() {
    return {
      openId: null,
      dialogVisible: false
    }
  },
  methods: {
    onReceiptDetail(item) {
      // this.$router.push('/receipt/orders/' + item.id);
      this.openId = item.id;
      this.dialogVisible = true;
    }
  },
  props: {
    sortKey: {
      default: 10
    }
  },
}

const ShipReceNum = {
  template: `
  <el-table-column label="发货数/收货数" :key="sortKey" min-width="110">
    <template slot-scope="scope">
      <span>{{getShipNum(scope.row)}}/{{getTotalNum(scope.row)}}</span>
    </template> 
  </el-table-column>`,
  props: {
    /// 发货数
    shipProp: {
      type: String,
      default: 'totalQuantity'
    },
    receSheetProp: {
      type: String,
      default: 'receiptSheets'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    // 发货数
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
    // 统计收货数
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
    <el-table-column label="收货数" :key="sortKey">
      <template slot-scope="scope">
        <span>{{receiptNum(scope.row)}}</span>
      </template>
    </el-table-column>
  `,
  props: {
    prop: {
      type: String,
      default: 'receiptSheets'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    receiptNum(row) {
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
  <el-table-column label="收货日期" :key="sortKey">
    <template slot-scope="scope">
      <span v-if="getReceiptDate(scope.row)!=null">{{getReceiptDate(scope.row) | timestampToTime}}</span>
    </template>
  </el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'receiptSheets'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    // 收货时间
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
  template: `<el-table-column label="退货单" :prop="prop" :key="sortKey" ></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'code'
    },
    sortKey: {
      default: 10
    }
  }
}

const RelationReturnOrder = {
  template: `
  <el-table-column label="退货单" min-width="110px" :key="sortKey">
    <template slot-scope="scope">
      <el-row v-for="item in scope.row.returnSheets" :key="item.id">
        <el-button type="text" @click="onDetail(item)">{{item.code}}</el-button>
      </el-row>
    </template>
  </el-table-column>
  `,
  props: {
    prop: {
      type: String,
      default: 'code'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    onDetail(item) {
      this.$router.push('/returned/orders/' + item.id);
    }
  }
}

const ReturnNum = {
  template: `<el-table-column label="退货数" :prop="prop" :key="sortKey"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'totalQuantity'
    },
    sortKey: {
      default: 10
    }
  }
}

const ReturnReceiptNum = {
  template: `
  <el-table-column label="退货数/收退数" :key="sortKey" min-width="110px">
    <template slot-scope="scope">
      <span>{{getReturnTotalNum(scope.row)}}/{{getReceReturnlNum(scope.row)}}</span>
    </template>
  </el-table-column>`,
  props: {
    // 退货字段
    prop: {
      type: String,
      default: 'returnSheets'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {

    // 统计退货数
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
        // TODO:空值处理
      }
      return result;
    },
    // 统计收退货数
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
        // TODO:空值处理
      }
      return result;
    }
  }
}

const DifferentNum = {
  template: `<el-table-column label="差异数" :prop="prop" :key="sortKey"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'diffQuantity'
    },
    sortKey: {
      default: 10
    }
  }
}

const ShippingOperation = {
  template: `<el-table-column label="操作" fixed="right">
  <template slot-scope="scope">
    <el-button type="text" @click="onDetail(scope.row)">{{operationName}}</el-button>
  </template>
</el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'diffQuantity'
    },
    sortKey: {
      default: 10
    },
    operationName: {
      type: String,
      default: '详情'
    }
  },
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
  props: {
    prop: {
      type: String,
      default: 'diffQuantity'
    },
    sortKey: {
      default: 10
    }
  },
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
  props: {
    prop: {
      type: String,
      default: 'diffQuantity'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    onDetail(row) {
      this.$router.push('/returned/orders/' + row.id);
    }
  }
}

/// ///////////////////////////////////////////////复议

// 复议单号
const ReconsiderOrderCode = {
  template: `
  <el-table-column label="复议单" :prop="prop" min-width="120"  :key="sortKey" ></el-table-column>
`,
  props: {
    prop: {
      type: String,
      default: 'code'
    },
    sortKey: {
      default: 10
    }
  }
}

// 关联复议单
const RelationReconsiderOrder = {
  template: `
  <el-table-column label="复议单" min-width="110px" :key="sortKey">
    <template slot-scope="scope">
      <el-row v-for="item in scope.row.reconsiderSheets" :key="item.id">
        <el-button type="text" @click="onReconsiderDetail(item)">{{item.code}}</el-button>
      </el-row>
    </template>
  </el-table-column>
  `,
  methods: {
    onReconsiderDetail(item) {
      this.$router.push('/reconsiders/orders/detail/' + item.id);
    }
  },
  props: {
    sortKey: {
      default: 10
    }
  },
}

// 复议数
const ReconsiderNum = {
  template: `
  <el-table-column label="复议数" :prop="prop" :key="sortKey"></el-table-column>
`,
  props: {
    prop: {
      type: String,
      default: 'reconsiderQuantity'
    },
    sortKey: {
      default: 10
    }
  },
}

// 合作商-发货
const ShippingCooperator = {
  template: `
    <el-table-column label="合作商" prop="receiveParty.name" :key="sortKey" :show-overflow-tooltip="true"/>
  `,
  props: {
    sortKey: {
      default: 10
    }
  }
}

// 合作商-收货
const ReceiptCooperator = {
  template: `
    <el-table-column label="合作商" prop="shipParty.name" :key="sortKey" :show-overflow-tooltip="true"/>
  `,
  props: {
    sortKey: {
      default: 10
    }
  }
}

// 跟单员
const Merchandiser = {
  template: `
    <el-table-column label="跟单员" prop="merchandiser.name" :key="sortKey" :show-overflow-tooltip="true"/>
  `,
  props: {
    sortKey: {
      default: 10
    }
  }
}

// 收货跟单员
const OriginMerchandiser = {
  template: `
    <el-table-column label="跟单员" prop="originMerchandiser.name" :key="sortKey" :show-overflow-tooltip="true"/>
  `,
  props: {
    sortKey: {
      default: 10
    }
  }
}

// 退货日期
const ReturnDate = {
  template: `
    <el-table-column label="退货日期" :key="sortKey">
      <template slot-scope="scope">
        <span>{{scope.row.creationtime | timestampToTime}}</span>
      </template>
    </el-table-column>
  `,
  props: {
    sortKey: {
      default: 10
    }
  }
}

const DifferentReconsider = {
  template: `
    <el-table-column label="差异数/复议数" :key="sortKey" min-width="110px">
      <template slot-scope="scope">
        <span>{{getDiffNum(scope.row)}}/{{getReconsiderNum(scope.row)}}</span>
      </template>
    </el-table-column>
  `,
  props: {
    diffProp: {
      type: String,
      default: 'logisticsSheet.diffQuantity'
    },
    reconsiderProp: {
      type: String,
      default: 'reconsiderQuantity'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    getDiffNum(row) {
      let num = 0;
      try {
        if (eval('row.' + this.diffProp) != null) {
          num = eval('row.' + this.diffProp);
        }
      } catch (e) {
        // TODO 空值处理
      }
      return num;
    },
    getReconsiderNum(row) {
      let num = 0;
      try {
        if (eval('row.' + this.reconsiderProp) != null) {
          num = eval('row.' + this.reconsiderProp);
        }
      } catch (e) {
        // TODO 空值处理
      }
      return num;
    }
  }
}

const DifferentReconsiderAdopt = {
  template: `
    <el-table-column label="差异数/复议数/通过数" :key="sortKey" min-width="150px">
      <template slot-scope="scope">
        <span>{{getDiffNum(scope.row)}}/{{getReconsiderNum(scope.row)}}/{{getAdopt(scope.row)}}</span>
      </template>
    </el-table-column>
  `,
  props: {
    diffProp: {
      type: String,
      default: 'diffQuantity'
    },
    reconsiderProp: {
      type: String,
      default: 'reconsiderSheets'
    },
    sortKey: {
      default: 10
    }
  },
  methods: {
    getDiffNum(row) {
      let num = 0;
      try {
        if (eval('row.' + this.diffProp) != null) {
          num = eval('row.' + this.diffProp);
        }
      } catch (e) {
        // TODO 空值处理
      }
      return num;
    },
    getReconsiderNum(row) {
      let result = 0;
      try {
        let sheets = eval('row.' + this.reconsiderProp);
        if (sheets != null) {
          sheets.forEach(element => {
            if (element.reconsiderQuantity != null) {
              let num = parseInt(element.reconsiderQuantity);
              if (!Number.isNaN(num)) {
                result += num;
              }
            }
          });
        }
      } catch (e) {
        // TODO 空值处理
      }
      return result;
    },
    getAdopt(row) {
      let result = 0;
      try {
        let sheets = eval('row.' + this.reconsiderProp);
        if (sheets != null) {
          sheets.forEach(element => {
            if (element.reconsiderPassQuantity != null) {
              let num = parseInt(element.reconsiderPassQuantity);
              if (!Number.isNaN(num)) {
                result += num;
              }
            }
          });
        }
      } catch (e) {
        // TODO 空值处理
      }
      return result;
    }
  }
}

const ReconsiderOperation = {
  template: `<el-table-column label="操作" fixed="right" :key="sortKey">
  <template slot-scope="scope">
    <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
  </template>
</el-table-column>`,
  props: {
    sortKey: {
      default: 10
    }
  },
  methods: {
    onDetail(row) {
      this.$router.push('/reconsiders/orders/detail/' + row.id);
    }
  }
}

// 退货方
const ReturnParty = {
  template: `<el-table-column label="退货方" :prop="prop" :key="sortKey"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'shipParty.name'
    },
    sortKey: {
      default: 10
    }
  },
}

// 退货人
const ReturnPerson = {
  template: `<el-table-column label="退货人" :prop="prop" :key="sortKey"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'creator.name'
    },
    sortKey: {
      default: 10
    }
  }
}

// //复议方
// const ReconsiderParty = {
//   template: `<el-table-column label="复议方" :prop="prop" :key="sortKey"></el-table-column>`,
//   props: {
//     prop: {
//       type: String,
//       default: 'shipParty.name'
//     },
//     sortKey: {
//       default: 10
//     }
//   },
// }

// 供应商(发货方)
const SupplierShipParty = {
  template: `<el-table-column label="供应商" :prop="prop" :key="sortKey" :show-overflow-tooltip="true"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'shipParty.name'
    },
    sortKey: {
      default: 10
    }
  }
}

// 供应商(收货方)
const SupplierReceParty = {
  template: `<el-table-column label="供应商" :prop="prop" :key="sortKey" :show-overflow-tooltip="true"></el-table-column>`,
  props: {
    prop: {
      type: String,
      default: 'receiveParty.name'
    },
    sortKey: {
      default: 10
    }
  }
}


const MAIN_COMPONENT_NAME_MAP = {
  // '多选': 'selection',
  '发货单号': 'shipping-order-code',
  '发货单状态': 'ship-state',
  '关联发货单': 'relation-shipping-order',
  '产品名称': 'product',
  '关联订单': 'relation-order',
  '关联订单-收货': 'relation-out-order',
  '发货人': 'ship-person',
  '发货方': 'ship-party',
  '单价': 'unit-price',
  '发货数': 'ship-num',
  '发货日期': 'ship-date',
  '收货单': 'receipt-order',
  '创建人': 'creator',
  '收货数': 'receipt-num',
  '退货单': 'return-order',
  '退货数': 'return-num',
  '关联退货单': 'relation-return-order',
  '关联收货单': 'relation-receipt-order',
  '退货收货数': 'return-receipt-num',
  '差异数': 'different-num',
  '发货操作': 'shipping-operation',
  '收货操作': 'receipt-operation',
  '退货操作': 'return-operation',
  '发货收货数': 'ship-rece-num',
  '收货日期': 'receipt-date',
  '合作商-发货': 'shipping-cooperator',
  '合作商-收货': 'receipt-cooperator',
  '跟单员': 'merchandiser',
  '收货跟单员': 'origin-merchandiser',
  '退货日期': 'return-date',
  '差异-复议': 'different-reconsider',
  '差异-复议-通过': 'different-reconsider-adopt',
  // 复议
  '复议单号': 'reconsider-order-code',
  '复议数': 'reconsider-num',
  '复议单操作': 'reconsider-operation',
  '关联复议单': 'relation-reconsider-order',
  // 退货
  '退货方': 'return-party',
  '退货人': 'return-person',
  '发货供应商': 'supplier-ship-party',
  '收货供应商': 'supplier-rece-party'
}

const COMPONENT_NAME_MAP = Object.assign(MAIN_COMPONENT_NAME_MAP, RECONCILIATION_COMPONENT_NAME_MAP);


export {
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
  ReceiptDate,
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
}
