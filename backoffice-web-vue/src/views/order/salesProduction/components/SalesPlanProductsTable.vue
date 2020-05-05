<template>
  <el-table :data="tableData" stripe style="width: 100%">
    <el-table-column type="selection" width="55">
    </el-table-column>
    <el-table-column prop="date" label="产品名称" >
    </el-table-column>
    <el-table-column prop="name" label="数量">
    </el-table-column>
    <el-table-column prop="address" label="预计销售单价/元">
    </el-table-column>
    <el-table-column prop="address" label="预计销售总价/元">
    </el-table-column>
  </el-table>
</template>

<script>
  export default {
    name: 'SalesPlanProductsTable',
    data() {
      return {
        tableData: [{
          date: '2016-05-02',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }, {
          date: '2016-05-04',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1517 弄'
        }, {
          date: '2016-05-01',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1519 弄'
        }, {
          date: '2016-05-03',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1516 弄'
        }]
      }
    }
  }

</script>

<style scoped>

</style>
