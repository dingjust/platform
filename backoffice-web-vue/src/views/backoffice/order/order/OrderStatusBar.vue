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
  import {OrderMixin} from 'mixins';

  export default {
    name: 'OrderStatusBar',
    props: ['status'],
    mixins: [OrderMixin],
    methods: {},
    computed: {
      active: function () {
        return this.salesOrderStatusProcessFlow[this.status];
      }
    }
  }
</script>
