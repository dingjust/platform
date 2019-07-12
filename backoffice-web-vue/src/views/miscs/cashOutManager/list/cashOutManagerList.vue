<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="公司" prop="company.uid"></el-table-column>
      <el-table-column label="账户" prop="account"></el-table-column>
      <el-table-column label="金额" prop="amount"></el-table-column>
      <el-table-column label="流水来源" prop="flowSource"></el-table-column>
      <el-table-column label="流水类型" prop="amountFlowType"></el-table-column>
      <el-table-column label="流水状态" prop="amountStatus"></el-table-column>
      <el-table-column label="描述" prop="description"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          <el-button type="text" icon="el-icon-edit" @click="onCompleted(scope.row)">确认</el-button>
          <el-button type="text" icon="el-icon-delete" @click="onRejected(scope.row)">拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right"
                   layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  export default {
    name: 'CashOutManagerList',
    props: ["page"],
    computed: {},
    methods: {
      onPageSizeChanged(val) {
        this._reset();

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
      onRejected(row) {
        this.$emit('onRejected', row);
      },
      onCompleted(row) {
        this.$emit('onCompleted', row);
      },
    },
    data() {
      return {
      }
    }
  }
</script>
