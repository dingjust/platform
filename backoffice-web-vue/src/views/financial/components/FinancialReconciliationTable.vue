<template>
  <div>
    <el-row type="flex" justify="end" align="middle" style="margin: 15px 0px;">
      <el-col :span="4">
        <h6>订单总额：{{formData.orderAmount}}</h6>
      </el-col>
      <el-col :span="4">
        <h6>应收总额：{{formData.amount}}元</h6>
      </el-col>
      <el-col :span="5">
        <h6>已开发票总额：{{formData.invoiceAmount}}元</h6>
      </el-col>
    </el-row>
    <table cellspacing="2" width="100%" class="order-table">
      <!-- 表头 -->
      <tr class="order-table_body-wrapper">
        <template v-for="item in titleRow">
          <th :key="item">{{item}}</th>
        </template>
      </tr>
      <template v-for="(item, productionIndex) in formData.productionTaskList">
        <tr :key="item.code">
          <!-- <td :rowspan="item.reconciliationOrder.length + 1">{{item.code}}</td> -->
          <td :rowspan="1">{{item.code}}</td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td :rowspan="totalRow">{{formData.amount}}</td>
          <td :rowspan="totalRow">{{formData.totalPaidAmount}}</td>
          <td :rowspan="totalRow">{{totalNotReceived}}</td>
        </tr>
        <!-- <template v-for="(val, reconciliationIndex) in item.reconciliationOrder">
          <tr :key="val.id">
            <td>{{val.code}}</td>
            <td>{{val.amount}}</td>
            <td>{{val.deposit}}</td>
            <td>{{val.paymentReceived}}</td>
            <td v-if="productionIndex == 0 && reconciliationIndex == 0" :rowspan="totalRow">{{formData.amount}}</td>
            <td v-if="productionIndex == 0 && reconciliationIndex == 0" :rowspan="totalRow">{{formData.totalPaidAmount}}</td>
            <td v-if="productionIndex == 0 && reconciliationIndex == 0" :rowspan="totalRow">{{totalNotReceived}}</td>
          </tr>
        </template> -->
      </template>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'FinancialReconciliationTable',
    props: ['formData'],
    components: {
    },
    computed: {
      // 计算总行数
      totalRow: function () {
        return 5;
      },
      // 计算未收总额
      totalNotReceived: function () {
        return this.notNaNNum(this.formData.amount) - this.notNaNNum(this.formData.totalPaidAmount);
      }
    },
    methods: {
      reconciliationLength () {
        
      },
      notNaNNum (num) {
        if (isNaN(parseInt(num))) {
          return 0;
        }
        return parseInt(num);
      }
    },
    data () {
      return {
        titleRow: ['生产工单号', '对账单号', '对账金额', '定金', '已付款', '应收总额', '已收总额', '未收总额']
        // formData: {
        //   productionOrder: [{
        //     id: 1,
        //     code: 'KY00001-01',
        //     reconciliationOrder: [{
        //       id: 101,
        //       code: 'KY00001-01-01',
        //       amount: 12000,
        //       deposit: 6000,
        //       paymentReceived: 9000
        //     }, {
        //       id: 102,
        //       code: 'KY00001-01-02',
        //       amount: 12000,
        //       deposit: 6000,
        //       paymentReceived: 9000
        //     }]
        //   }, {
        //     id: 2,
        //     code: 'KY00001-01',
        //     reconciliationOrder: [{
        //       id: 201,
        //       code: 'KY00001-02-01',
        //       amount: 12000,
        //       deposit: 6000,
        //       paymentReceived: 9000
        //     }, {
        //       id: 202,
        //       code: 'KY00001-02-02',
        //       amount: 12000,
        //       deposit: 6000,
        //       paymentReceived: 9000
        //     }]
        //   }]
        // }
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