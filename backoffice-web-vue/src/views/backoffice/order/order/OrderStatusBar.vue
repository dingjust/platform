<template>
  <div class="animated fadeIn">
    <el-steps align-center
              finish-status="success"
              :active="active">
      <el-step title="待付款"></el-step>
      <el-step title="待发货"></el-step>
      <el-step title="已发货"></el-step>
      <el-step title="已完成"></el-step>
    </el-steps>
  </div>
</template>

<script>
  export default {
    name: 'OrderStatusBar',
    props: ['status'],
    methods: {},
    computed: {
      active: function () {
        return this.$store.state.EnumsModule.salesOrderStatusProcessFlow[this.status];
      }
    }
  }
</script>
