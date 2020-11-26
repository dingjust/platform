<template>
  <div>
    <el-table :data="order.entries" border >
      <el-table-column label="产品图片" min-width="80px">
        <template slot-scope="scope">
          <div v-if="scope.row.product && scope.row.product.images[0].id && scope.row.product.images[0].id !== ''"> 
            <img :src="scope.row.product.images[0].url" style="width: 50px; height: 50px"/>
          </div>
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
      <el-table-column label="备注" prop="remarks" min-width="120px">
        <template slot-scope="scope">
          <span :title="scope.row.remarks">{{scope.row.remarks}}</span>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'ReconciliationDetailTable',
  props: ['order']
}
</script>

<style scoped>

</style>