<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex">
        <el-col :span="20">
          <el-form-item label="任务关键词" class="toolbar-form-item">
            <el-input placeholder="输入任务编号、名称" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
          <el-form-item label="负责人" class="toolbar-form-item">
            <el-input placeholder="输入负责人名称" v-model="queryFormData.charge"></el-input>
          </el-form-item>
          <el-form-item label="创建时间" class="toolbar-form-item">
            <el-date-picker v-model="queryFormData.creationtime" type="date" placeholder="选择日期"/>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-row type="flex" align="top" justify="start" :gutter="20">
            <el-button-group>
              <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
              <el-button native-type="reset" @click="onReset">重置</el-button>
            </el-button-group>
          </el-row>
        </el-col>
      </el-row>
      <el-row>
        <span class="status_name_label">工单状态：</span>
        <el-radio-group v-model="queryFormData.status" @change="onAdvancedSearch">
          <el-radio :label="''">全部</el-radio>
          <template v-for="(status, index) in statuses">
            <el-radio :label="status.code">{{status.name}}</el-radio>
          </template>
        </el-radio-group>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'TaskApprovalToolbar',
    props: ['queryFormData', 'statuses'],
    computed: {

    },
    methods: {
      onReset () {
        this.$emit('onReset');
      },
      onAdvancedSearch () {
        this.$emit('onAdvancedSearch');
      }
    },
    data () {
      return {
      }
    },
    created () {

    },
    mounted () {

    }
  }
</script>

<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  /deep/ .el-radio__inner {
    border: 0px solid #DCDFE6;
    border-radius: 100%;
    width: 0px;
    height: 0px;
  }

  /deep/ .el-radio__label {
    padding-left: 0px;
  }

  .status_name_label {
    margin-top: 7px;
    margin-right: 5px;
  }

  /deep/ .el-radio-group {
    margin-top: 7px;
  }

  .toolbar-form-item {
    margin-bottom: 5px;
  }
</style>
