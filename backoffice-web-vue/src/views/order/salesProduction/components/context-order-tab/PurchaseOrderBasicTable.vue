<template>
  <div>
    <el-table :data="purchaseList" stripe style="width: 100%">
      <el-table-column label="采购任务号" prop="code"></el-table-column>            
      <el-table-column label="采购期限"></el-table-column>
      <el-table-column label="采购员" prop="merchandiser.name"></el-table-column>
      <el-table-column label="审批状态">
        <template slot-scope="scope">
          <span>{{getEnum('AuditState', scope.row.auditWorkOrder.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="标签">
        <template slot-scope="scope">
          <span>{{getEnum('PurchaseTaskState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onProductDetail(scope.row)">查看</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="taskVisible" width="80%" append-to-body :close-on-click-modal="false">
      <purchase-requirement-detail v-if="taskVisible" :id="taskId" />
    </el-dialog>
  </div>
</template>

<script>
import PurchaseRequirementDetail from '@/views/purchase/requirement/details/PurchaseRequirementDetail'
export default {
  name: 'PurchaseOrderBasicTable',
  components: {
    PurchaseRequirementDetail
  },
  props: ['purchaseList'],
  methods: {
    onProductDetail(row) {
      this.taskId = row.id;
      this.taskVisible = true;
    }
  },
  data() {
    return {
      taskVisible: false
    }
  },
  created () {
  }
}
</script>

<style scoped>
</style>
