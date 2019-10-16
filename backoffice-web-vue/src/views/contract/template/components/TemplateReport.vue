<template>
  <el-card>
    <el-row type="flex" justify="space-between" align="top">
      <el-col :span="3">
        <div class="grid-head">
          <h6>合同模板</h6>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="template-grid-content">
          <h5>模板总数量 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="template-grid-content">
          <h5>采购合同模板 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="template-grid-content">
          <h5>框架协议模板 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="template-grid-content">
          <h5>附件合同模板 51</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="template-grid-content">
          <h5>附件合同模板 51</h5>
        </div>
      </el-col>
    </el-row>
  </el-card>
</template>

<script>
  export default {
    name: "TemplateReport",
    components: {},
    computed: {},
    methods: {},
    data() {
      return {};
    },
    created() {}
  };

</script>
<style>
  .template-grid-content {
    text-align: center;
    border-left: 2px solid rgba(0, 0, 0, 0.09);
  }

  .grid-head {
    text-align: start;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .grid-tail {
    text-align: end;
    color: orange;
  }

  .el-card__body {
    padding: 10px;
  }

</style>
