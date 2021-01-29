<template>
  <div>
    <el-table :data="tableData" border v-if="order.entries">
      <el-table-column label="产品图片" min-width="80px">
        <template slot-scope="scope">
          <div v-if="scope.row.product && scope.row.product.images[0].id && scope.row.product.images[0].id !== ''"> 
            <img :src="scope.row.product.images[0].url" style="width: 50px; height: 50px"/>
          </div>
          <span v-else-if="scope.row.countRow">{{scope.row.countRow}}</span>
        </template>
      </el-table-column>
      <el-table-column label="产品名称" prop="product.name" min-width="120px" />
      <el-table-column label="波段" prop="waveBand" min-width="120px" />
      <el-table-column label="产品款号" prop="product.skuID" min-width="120px" />
      <el-table-column label="订单款号" prop="orderItemNo" min-width="120px" />
      <el-table-column label="交货时间" prop="deliveryDate" min-width="160px">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="合同时间" prop="contractDate" min-width="160px">
        <template slot-scope="scope">
          <span>{{scope.row.contractDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="定作方式" prop="customizedMode" min-width="120px" />
      <el-table-column label="下单数" prop="orderQuantity" min-width="120px" />
      <el-table-column label="裁数" prop="cutQuantity" min-width="120px" />
      <el-table-column label="装箱单数" prop="packageQuantity" min-width="120px" />
      <el-table-column label="正品入库数" prop="storageQuantity" min-width="120px" />
      <el-table-column label="合同单价（不含税）" prop="unitContractPrice" min-width="120px" />
      <el-table-column label="货款金额" prop="loanAmount" min-width="120px" />
      <el-table-column label="快递费" prop="expressFee" min-width="120px" />
      <el-table-column label="扣款" prop="deductionAmount" min-width="120px" />
      <el-table-column label="退货" prop="returnQuantity" min-width="120px" />
      <el-table-column label="结算金额" prop="settlementAmount" min-width="120px" />
      <el-table-column label="定金" prop="depositAmount" min-width="120px" />
      <el-table-column label="备注" prop="remarks" min-width="120px">
        <template slot-scope="scope">
          <span :title="scope.row.remarks" class="remark-title">{{scope.row.remarks}}</span>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'ReconciliationDetailTable',
  props: ['order'],
  computed: {
    tableData: function () {
      let data = [];
      data = data.concat(this.order.entries);
      if (this.order.entries && this.order.entries.length > 0) {
        data.push({
          countRow: '合计',
          orderQuantity: this.countColumn(this.order.entries, 'orderQuantity'),
          cutQuantity: this.countColumn(this.order.entries, 'cutQuantity'),
          packageQuantity: this.countColumn(this.order.entries, 'packageQuantity'),
          storageQuantity: this.countColumn(this.order.entries, 'storageQuantity'),
          // unitContractPrice: this.countColumn(this.order.entries, 'unitContractPrice'),
          loanAmount: this.countColumn(this.order.entries, 'loanAmount'),
          expressFee: this.countColumn(this.order.entries, 'expressFee'),
          deductionAmount: this.countColumn(this.order.entries, 'deductionAmount'),
          returnQuantity: this.countColumn(this.order.entries, 'returnQuantity'),
          depositAmount: this.countColumn(this.order.entries, 'depositAmount'),
          settlementAmount: this.countColumn(this.order.entries, 'settlementAmount')
        });
      }
      return data;
    }
  },
  methods: {
    countColumn (arr, attribute) {
      let count = 0;
      arr.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item[attribute]))) {
          count += Number.parseFloat(item[attribute]);
        }
      })
      
      let regexp = /^.*\.0*$/;
      if (regexp.test(count.toFixed(2) + '')) {
        return count.toFixed(0) == 0 ? '' : count.toFixed(0);
      }
      return count.toFixed(2);
    },
  }
}
</script>

<style scoped>
  .remark-title {
    overflow: hidden;
    text-overflow:ellipsis;
    white-space: nowrap;
  }
</style>