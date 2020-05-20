<template>
  <div>
    <el-row class="progress-row">
      <el-row>
        <el-col>
          <h6>生产要求</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="progress-basic-row">
        <el-row>
          <h6>工艺要求</h6>
        </el-row>
      </el-row>
      <el-row type="flex" justify="center" class="progress-basic-row">
        <el-col :span="22">
          <el-input type="textarea" v-model="formData.productionProcessContent"></el-input>
        </el-col>
      </el-row>
      <el-row class="progress-basic-row">
        <progress-order-factory-node-form :formData="formData"/>
      </el-row>
    </el-row>
  </div>
</template>

<script>
  import ProgressOrderFactoryNodeForm from './ProgressOrderFactoryNodeForm';
  export default {
    name: 'ProgressOrderProductionAskForm',
    components: {ProgressOrderFactoryNodeForm},
    props: ['formData']
  }
</script>

<style scoped>
  .progress-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .progress-basic-row {
    padding-left: 20px;
    margin-top: 10px
  }
</style>
