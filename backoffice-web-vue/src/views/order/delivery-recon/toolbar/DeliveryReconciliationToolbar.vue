<template>
  <el-row type="flex" justify="space-between">
    <el-form :inline="true" class="delivery-recon-toolbar">
      <div>
        <el-form-item label="订单信息">
          <el-input placeholder="请输入订单号，标题" v-model="queryFormData.keyword"></el-input>
        </el-form-item>
        <el-form-item label="合作商">
          <el-input placeholder="请输入合作商名称" v-model="queryFormData.cooperatorName"></el-input>
        </el-form-item>
        <el-form-item label="创建时间">
          <el-date-picker
            v-model="dateArr"
            value-format="timestamp"
            type="daterange"
            style="width: 250px"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期">
          </el-date-picker>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
          <el-button native-type="reset" @click="onReset">重置</el-button>
        </el-button-group>
      </div>
    </el-form>
    <el-button class="sumbit-btn" @click="onCreate">创建对账单</el-button>
  </el-row>
</template>

<script>
export default {
  name: 'DeliveryReconciliationToolbar',
  props: ['queryFormData'],
  data () {
    return {
      dateArr: ''
    }
  },
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset () {
      this.queryFormData.keyword = '';
      this.queryFormData.cooperatorName = '';
      this.dateArr = null;
    },
    onCreate () {
      this.$router.push('/order/reconciliation/create');
    }
  },
  watch: {
    dateArr: function (newVal, oldVal) {
      if (newVal == null) {
        this.queryFormData.createdDateFrom = null;
        this.queryFormData.createdDateTo = null;
      } else {
        this.queryFormData.createdDateFrom = newVal[0];
        this.queryFormData.createdDateTo = newVal[1];
      }
    }
  },
}
</script>

<style scoped>
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .delivery-recon-toolbar >>> .el-form-item {
     margin-bottom: 0px;
  }

  .delivery-recon-toolbar >>> .el-date-editor .el-range-separator {
    padding: 0px;
    width: 13px;
  }

  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #606266;
    height: 32px;
  }
</style>