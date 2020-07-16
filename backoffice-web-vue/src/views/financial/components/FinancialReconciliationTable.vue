<template>
  <div>
    <el-row type="flex" justify="end" align="middle" style="margin: 15px 0px;">
      <el-col :span="4">
        <h6>订单总额：100000000元</h6>
      </el-col>
      <el-col :span="4">
        <h6>应收总额：10000000元</h6>
      </el-col>
      <el-col :span="5">
        <h6>已开发票总额：1000000元</h6>
      </el-col>
    </el-row>
    <table cellspacing="2" width="100%" class="order-table">
      <!-- 表头 -->
      <tr class="order-table_body-wrapper">
        <template v-for="item in titleRow">
          <th :key="item">{{item}}</th>
        </template>
      </tr>
      <template v-for="(item, productionIndex) in formData.productionOrder">
        <tr :key="item.id">
          <td :rowspan="item.reconciliationOrder.length + 1">{{item.code}}</td>
        </tr>
        <template v-for="(val, reconciliationIndex) in item.reconciliationOrder">
          <tr :key="val.id">
            <td>{{val.code}}</td>
            <td>{{val.amount}}</td>
            <td>{{val.deposit}}</td>
            <td>{{val.paymentReceived}}</td>
            <td v-if="productionIndex == 0 && reconciliationIndex == 0" :rowspan="totalRow">{{totalReceivable}}</td>
            <td v-if="productionIndex == 0 && reconciliationIndex == 0" :rowspan="totalRow">{{totalReceived}}</td>
            <td v-if="productionIndex == 0 && reconciliationIndex == 0" :rowspan="totalRow">{{totalNotReceived}}</td>
          </tr>
        </template>
      </template>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'FinancialReconciliationTable',
    props: [],
    components: {
    },
    computed: {
      // 计算总行数
      totalRow: function () {
        return 5;
      },
      // 计算应收总额
      totalReceivable: function () {
        return 50000;
      },
      // 计算已收总额
      totalReceived: function () {
        return 48000;
      },
      // 计算未收总额
      totalNotReceived: function () {
        return 2000;
      }
    },
    methods: {
    },
    data () {
      return {
        titleRow: ['生产工单号', '对账单号', '对账金额', '定金', '已付款', '应收总额', '已收总额', '未收总额'],
        formData: {
          productionOrder: [{
            id: 1,
            code: 'KY00001-01',
            reconciliationOrder: [{
              id: 101,
              code: 'KY00001-01-01',
              amount: 12000,
              deposit: 6000,
              paymentReceived: 9000
            }, {
              id: 102,
              code: 'KY00001-01-02',
              amount: 12000,
              deposit: 6000,
              paymentReceived: 9000
            }]
          }, {
            id: 2,
            code: 'KY00001-01',
            reconciliationOrder: [{
              id: 201,
              code: 'KY00001-02-01',
              amount: 12000,
              deposit: 6000,
              paymentReceived: 9000
            }, {
              id: 202,
              code: 'KY00001-02-02',
              amount: 12000,
              deposit: 6000,
              paymentReceived: 9000
            }]
          }]
        }
      }
    },
    created () {
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>
  .order-table {
    width: 100%;
    height: 100%; 
    border-collapse: collapse;
    margin-bottom: 20px;
    border: 1px solid #EBEEF5;;
  }

  .order-table tr td,
  .order-table tr th {
    text-align: center;
    height: 40px;
    font-size: 10px;
    border-right: 1px solid #EBEEF5;
    border-bottom: 1px solid #EBEEF5;
  }

</style>