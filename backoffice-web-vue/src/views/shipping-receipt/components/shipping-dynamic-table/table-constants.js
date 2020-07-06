const ShippingOrderCode = {
  template: `
  <el-table-column label="发货单号" prop="code" min-width="120" fixed="left" ></el-table-column>
`
}

const RelationShippingOrder = {
  template: `
  <el-table-column label="关联发货单" prop="code" min-width="120"></el-table-column>
`
}

const Product = {
  template: `
  <el-table-column label="产品名称" min-width="150">
  <template slot-scope="scope">
    <el-row type="flex" justify="space-between" align="middle" :gutter="50">
      <el-col :span="6">
        <img width="54px" v-if="scope.row.product!=null" height="54px"
          :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'" />
      </el-col>
      <el-col :span="16">
        <el-row>
          <span>{{scope.row.product.name}}</span>s
        </el-row>
        <el-row>
          <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
        </el-row>
      </el-col>
    </el-row>
  </template>
</el-table-column>
`
}

const RelationOrder = {
  template: `
  <el-table-column label="关联订单" min-width="120px">
  <template slot-scope="scope">
    <el-button type="text" v-if="scope.row.productionTaskOrder!=null"
      @click="onProductionOrderDetail(scope.row.productionTaskOrder.id)">{{scope.row.productionTaskOrder.code}}
    </el-button>
  </template>
</el-table-column>`,
  methods: {
    //跳转生产订单明细
    onProductionOrderDetail(id) {
      this.$router.push('/sales/productionOrder/' + id);
    },
  }
}

const ShipParty = {
  template: `<el-table-column label="发货人" prop="shipParty.name"></el-table-column>`
}

const UnitPrice = {
  template: `
  <el-table-column label="单价">
    <template slot-scope="scope">
      <span v-if="scope.row.productionTaskOrder!=null">{{scope.row.productionTaskOrder.unitPrice}}</span>
    </template>
  </el-table-column>`
}

const ShipNum = {
  template: `
  <el-table-column label="发货数">
  <template slot-scope="scope">
    <span>{{getTotalNum(scope.row)}}</span>
  </template>
</el-table-column>`,
  methods: {
    //统计发货数
    getTotalNum(order) {
      let result = 0;
      if (order.packageSheets != null) {
        order.packageSheets.forEach(element => {
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
    <span>{{scope.row.creationtime | timestampToTime}}</span>
  </template>
</el-table-column>`
}

const ReceiptOrder = {
  template: `<el-table-column label="收货单" fixed="left"></el-table-column>`
}

//收货单创建人
const ReceiptOrderCreator = {
  template: `<el-table-column label="创建人"></el-table-column>`
}

const RelationReceiptOrder = {
  template: `<el-table-column label="关联收货单"></el-table-column>`
}

const ReceiptNum = {
  template: `<el-table-column label="收货数"></el-table-column>`
}

const ReturnOrder = {
  template: `<el-table-column label="退货单" fixed="left"></el-table-column>`
}

const RelationReturnOrder = {
  template: `<el-table-column label="关联退货单"></el-table-column>`
}

const ReturnNum = {
  template: `<el-table-column label="退货数"></el-table-column>`
}

//退货单创建人
const ReturnOrderCreator = {
  template: `<el-table-column label="创建人"></el-table-column>`
}

const ReturnReceiptNum = {
  template: `<el-table-column label="退货数/退货已收数"></el-table-column>`
}

const DifferentNum = {
  template: `<el-table-column label="差异数"></el-table-column>`
}

const ShippingOperation = {
  template: `<el-table-column label="操作">
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
  template: `<el-table-column label="操作">
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
  template: `<el-table-column label="操作">
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


const COMPONENT_NAME_MAP = {
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
}

export {
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
  COMPONENT_NAME_MAP
}
