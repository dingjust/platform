<template>
  <div class="pend-out-view-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" >
      <el-table-column label="系统单号" prop="code"></el-table-column>
      <el-table-column label="关联订单" prop="originCode"></el-table-column>
      <el-table-column label="交易编号" prop="outOrderNo"></el-table-column>
      <el-table-column label="支付金额" >
        <template slot-scope="scope">
          <span>￥{{scope.row.totalAmount ? scope.row.totalAmount : scope.row.payAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="支付方式" >
        <template slot-scope="scope">
          <span>{{getEnum('PayMethod', scope.row.payType)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="支付时间" >
        <template slot-scope="scope">
          <span v-if="scope.row.paySuccessTime">{{scope.row.paySuccessTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="支付类型" >
        <template slot-scope="scope">
          <el-tag v-if="scope.row.orderType === 'offline'" >线下支付</el-tag>
          <el-tag v-else type="success">线上支付</el-tag>
          <!-- <span>{{scope.row.orderType === 'offline' ? '线下支付' : '线上支付'}}</span> -->
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
export default {
  name: 'PaymentList',
  props: ['page'],
  methods: {
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1, this.page.size);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    }
  }
}
</script>

<style scoped>
  .pend-out-view-list >>> .el-table .cell {
    display: flex;
  }

  .warning-icon {
    color: #ff1744;
    font-size: 20px;
  }

  .sure-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    width: 150px;
    height: 35px;
  }

  .pending-tag {
    color: #67c23a;
    border-Color: #67c23a
  }

  .business-tag {
    color: #ffd60c;
    border-Color: #ffd60c
  }

</style>
