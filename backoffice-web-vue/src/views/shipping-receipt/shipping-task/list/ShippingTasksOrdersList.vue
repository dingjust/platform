<template>
  <div>
    <el-table ref="resultTable" stripe :data="formData.orders" :height="autoHeight">
      <el-table-column label="发货单号" prop="code" min-width="120"></el-table-column>
      <el-table-column label="发货数量"></el-table-column>
      <el-table-column label="发货时间"></el-table-column>
      <el-table-column label="收货单"></el-table-column>
      <el-table-column label="收货数"></el-table-column>
      <el-table-column label="收货时间"></el-table-column>
      <el-table-column label="退货单"></el-table-column>
      <el-table-column label="退货数"></el-table-column>
      <el-table-column label="差异数"></el-table-column>
      <el-table-column align="right" min-width="120" v-if="canCreate">
        <template slot="header">
          <el-button @click="onCreate">创建发货订单</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'ShippingTasksOrdersList',
    props: ['formData'],
    components: {

    },
    computed: {
      canCreate: function () {
        // TODO 判断是否能创建发货订单
        return true;
      }
    },
    methods: {
      onCreate () {
        this.$emit('onCreate');
      }
    },
    data () {
      return {

      }
    },
    create () {
      
    }
  }
</script>

<style scope>

</style>