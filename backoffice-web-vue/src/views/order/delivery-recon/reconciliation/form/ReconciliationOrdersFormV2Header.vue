<template>
  <el-row type="flex" justify="start" align="top">
    <div>
      <el-form-item label="发货单">
        <el-input v-model="formData.fastShippingSheets.code" :disabled="true"></el-input>
      </el-form-item>
    </div>
    <div>
      <el-button type="primary" class="select-btn" @click="onSelect">选择</el-button>
    </div>
  </el-row>
</template>

<script>
export default {
  name: "ReconciliationOrdersFormV2Header",
  props: ["formData"],
  methods: {
    onSelect () {
      
    }
  }
};
</script>

<style scoped>
  .select-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #606266;
  }

</style>