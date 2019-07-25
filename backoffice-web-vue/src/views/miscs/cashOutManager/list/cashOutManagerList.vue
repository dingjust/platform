<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="账单编号" prop="code"  fixed width="120"></el-table-column>
      <el-table-column label="公司名称" prop="company.name" width="180"></el-table-column>
      <el-table-column label="提现账户" prop="account.cardNumber" min-width="120"></el-table-column>
      <el-table-column label="提现金额" prop="amount"></el-table-column>
      <!--<el-table-column label="账单来源" prop="flowSource">-->
        <!--<template slot-scope="scope">-->
          <!--{{scope.row.flowSource|enumTranslate('FlowSource')}}-->
        <!--</template>-->
      <!--</el-table-column>-->
      <!--<el-table-column label="账单类型" prop="amountFlowType">-->
        <!--<template slot-scope="scope">-->
          <!--{{scope.row.amountFlowType|enumTranslate('AmountFlowType')}}-->
        <!--</template>-->
      <!--</el-table-column>-->
      <el-table-column label="账单状态" prop="amountStatus">
        <template slot-scope="scope">
          {{scope.row.amountStatus|enumTranslate('AmountStatus')}}
        </template>
      </el-table-column>
      <el-table-column label="提现发起时间" prop="creationtime" width="150" >
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDateWithSecond}}</span>
        </template>
      </el-table-column>
      <!--<el-table-column label="提现完成时间" prop="cashCompletionTime" width="120">-->
        <!--<template slot-scope="scope">-->
          <!--<span>{{scope.row.cashCompletionTime | formatDate}}</span>-->
        <!--</template>-->
      <!--</el-table-column>-->
      <!--<el-table-column label="描述" prop="description" width="180"></el-table-column>-->
      <el-table-column label="操作"  fixed="right" width="180">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          <el-button type="text" icon="el-icon-edit" @click="onCompleted(scope.row)" v-show="!(scope.row.amountStatus == 'REJECTED' || scope.row.amountStatus == 'REVIEWED')">确认</el-button>
          <el-button type="text" icon="el-icon-delete" @click="onRejected(scope.row)" v-show="!(scope.row.amountStatus == 'REJECTED' || scope.row.amountStatus == 'REVIEWED')">拒绝</el-button>
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
    props: ['page'],
    computed: {},
    methods: {
      onPageSizeChanged (val) {
        this._reset();

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        this.$emit('onSearch', val - 1);
      },
      _reset () {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails (row) {
        this.$emit('onDetails', row);
      },
      onRejected (row) {
        this.$emit('onRejected', row);
      },
      onCompleted (row) {
        this.$emit('onCompleted', row);
      }
    },
    data () {
      return {
      }
    }
  }
</script>
