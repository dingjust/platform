<template>
  <div>
    <el-table ref="resultTable" stripe :data="formData.orders" :height="autoHeight">
      <el-table-column prop="code" align="left" min-width="120">
        <template slot="header">
          <el-tooltip effect="light" :content="tips" placement="top">
            <span>收货单号<i class="el-icon-question"/></span>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column label="发货数量"></el-table-column>
      <el-table-column label="单价"></el-table-column>
      <el-table-column label="收货总额"></el-table-column>
      <el-table-column label="收货时间"></el-table-column>
      <el-table-column label="状态"></el-table-column>
      <el-table-column label="对账单号"></el-table-column>
      <el-table-column label="对账数量"></el-table-column>
      <el-table-column label="单价"></el-table-column>
      <el-table-column label="对账金额"></el-table-column>
      <el-table-column label="扣款金额"></el-table-column>
      <el-table-column label="增款金额"></el-table-column>
      <el-table-column label="实付金额"></el-table-column>
      <el-table-column label="状态"></el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'ReconciliationTasksOrdersList',
    props: ['formData'],
    components: {

    },
    computed: {
    },
    methods: {
    },
    data () {
      return {
        tips: '这里只显示待对账及已对账状态下的收货单'
      }
    },
    create () {
      
    }
  }
</script>

<style scope>

</style>