<template>
  <div class="material-bill-top">
    <el-row type="flex" class="material-bill-top">
      <el-col>
        <el-button @click="addRow">+ 添加购买批次</el-button>
      </el-col>
    </el-row>
    <el-row type="flex" class="material-bill-top">
      <el-table border :data="formData.materialsOrder"
                :header-cell-style="{'text-align':'center'}"
                :cell-style="{'text-align':'center'}">
        <el-table-column label="参数"/>
        <el-table-column label="对应订单数量"/>
        <el-table-column label="物料需求数"/>
        <el-table-column label="加减数量"/>
        <el-table-column label="实际采购总数"/>
        <el-table-column label="单价价格"/>
        <el-table-column label="预计总价"/>
      </el-table>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'MaterialsBillTable',
    props: ['formData'],
    computed: {},
    methods: {
      addRow () {

      }
    },
    data () {
      return {

      }
    },
    created () {
    },
    mounted () {
    }
  }
</script>

<style scoped>
  .material-bill-top {
    margin-left: 10px;
    margin-top: 20px;
  }
</style>
