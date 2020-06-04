<template>
  <div>
    <el-table :data="data" stripe style="width: 100%">
      <el-table-column label="采购任务号">
      </el-table-column>            
      <el-table-column label="采购期限">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="采购员">
      </el-table-column>
      <el-table-column label="审批状态">
        <!-- <template slot-scope="scope">
          <span>{{scope.row.status!=null? getEnum('SalesProductionAuditStatus', scope.row.auditState):''}}</span>
        </template> -->
      </el-table-column>
      <el-table-column label="标签">
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onProductDetail(scope.row)">查看</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'PurchaseOrderBasicTable',
    components: {},
    props: {
      data: {
        type: Array
      }
    },
    methods: {
      onProductDetail(row) {
        this.$router.push('/sales/production/' + id);
      },
    },
    data() {
      return {

      }
    }
  }

</script>

<style scoped>

</style>
