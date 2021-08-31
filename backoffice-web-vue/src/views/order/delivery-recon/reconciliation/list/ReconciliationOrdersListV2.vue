<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="对账单号" prop="code"></el-table-column>
      <el-table-column label="标题" prop="title"></el-table-column>
      <el-table-column label="合作商" min-width="200px">
        <template slot-scope="scope">
          <span v-if="scope.row.cooperator">
            {{scope.row.cooperator.type === 'ONLINE' ? scope.row.cooperator.partner.name : scope.row.cooperator.name}}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="对账金额">
        <template slot-scope="scope">{{scope.row.amountPayableTotal}}元</template>
      </el-table-column>
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
      <el-table-column label="" v-if="showTag">
        <template slot-scope="scope" v-if="scope.row.signState">
          <el-tag>{{scope.row.signState === 'WAIT_ME_SIGN' ? '待我签署' : '待他签署'}}</el-tag>
        </template>
        <template slot-scope="scope" v-else-if="scope.row.state === 'PENDING_B_SIGN' || scope.row.state === 'PENDING_A_SIGN'">
          <el-tag>{{tagTitle(scope.row)}}</el-tag>
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
  name: 'ReconciliationOrdersListV2',
  props: ['page', 'activeName'],
  computed: {
    showTag: function () {
      if (this.activeName) {
        return this.activeName === '全部' || this.activeName === 'PENDING_B_SIGN' || this.activeName === 'PENDING_A_SIGN';
      }
    }
  },
  data () {
    return {
      currentUserUid: this.$store.getters.currentUser.uid
    }
  },
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
    onDetail (row) {
      this.$router.push('/order/reconciliation/' + row.id);
    },
    tagTitle (row) {
      if (row.state === 'PENDING_B_SIGN') {
        return row.shipParty.uid === this.$store.getters.currentUser.companyCode ? '待我签署' : '待他签署';
      } else if (row.state === 'PENDING_A_SIGN') {
        return row.receiveParty.uid === this.$store.getters.currentUser.companyCode ? '待我签署' : '待他签署';
      }
    } 
  }
}
</script>

<style scoped>

</style>