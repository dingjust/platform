<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="19" style="padding-top: 5px">
          <el-form-item label="订单信息" prop="name">
            <el-input placeholder="请输入订单号，订单名称" v-model="keyword"></el-input>
          </el-form-item>
          <el-form-item label="负责人" prop="name">
            <el-input placeholder="请输入跟单员姓名" v-model="form.name"></el-input>
          </el-form-item>
          <el-form-item label="合作商" prop="name">
            <el-input placeholder="请输入合作商名称" v-model="form.name"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="5">
          <el-row type="flex" justify="end">
            <el-button type="primary" class="create-button" @click="createOutboundOrder">创建外发订单</el-button>
          </el-row>
        </el-col>
      </el-row>
    </el-form>
    <sales-production-status-bar :statuses="statuses" :queryFormData="queryFormData"/>
  </div>
</template>

<script>
  import SalesProductionStatusBar from '../../components/SalesProductionStatusBar';
  export default {
    name: 'ProdcutionTaskToolbar',
    components: {SalesProductionStatusBar},
    methods: {
      onAdvancedSearch () {

      },
      onReset () {

      },
      createOutboundOrder () {
        this.$emit('createOutboundOrder');
        this.$message('----------------创建外放订单---------------------');
      }
    },
    data () {
      return {
        keyword: '',
        form: {
          name: ''
        },
        queryFormData: {
          status: '',
          hasContact: '',
          isArrears: '',
          isDelay: ''
        },
        statuses: this.$store.state.EnumsModule.SalesProductionStatuses
      }
    }
  }
</script>

<style scoped>
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

  .el-form-item--mini.el-form-item, .el-form-item--small.el-form-item {
    margin-bottom: 5px !important;
  }
</style>
