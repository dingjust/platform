<template>
  <el-form :inline="true">
    <el-row type="flex" justify="space-between">
<!--      <el-col :span="20" style="padding-top: 5px">-->
        <el-form-item label="工单信息" prop="name">
          <el-input placeholder="工单号，产品名或货号" v-model="queryFormData.keyword"></el-input>
        </el-form-item>
        <el-form-item label="跟单员" prop="name">
          <el-input placeholder="跟单员姓名" v-model="queryFormData.name"></el-input>
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
<!--      </el-col>-->
    </el-row>
    <el-row>
      <span class="status_name_label">状态：</span>
      <el-radio-group v-model="queryFormData.status" @change="onAdvancedSearch">
        <template v-for="(status, index) in statuses">
          <el-radio :label="status.code">{{status.name}}</el-radio>
        </template>
      </el-radio-group>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'ProgressOrderToolbar',
    props: [],
    computed: {

    },
    methods: {
      onAdvancedSearch () {
        this.emit('onAdvancedSearch');
      },
      onReset () {
        this.queryFormData = {
          keyword: '',
          name: '',
          creationTimeFrom: '',
          creationTimeTo: '',
          status: ''
        };
      }
    },
    data () {
      return {
        dateArr: '',
        statuses: [
          {
            code: '',
            name: '全部'
          },
          {
            code: 'UNDELAY',
            name: '未延期'
          },
          {
            code: 'ISDELAY',
            name: '已延期'
          }
        ],
        queryFormData: {
          keyword: '',
          name: '',
          creationTimeFrom: '',
          creationTimeTo: '',
          status: ''
        }
      }
    },
    watch: {
      dateArr: function (newVal, oldVal) {
        this.queryFormData.creationTimeFrom = newVal.start;
        this.queryFormData.creationTimeTo = newVal.end;
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
