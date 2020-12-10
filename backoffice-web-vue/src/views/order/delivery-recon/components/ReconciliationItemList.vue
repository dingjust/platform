<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
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
      <el-table-column label="合同单价（不含税）" prop="unitContractPrice" min-width="130px" />
      <el-table-column label="货款金额" prop="loanAmount" min-width="120px" />
      <el-table-column label="快递费" prop="expressFee" min-width="120px" />
      <el-table-column label="扣款" prop="deductionAmount" min-width="120px" />
      <el-table-column label="退货" prop="returnQuantity" min-width="120px" />
      <el-table-column label="结算金额" prop="settlementAmount" min-width="120px" />
      <el-table-column label="备注" prop="remarks" min-width="120px">
        <template slot-scope="scope">
          <span :title="scope.row.remarks" class="remark-title">{{scope.row.remarks}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" fixed="right" min-width="60px">
        <template slot-scope="scope">
          <el-button type="text" @click="openOrigin(scope.row)">来源</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
export default {
  name: 'ReconciliationItemList',
  props: ['page'],
  methods: {
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1, 10);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    openOrigin (row) {
      this.$router.push('/order/reconciliation/' + row.belongSheet.id);
    }
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