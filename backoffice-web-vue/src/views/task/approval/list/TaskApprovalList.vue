<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="订单编号" prop="originCode"></el-table-column>
      <el-table-column label="订单类型">
        <template slot-scope="scope">
          <span>{{getEnum('AuditLabel', scope.row.type)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建人" prop="creationPerson"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.deliverytime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="任务状态">
        <template slot-scope="scope">
          <span>{{getEnum('AuditState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" size="mini" @click="onDetail(scope.row)">查看</el-button>
          <el-divider v-if="scope.row.state == 'AUDITING'" direction="vertical"/>
          <el-button v-if="scope.row.state == 'AUDITING'" type="text" size="mini" @click="onApproval(scope.row)">通过</el-button>
          <el-divider v-if="scope.row.state == 'AUDITING'" direction="vertical"/>
          <el-button v-if="scope.row.state == 'AUDITING'" type="text" size="mini" @click="onRefuse(scope.row)">驳回</el-button>
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
    name: 'TaskApprovalList',
    props: ['page'],
    methods: {
      onDetail (row) {
        this.$emit('onDetail', row);
      },
      onApproval (row) {
        this.$emit('onApproval', row);
      },
      onRefuse (row) {
        this.$emit('onRefuse', row)
      },
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
      }
    }
  }
</script>

<style scoped>

</style>
