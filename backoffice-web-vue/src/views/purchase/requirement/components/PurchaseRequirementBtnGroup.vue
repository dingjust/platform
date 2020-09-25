<template>
  <el-row type="flex" justify="center">
    <el-button class="sumbit-btn" @click="onSave(false)">保存</el-button>
    <el-button class="sumbit-btn" @click="onSave(true)">提交创建</el-button>
    <el-button v-if="formData.state === 'NOT_COMMITED' || formData.state === 'AUDITED_FAIL'" type="text" @click="onDelete">删除</el-button>
  </el-row>
</template>

<script>
export default {
  name: 'PurchaseRequirementBtnGroup',
  props: ['formData'],
  methods: {
    onSave (flag) {
      this.$emit('onSave', flag);
    },
    onDelete () {
      this.$emit('onDelete');
    }
  }  
}
</script>

<style scoped>
  .sumbit-btn {
    width: 100px;
    color: #606266;
    background-color: #ffd60c;
  }
</style>