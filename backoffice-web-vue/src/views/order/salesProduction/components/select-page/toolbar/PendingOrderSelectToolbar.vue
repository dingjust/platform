<template>
  <div>
    <el-form :inline="true" label-position="left">
      <el-row type="flex" justify="space-between">
        <el-col :span="24">
          <el-form-item label="订单信息" prop="name">
            <el-input placeholder="订单号，订单名称" v-model="queryFormData.keyword" class="input-item"></el-input>
          </el-form-item>
          <el-form-item label="负责人" prop="name">
            <el-input placeholder="跟单员姓名" v-model="queryFormData.planLeader" class="input-item"></el-input>
          </el-form-item>
          <el-form-item label="合作商" prop="name">
            <el-input placeholder="合作商名称" v-model="queryFormData.originCooperator" class="input-item"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'PendingOrderSelectToolbar',
    props: ['queryFormData'],
    components: {
    },
    computed: {},
    data() {
      return {
      }
    },
    methods: {
      onAdvancedSearch() {
        this.$emit('onAdvancedSearch', 0);
      },
      onReset() {
        this.queryFormData.keyword = '';
        this.queryFormData.planLeader = '';
        this.queryFormData.originCooperator = '';
      }
    },
    created() {
    }
  }

</script>
<style scoped>
  .input-item {
    width: 170px;    
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    height: 40px;
    color: #606266;
  }

  .create-button_blue {
    /* background-color: #ecf5ff;
    border-color: #b3d8ff; */
    /* width: 50px; */
    height: 25px;
    /* color: #409eff; */
  }

  .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px !important;
  }

</style>
