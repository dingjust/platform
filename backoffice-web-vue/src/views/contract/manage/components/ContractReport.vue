<template>
  <el-card>
    <el-row type="flex" justify="space-between" align="top">
      <el-col :span="4">
        <div class="grid-head">
          <h6>合同文件</h6>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="contract-grid-content">
          <h5>待签署 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="contract-grid-content">
          <h5>已完成 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="contract-grid-content">
          <h5>已作废 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="contract-grid-content">
          <h5>合同总数 51</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="grid-tail">
          <el-link type="warning">
            <h6>了解电子合同</h6>
          </el-link>
        </div>
      </el-col>
    </el-row>
  </el-card>
</template>

<script>
  export default {
    name: "ContractReport",
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
  .contract-grid-content {
    text-align: center;
    border-left: 2px solid rgba(0,0,0,0.09);
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
