<template>
  <div class="payment-order-toolbar">
    <el-form :inline="true">
      <el-form-item label="订单信息" prop="name">
        <el-input placeholder="请输入订单号" v-model="queryFormData.keyword"></el-input>
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          v-model="datePicker"
          value-format="yyyy-MM-dd"
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
    <div style="min-width: 150px">
      <el-button type="primary" @click="onExport">导出支付单</el-button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PaymentToolbar',
  props: ['queryFormData'],
  methods: {
    onAdvancedSearch() {
      this.$emit('onAdvancedSearch', 0);
    },
    onReset() {
      this.queryFormData.keyword = '';
      this.datePicker = null
    },
    onExport () {
      this.$emit('onExport')
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
        this.queryFormData.creationtimeFrom = nval[0]
        this.queryFormData.creationtimeTo = nval[1]
      } else {
        this.queryFormData.creationtimeFrom = ''
        this.queryFormData.creationtimeTo = ''
      }
    }
  }
}
</script>

<style scoped>
  .payment-order-toolbar {
    display: flex;
    justify-content: space-between;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .payment-order-toolbar >>> .el-form-item {
    margin-bottom: 5px;
  }

  .payment-order-toolbar >>> .el-dialog__body {
    padding: 10px 20px!important;
  }
</style>
