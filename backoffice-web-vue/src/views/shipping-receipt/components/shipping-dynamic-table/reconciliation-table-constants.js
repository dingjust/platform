/*
 *@description:对账单
 *@author: yj
 *@date: 2020-07-17 16:10:10
 *@version: V1.0.0
 */

import ShippingOrdersDetail from '../../shipping-order/details/ShippingOrdersDetail'

//对账单号
const ReconciliationOrderCode = {
  template: `
    <el-table-column label="对账单号" :prop="prop" min-width="110px" fixed :key="sortKey"></el-table-column>
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

const ReconciliationShipOrders = {
  template: `
    <el-table-column label="关联发货单" min-width="110px" :key="sortKey">
      <template slot-scope="scope">
        <el-row v-for="item in scope.row.shippingSheets" :key="item.id">
          <el-button type="text" @click="onShipDetail(item)">{{item.code}}</el-button>
        </el-row>
      </template>
      <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <shipping-orders-detail :id="openId" v-if="dialogVisible" />
      </el-dialog>
    </el-table-column>    
    `,
  components: {
    ShippingOrdersDetail
  },
  methods: {
    onShipDetail(item) {
      this.openId = item.id;
      this.dialogVisible = true;
    }
  },
  data() {
    return {
      openId: null,
      dialogVisible: false
    }
  },
  props: {
    sortKey: {
      default: 10
    }
  },
}

//对账数量
const ReconciliationNum = {
  template: `
    <el-table-column label="对账数量" :prop="prop":key="sortKey"></el-table-column>
    `,
  props: {
    prop: {
      type: String,
      default: 'reconciliationQuantity'
    },
    sortKey: {
      default: 10
    }
  }
}

//对账总额
const ReconciliationAmount = {
  template: `
    <el-table-column label="对账总额" :prop="prop":key="sortKey"></el-table-column>
    `,
  props: {
    prop: {
      type: String,
      default: 'reconciliationAmount'
    },
    sortKey: {
      default: 10
    }
  }
}

//扣款总额
const ReconciliationDeduct = {
  template: `
    <el-table-column label="扣款金额" :prop="prop":key="sortKey"></el-table-column>
    `,
  props: {
    prop: {
      type: String,
      default: 'deductionAmount'
    },
    sortKey: {
      default: 10
    }
  }
}

//增款总额
const ReconciliationIncrease = {
  template: `
    <el-table-column label="增款金额" :prop="prop":key="sortKey"></el-table-column>
    `,
  props: {
    prop: {
      type: String,
      default: 'increaseAmount'
    },
    sortKey: {
      default: 10
    }
  }
}

//对账日期
const ReconciliationDate = {
  template: `<el-table-column label="对账日期" :key="sortKey">
  <template slot-scope="scope">
    <span>{{getDate(scope.row) | timestampToTime}}</span>
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
  methods: {
    // 收货时间
    getDate(row) {
      try {
        return eval('row.' + this.prop);
      } catch (e) {
        return null
      }
    }
  },
}

//对账单状态
const ReconciliationState = {
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
        result = this.getEnum('ReconciliationOrderState', state);
      } catch (e) {
        // TODO:空值处理
      }
      return result;
    }
  }
}

//对账单详情
const ReconciliationDetail = {
  template: `
  <el-table-column label="操作" :key="sortKey">
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
      this.$router.push('/reconciliation/orders/' + row.id);
    }
  }
}



const RECONCILIATION_COMPONENT_NAME_MAP = {
  '对账单号': 'reconciliation-order-code',
  '对账发货单': 'reconciliation-ship-orders',
  '对账数量': 'reconciliation-num',
  '对账总额': 'reconciliation-amount',
  '扣款金额': 'reconciliation-deduct',
  '增款金额': 'reconciliation-increase',
  '对账日期': 'reconciliation-date',
  '对账状态': 'reconciliation-state',
  '对账详情': 'reconciliation-detail'
}

export {
  ReconciliationOrderCode,
  ReconciliationShipOrders,
  ReconciliationNum,
  ReconciliationAmount,
  ReconciliationDeduct,
  ReconciliationIncrease,
  ReconciliationDate,
  ReconciliationState,
  ReconciliationDetail,
  RECONCILIATION_COMPONENT_NAME_MAP
}
