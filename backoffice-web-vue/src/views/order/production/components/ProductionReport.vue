<template>
  <el-card>
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="4">
        <div class="grid-head">
          <h6>合同文件</h6>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="grid-content">
          <h5>待签署 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="grid-content">
          <h5>已完成 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="grid-content">
          <h5>已作废 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="grid-content">
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
    name: "ProductionReport",
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
  .grid-content {
    text-align: center;
    border-left: 2px solid #ffd60c;
  }

  .grid-head {
    text-align: start;
  }

  .grid-tail {
    text-align: end;
    color: orange;
  }

.el-card__body {
    padding: 10px;
}
</style>
