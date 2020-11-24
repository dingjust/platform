<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="对账单号" prop="code"></el-table-column>
      <el-table-column label="合作商" prop="cooperator"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'ReconciliationOrdersListV2',
  props: ['page'],
  methods: {
    onDetail (row) {
      
    }
  }
}
</script>

<style scoped>

</style>