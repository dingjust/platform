<template>
  <el-row type="flex" justify="center" align="middle">
    <el-button class="create-btn" @click="onCreate">{{this.id ? '编辑' : '创建'}}</el-button>
  </el-row>
</template>

<script>
export default {
  name: 'QuoteOrderBtnGroup',
  props: ['id'],
  methods: {
    onCreate () {
      this.$emit('onCreate');
    },
    onEdit () {
      this.$emit('onEdit');
    }
  }
}
</script>

<style scoped>
  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>