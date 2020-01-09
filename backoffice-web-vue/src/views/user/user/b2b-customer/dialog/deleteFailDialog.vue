<template>
  <div>
    <el-row type="flex" justify="center" class="dialog-row">
      <h6>该部门已有员工，不支持删除操作</h6>
    </el-row>
  </div>
</template>

<script>
    export default {
      name: 'deleteFailDialog'
    }
</script>

<style scoped>
  .dialog-row {
    margin-top: 20px;
  }

  .info-cancel {
    color: #000;
    width: 100px;
  }

  .info-confirm {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 100px;
  }
</style>
