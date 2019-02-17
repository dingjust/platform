<template>
  <div class="animated fadeIn">
    <el-steps align-center
              finish-status="success"
              :active="active">
      <el-step title="待处理"></el-step>
      <el-step title="待确认"></el-step>
      <el-step title="已确认"></el-step>
      <el-step title="待出库"></el-step>
      <el-step title="已出库"></el-step>
      <el-step title="已完成"></el-step>
    </el-steps>
  </div>
</template>

<script>
  import {OrderMixin} from '@/mixins';

  export default {
    name: 'RequirementOrderStatusBar',
    props: ['status'],
    mixins: [OrderMixin],
    methods: {},
    computed: {
      active: function () {
        return this.orderStatusProcessFlow[this.status];
      }
    }
  }
</script>
