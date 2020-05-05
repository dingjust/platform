<template>
  <el-row type="flex" :gutter="50">
    <el-col :span="13">
      <el-row>
        <span class="status_name_label">状态：</span>
        <el-radio-group v-model="queryFormData.status">
          <el-radio :label="''">全部</el-radio>
          <template v-for="(status, index) in salesProductionStatuses">
            <el-radio :label="status.code">{{status.name}}</el-radio>
          </template>
        </el-radio-group>
      </el-row>
    </el-col>
    <el-col :span="11">
      <el-row>
        <span class="status_name_label">标签：</span>
        <el-radio-group v-model="queryFormData.hasContact">
          <template v-for="(status, index) in contractStates">
            <el-radio :label="status.code">{{status.name}}</el-radio>
          </template>
        </el-radio-group>
        <el-divider direction="vertical"></el-divider>
        <el-radio-group v-model="queryFormData.isArrears">
          <template v-for="(status, index) in arrearsStatuses">
            <el-radio :label="status.code">{{status.name}}</el-radio>
          </template>
        </el-radio-group>
        <el-divider direction="vertical"></el-divider>
        <el-radio-group v-model="queryFormData.isDelay">
          <template v-for="(status, index) in delayStatuses">
            <el-radio :label="status.code">{{status.name}}</el-radio>
          </template>
        </el-radio-group>
      </el-row>
    </el-col>
  </el-row>
</template>

<script>
  export default {
    name: 'SalesProductionStatusBar',
    props: ['queryFormData'],
    data () {
      return {
        salesProductionStatuses: this.$store.state.EnumsModule.SalesProductionStatuses,
        contractStates: [
          {
            code: 'INITIATE',
            name: '未签合同'
          },
          {
            code: 'COMPLETE',
            name: '已签合同'
          }
        ],
        arrearsStatuses: [
          {
            code: 'INITIATE',
            name: '未欠款'
          },
          {
            code: 'COMPLETE',
            name: '已欠款'
          }
        ],
        delayStatuses: [
          {
            code: 'INITIATE',
            name: '未延期'
          },
          {
            code: 'COMPLETE',
            name: '已延期'
          }
        ]
      }
    }
  }
</script>

<style scoped>
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
</style>
