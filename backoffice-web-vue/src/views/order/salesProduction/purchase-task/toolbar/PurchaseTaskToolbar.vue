<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="start" align="middle">
        <el-col :span="20">
          <el-form-item label="订单信息">
            <el-input placeholder="输入订单号、产品名或货号" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
          <el-form-item label="负责人">
            <el-input placeholder="输入跟单员姓名" v-model="queryFormData.name"></el-input>
          </el-form-item>
          <el-form-item label="合作商">
            <el-input placeholder="输入合作商名称" v-model="queryFormData.cooperator"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="4">
          <el-row type="flex" justify="end" align="middle">
            <el-button type="primary" class="create-button" @click="createPurchaseTask">创建采购任务</el-button>
            <el-button type="primary" class="create-button">分配采购员</el-button>
          </el-row>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'PurchaseTaskToolbar',
    props: ['queryFormData'],
    methods: {
      onAdvancedSearch () {
        this.$emit('onAdvancedSearch');
      },
      onReset () {
        this.queryFormData.keyword = '';
        this.queryFormData.name = '';
        this.queryFormData.cooperator = '';
      },
      createPurchaseTask () {
        this.$emit('createPurchaseTask');
      }
    }
  }
</script>

<style scoped>
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  /deep/ .el-form-item {
     margin-bottom: 0px;
  }

  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    height: 40px;
    color: #606266;
  }
</style>
