<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="账单编号" prop="code"></el-table-column>
      <el-table-column label="账单来源" prop="flowSource">
        <template slot-scope="scope">
           {{scope.row.flowSource|enumTranslate('FlowSource')}}
        </template>
      </el-table-column>
      <el-table-column label="账单类型" prop="amountFlowType">
        <template slot-scope="scope">
          {{scope.row.amountFlowType|enumTranslate('AmountFlowType')}}
        </template>
      </el-table-column>
      <el-table-column label="账单状态" prop="amountStatus">
        <template slot-scope="scope">
          {{scope.row.amountStatus|enumTranslate('AmountStatus')}}
        </template>
      </el-table-column>
      <el-table-column label="金额" prop="amount"></el-table-column>
      <el-table-column label="账单创建时间" prop="creationtime" width="150">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDateWithSecond}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          <!--<el-button type="text" icon="el-icon-edit" @click="onCanceled(scope.row)">取消</el-button>-->
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
    name: 'OperationCourseList',
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
      onCanceled(row) {
        this.$emit('onCanceled', row);
      },
    },
    data() {
      return {
      }
    }
  }
</script>
