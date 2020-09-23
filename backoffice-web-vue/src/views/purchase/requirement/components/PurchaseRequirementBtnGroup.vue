<template>
  <el-row type="flex" justify="center">
    <el-button class="sumbit-btn" @click="onSave(false)">保存</el-button>
    <el-button class="sumbit-btn" @click="onSave(true)">提交创建</el-button>
    <!-- <el-button type="text" @click="onDelete">删除</el-button>
    <el-button class="sumbit-btn" @click="onReturn">撤回</el-button> -->
  </el-row>
</template>

<script>
export default {
  name: 'PurchaseRequirementBtnGroup',
  methods: {
    onSave (flag) {
      this.$emit('onSave', flag);
    },
    onDelete () {
      this.$emit('onDelete');
    },
    onReturn () {
      this.$emit('onReturn');
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