<template>
  <el-form :inline="true">
    <el-row type="flex" justify="start">
        <el-form-item label="工单信息" prop="name">
          <el-input placeholder="工单号，产品名或货号" v-model="queryFormData.keyword"></el-input>
        </el-form-item>
        <el-form-item label="跟单员" prop="name">
          <el-input placeholder="跟单员姓名" v-model="queryFormData.operatorName"></el-input>
        </el-form-item>
        <el-form-item label="交货日期">
          <el-date-picker
            v-model="dateArr"
            value-format="timestamp"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期">
          </el-date-picker>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
          <el-button native-type="reset" @click="onReset">重置</el-button>
        </el-button-group>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'ProgressOrderToolbar',
    props: ['queryFormData'],
    computed: {

    },
    methods: {
      onAdvancedSearch () {
        this.$emit('onAdvancedSearch');
      },
      onReset () {
        this.queryFormData.keyword = '';
        this.queryFormData.statuses = '';
        this.queryFormData.expectedDeliveryDateFrom = '';
        this.queryFormData.expectedDeliveryDateTo = '';
        this.queryFormData.operatorName = '';
      }
    },
    data () {
      return {
        dateArr: ''
      }
    },
    watch: {
      dateArr: function (newVal, oldVal) {
        this.queryFormData.expectedDeliveryDateFrom = newVal[0];
        this.queryFormData.expectedDeliveryDateTo = newVal[1];
      }
    },
    created () {

    },
    mounted () {

    }
  }
</script>

<style scoped>
  /deep/ .el-date-editor .el-range-separator {
     padding: 0px;
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
    margin-right: 0px;
  }

  /deep/ .el-radio-group {
    margin-top: 7px;
  }

  /deep/ .el-form-item {
     margin-bottom: 0px;
  }

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>
