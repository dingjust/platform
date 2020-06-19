<template>
  <div class="container-border">
    <el-row>
      
    </el-row>
    <el-row type="flex" justify="end" align="middle">
      <el-col :span="3">
        <h6>订单数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>应发数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>已发数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>已退数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>实收数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>差异数：200000</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ShippingTasksQuantityTable',
    components: {
    },
    computed: {
    },
    methods: {
    },
    data() {
      return {
      }
    },
    created() {
    },
    destroyed() {

    }
  }
</script>

<style scoped>
</style>