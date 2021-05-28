<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="订单编号" prop="originCode"></el-table-column>
      <el-table-column label="订单类型">
        <template slot-scope="scope">
          <span>{{getEnum('AuditLabel', scope.row.type)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建人" prop="submitUser.name"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审批人" show-overflow-tooltip>
        <template slot-scope="scope">
          <span>{{approvalNames(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审批时间">
        <template slot-scope="scope">
          <template v-if="scope.row.currentUserAuditTime">
            <span>{{scope.row.currentUserAuditTime | formatDate}}</span>
          </template>
        </template>
      </el-table-column>
      <el-table-column label="个人审批">
        <template slot-scope="scope">
          <span v-if="scope.row.currentUserAuditState">{{getEnum('AuditState', scope.row.currentUserAuditState)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="任务状态">
        <template slot-scope="scope">
          <div style="display:flex;align-items: center;">
            <span>
              {{getEnum('AuditState', scope.row.state)}}
            </span>
            <el-tooltip v-if="scope.row.state === 'AUDITED_FAILED'" effect="dark" :content="auditMsg(scope.row)" placement="top-start">
              <h6 style="color: #F56C6C;margin: 0px">({{failedApprover(scope.row)}})</h6>
            </el-tooltip>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button v-if="scope.row.state !== 'REVOKED' && scope.row.state !== 'AUDITED_FAILED'" type="text" size="mini" @click="onDetail(scope.row)">查看</el-button>
          <template v-if="canAudit(scope.row)">
            <el-divider direction="vertical" />
            <authorized :permission="['DO_AUDIT']">
              <el-button type="text" size="mini" @click="onAudit(scope.row, true)">通过</el-button>
            </authorized>
            <el-divider direction="vertical" />
            <authorized :permission="['DO_AUDIT']">
              <el-button type="text" size="mini" @click="onAudit(scope.row, false)">驳回</el-button>
            </authorized>
          </template>
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
      failedApprover (row) {
        const arr = row.processes.filter(item => item.state === 'AUDITED_FAILED');
        return arr[0].auditUser.name;
      },
      auditMsg (row) {
        const arr = row.processes.filter(item => item.state === 'AUDITED_FAILED');
        return arr[0].auditMsg;
      },
      approvalNames (row) {
        if (row.processes && row.processes.length > 0) {
          return row.processes.map(item => item.auditUser.name).toString();
        }
      },
      canAudit (row) {
        return row.state === 'AUDITING' && row.currentUserAuditState === 'AUDITING';
      },
      onDetail(row) {
        this.$emit('onDetail', row);
      },
      onAudit (row, flag) {
        if (row.auditingUser.uid === this.$store.getters.currentUser.uid) {
          if (flag) {
            this.$emit('onApproval', row);
          } else {
            this.$emit('onRefuse', row)
          }
        } else {
          this.$message.warning('此订单暂未轮到您进行审批。');
        }
      },
      getState (row) {
        if (row.currentUserAuditState != null) {
          return row.currentUserAuditState;
        }
        return row.state;
      },
      // onApproval(row) {
      //   if (this.isAuditUser(row)) {
      //     this.$emit('onApproval', row);
      //   }
      // },
      // onRefuse(row) {
      //   if (this.isAuditUser(row)) {
      //     this.$emit('onRefuse', row)
      //   }
      // },
      // isAuditUser (row) {
      //   if (row.auditingUser.uid === this.) {

      //   }
      // },
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
