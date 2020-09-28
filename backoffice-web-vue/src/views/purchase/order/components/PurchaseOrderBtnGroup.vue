<template>
  <el-row type="flex" justify="center">
    <el-button class="sumbit-btn" @click="onSave(false)">保存</el-button>
    <el-button class="sumbit-btn" @click="onSave(true)">提交创建</el-button>
    <el-button v-if="canDelete" type="text" @click="onDelete">删除</el-button>
  </el-row>
</template>

<script>
export default {
  name: 'PurchaseOrderBtnGroup',
  props: ['order', 'formData'],
  computed: {
    canDelete: function () {
      return (this.order.state === 'NOT_COMMITED' || this.order.state === 'AUDIT_FAILED') &&
            this.formData.task.merchandiser.uid === this.$store.getters.currentUser.uid;
    }
  },
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