<template>
  <div class="animated fadeIn">
    <el-steps v-if="isPendingQuote" align-center
              finish-status="success"
              :active="0">
      <el-step title="报价中"></el-step>
    </el-steps>
    <el-steps v-else-if="isCompleted" align-center
              finish-status="success"
              :active="0">
      <el-step title="已完成"></el-step>
    </el-steps>
    <el-steps v-else="isCancelled" align-center
              finish-status="success"
              :active="0">
      <el-step title="已失效"></el-step>
    </el-steps>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderStatusBar',
    props: ['status'],
    computed: {
      active: function () {
        return this.$store.state.EnumsModule.requirementOrderStatusFlow[this.status];
      },
      isPendingQuote: function () {
        return this.status === 'PENDING_QUOTE';
      },
      isCompleted: function () {
        return this.status === 'COMPLETED';
      },
      isCancelled: function () {
        return this.status === 'CANCELLED';
      }
    },
  }
</script>
