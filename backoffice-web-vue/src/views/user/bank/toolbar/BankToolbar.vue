<template>
  <div>
    <el-row type="flex" justify="end">
      <el-button type="primary" @click="onNew">新建</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'BankToolbar',
  methods: {
    onNew () {
      this.$emit('onNew')
    }
  }
}
</script>

<style scoped>
</style>
