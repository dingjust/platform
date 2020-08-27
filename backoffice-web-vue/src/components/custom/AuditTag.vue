<!-- 
 * @description: 审核状态标签
 * @fileName: AuditTag.vue 
 * @author: yj 
 * @date: 2020-08-27 14:03:33
 * @version: V1.0.0 
!-->
<template>
  <el-tag :type="tagType">{{getEnum('SalesProductionAuditStatus', state)}}</el-tag>
</template>
<script>
  export default {
    name: 'AuditTag',
    props: {
      state:{
        type:String,
        default:'NONE'
      }
    },
    computed: {
      tagType: function () {
        switch (this.state) {
          case 'NONE':
            return 'info';
          case 'AUDITING':
            return 'warning';
          case 'PASSED':
            return 'success';
          case 'AUDITED_FAILED':
            return 'danger'
        }
      }
    }
  };
</script>
