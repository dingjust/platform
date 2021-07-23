<template>
  <el-row style="margin-top: 20px" type="flex" justify="center" align="middle">
    <el-button class="material-btn" @click="onCreate(false)" v-if="!formData['NEW_ACCEPTED']">保存</el-button>
    <el-button class="material-btn" @click="onCreate(true)" v-if="!formData['NEW_MODIFY']">创建并提交</el-button>
    <el-button v-if="canDelete" @click="onDelete" type="text">作废订单</el-button>
  </el-row>
</template>

<script>
export default {
  name: 'OutboundOrderFormBtn',
  props: ['formData', 'canDelete'],
  methods: {
    onCreate (flag) {
      this.$emit('onCreate', flag);
    },
    onDelete () {
      this.$emit('onDelete');
    }
  }
}
</script>

<style scoped>
.material-btn {
  background-color: #ffd60c;
  border-color: #FFD5CE;
  color: #000;
  width: 120px;
  height: 40px;
}
</style>