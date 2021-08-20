<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="对账单号" prop="code"></el-table-column>
      <el-table-column label="标题" prop="title"></el-table-column>
      <el-table-column label="甲方">
        <template slot-scope="scope">
          {{scope.row.belongRoleType === 'PARTYA' ? scope.row.receiveParty.name : scope.row.shipParty.name}}
        </template>
      </el-table-column>
      <el-table-column label="乙方">
        <template slot-scope="scope">
          {{scope.row.belongRoleType === 'PARTYA' ? scope.row.shipParty.name : scope.row.receiveParty.name}}
        </template>
      </el-table-column>
      <!-- <el-table-column label="合作商" min-width="200px">
        <template slot-scope="scope">
          <span v-if="scope.row.cooperator">
            {{scope.row.cooperator.type === 'ONLINE' ? scope.row.cooperator.partner.name : scope.row.cooperator.name}}
          </span>
        </template>
      </el-table-column> -->
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('ReconciliationV2Type', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
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
  name: 'ReconciliationViewList',
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
    },
    onDetail (row) {
      this.$router.push('/order/reconciliation/' + row.id);
    }
  }
}
</script>

<style scoped>

</style>