<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" highlight-current-row :height="autoHeight">
      <el-table-column label="申请单号" prop="code"/>
      <el-table-column label="关联订单" prop="bill.productionOrder.code"/>
      <el-table-column label="付款内容" prop="paymentFor"/>
      <el-table-column label="创建人" prop="applyUser.name"/>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="申请金额" prop="requestAmount"/>
      <el-table-column label="收款对象" prop="payable.name" />
      <el-table-column label="付款时间">
        <!-- <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template> -->
      </el-table-column>
      <!-- <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('PaymentRequestState', scope.row.state)}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
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
    name: 'PaymentRequestList',
    props: ['page'],
    components: {
    },
    computed: {
    },
    methods: {
      onPageSizeChanged(val) {
        this.$emit('onAdvancedSearch', 0, val);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged(val) {
        this.$emit('onAdvancedSearch', val - 1);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onDetail (row) {
        this.$emit('onDetail', row);
      }
    },
    data () {
      return {
      }
    },
    created () {
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>

</style>