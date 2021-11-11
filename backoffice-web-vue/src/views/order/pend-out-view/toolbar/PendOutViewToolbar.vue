<template>
  <div class="pend-out-view-toolbar">
    <el-form :inline="true">
      <el-form-item label="订单信息" prop="name">
        <el-input placeholder="请输入订单号，订单名称" v-model="queryFormData.keyword"></el-input>
      </el-form-item>
      <el-form-item label="合作商" prop="name">
        <el-input placeholder="请输入合作商名称" v-model="queryFormData.cooperator"></el-input>
      </el-form-item>
      <el-form-item label="渠道码" prop="name">
        <el-input placeholder="请输入合作商名称" v-model="queryFormData.channelCode"></el-input>
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          v-model="datePicker"
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
    </el-form>
    <div>
      <el-button type="primary" @click="onExport">导出</el-button>
      <el-button type="primary" @click="onExportByBill">导出流水</el-button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PendOutViewToolbar',
  props: ['queryFormData'],
  methods: {
    onAdvancedSearch() {
      this.$emit('onAdvancedSearch', 0);
    },
    onReset() {
      this.queryFormData.keyword = '';
      this.queryFormData.cooperator = '';
      this.queryFormData.channelCode = '';
      this.datePicker = null
    },
    onExport () {
      this.$emit('onExport')
    },
    onExportByBill () {
      this.$emit('onExportByBill')
    }
  },
  data () {
    return {
      datePicker: null
    }
  },
  watch: {
    datePicker: function (nval, oval) {
      if (nval) {
        this.queryFormData.createdDateFrom = nval[0]
        this.queryFormData.createdDateTo = nval[1]
      } else {
        this.queryFormData.createdDateFrom = null
        this.queryFormData.createdDateTo = null
      }
    }
  }
}
</script>

<style scoped>
  .pend-out-view-toolbar {
    display: flex;
    justify-content: space-between;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .pend-out-view-toolbar >>> .el-form-item {
    margin-bottom: 5px;
  }

  .pend-out-view-toolbar >>> .el-dialog__body {
    padding: 10px 20px!important;
  }
</style>
