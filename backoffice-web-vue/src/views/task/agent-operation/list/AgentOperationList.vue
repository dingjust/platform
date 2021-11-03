<template>
  <div class="recommend-code-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="公司号" prop="submittedBy.uid" min-width="120px"></el-table-column>
      <el-table-column label="申请公司" prop="submittedBy.name" min-width="200px"></el-table-column>
      <el-table-column label="联系方式" prop="submittedBy.contactPhone" min-width="100px"></el-table-column>
      <el-table-column label="账号类型" min-width="80px">
        <template slot-scope="scope">
          <span>{{accountType[scope.row.submittedBy.type]}}</span>
        </template>
      </el-table-column>
      <el-table-column label="认证状态" min-width="80px">
        <template slot-scope="scope">
          <span>{{scope.row.submittedBy.approvalStatus === 'approved' ? '已认证' : '未认证'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审阅状态" min-width="80px">
        <template slot-scope="scope">
          <span>{{getEnum('FactoryReviewState', scope.row.status)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审阅时间">
        <template slot-scope="scope">
          <span v-if="scope.row.reviewedDate">{{scope.row.reviewedDate | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="80px">
        <template slot-scope="scope">
          <el-button v-if="scope.row.status === 'REVIEWING'" type="text" @click="onPass(scope.row)">通过</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog title="代运营人信息填写" :visible.sync="sumbitVisible" width="400px" append-to-body :close-on-click-modal="false">
      <agent-operation-form v-if="sumbitVisible" :handleRow="handleRow" @closeDialog="sumbitVisible=false" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
import AgentOperationForm from '../components/AgentOperationForm'
export default {
  name: 'AgentOperationList',
  components: { AgentOperationForm },
  props: ['page'],
  methods: {
    onPass (row) {
      this.handleRow = row;
      this.sumbitVisible = true;
    },
    callback () {
      this.$emit('onAdvancedSearch');
      this.sumbitVisible = false;
    },
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
  },
  data () {
    return {
      sumbitVisible: false,
      handleRow: null,
      accountType: {
        FACTORY: '工厂账号',
        BRAND: '品牌账号'
      }
    }
  }
}
</script>

<style scoped>
  .el-dropdown-link {
    cursor: pointer;
    color: #409EFF;
    font-size: 12px;
  }
  .el-icon-arrow-down {
    font-size: 12px;
  }
</style>