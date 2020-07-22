<template>
  <div>
    <el-row type="flex" justify="end" align="middle" style="margin: 15px 0px;">
      <el-col :span="4">
        <h6>订单总额：{{formData.orderAmount ? formData.orderAmount : 0}}元</h6>
      </el-col>
      <el-col :span="4">
        <h6>{{modeTitle}}：{{formData.amount ? formData.amount : 0}}元</h6>
      </el-col>
      <el-col :span="5">
        <h6>已开发票总额：{{formData.invoiceAmount ? formData.invoiceAmount : 0}}元</h6>
      </el-col>
    </el-row>
    <table cellspacing="2" width="100%" class="order-table">
      <!-- 表头 -->
      <tr class="order-table_body-wrapper">
        <template v-for="item in titleRow">
          <th :key="item">{{item}}</th>
        </template>
      </tr>
      <!-- 生产工单行 -->
      <template v-for="(item, productionIndex) in formData.productionTaskList">
        <!-- 有对账单 -->
        <template v-if="item.reconciliationSheetList && item.reconciliationSheetList.length > 0">
          <tr :key="item.code">
            <td :rowspan="item.reconciliationSheetList.length + 1">{{item.code}}</td>
          </tr>
          <template v-if="item.reconciliationSheetList.length > 0">
            <template v-for="(val, reconciliationIndex) in item.reconciliationSheetList">
              <tr :key="val.code">
                <td>{{val.code}}</td>
                <td>{{val.amountDue}}</td>
                <td v-if="productionIndex == 0 && reconciliationIndex == 0" :rowspan="totalRow + 1">{{formData.amount}}</td>
                <td v-if="productionIndex == 0 && reconciliationIndex == 0" :rowspan="totalRow + 1">{{formData.totalPaidAmount}}</td>
                <td v-if="productionIndex == 0 && reconciliationIndex == 0" :rowspan="totalRow + 1">{{totalDifference}}</td>
              </tr>
            </template>
          </template>
        </template>
        <!-- 无对账单 -->
        <template v-else>
          <tr :key="item.code">
            <td>{{item.code}}</td>
            <td style="color: #909399">{{'暂无数据'}}</td>
            <td style="color: #909399">{{'暂无数据'}}</td>
            <td v-if="productionIndex == 0" :rowspan="totalRow + 1">{{formData.amount}}</td>
            <td v-if="productionIndex == 0" :rowspan="totalRow + 1">{{formData.totalPaidAmount}}</td>
            <td v-if="productionIndex == 0" :rowspan="totalRow + 1">{{totalDifference}}</td>
          </tr>
        </template>
      </template>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'FinancialReconciliationTable',
    props: {
      formData: {
        type: Object
      },
      belongTo: {
        type: String,
        default: 'PAYABLE_PAGE'
      }
    },
    components: {
    },
    computed: {
      titleRow: function () {
        return this.belongTo == 'PAYABLE_PAGE' ? this.paymentRow : this.receiptRow;
      },
      modeTitle: function () {
        return this.belongTo == 'PAYABLE_PAGE' ? '应付总额' : '应收总额';
      },
      // 计算总行数
      totalRow: function () {
        let count = 0;
        this.formData.productionTaskList.forEach(item => {
          if (item.reconciliationSheetList) {
            count += item.reconciliationSheetList.length;
          } else {
            count += 1;
          }
        })
        return count;
      },
      // 计算未收总额
      totalDifference: function () {
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
        paymentRow: ['生产工单号', '对账单号', '应付金额', '应付总额', '已付总额', '未付总额'],
        receiptRow: ['生产工单号', '对账单号', '应收金额', '应收总额', '已收总额', '未收总额']
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