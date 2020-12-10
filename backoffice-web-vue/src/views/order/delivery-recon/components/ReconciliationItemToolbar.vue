<template>
  <el-form :inline="true" class="delivery-recon-toolbar" label-width="70px">
    <div>
      <el-form-item label="订单信息">
        <el-input placeholder="请输入产品名称、款号，订单款号" v-model="queryFormData.keyword" style="width: 250px"></el-input>
      </el-form-item>
    </div>
    <div class="form-btn">
      <el-button type="text" size="medium" v-popover:popover>展开更多</el-button>
      <el-popover ref="popover" placement="bottom" width="360" trigger="click">
        <el-form :inline="true" class="delivery-recon-toolbar" label-width="70px">
          <el-form-item label="合作商" style="margin-bottom: 10px">
            <el-input placeholder="请输入合作商名称" v-model="queryFormData.cooperatorName" style="width: 250px"></el-input>
          </el-form-item>
          <el-form-item label="交货时间" style="margin-bottom: 10px">
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
          <el-form-item label="合同时间">
            <el-date-picker
              v-model="dateArr1"
              value-format="timestamp"
              type="daterange"
              style="width: 250px"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期">
            </el-date-picker>
          </el-form-item>
        </el-form>
      </el-popover>
      <el-button-group>
        <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
        <el-button native-type="reset" @click="onReset">重置</el-button>
      </el-button-group>
    </div>
  </el-form>
</template>

<script>
export default {
  name: 'ReconciliationItemToolbar',
  props: ['queryFormData'],
  data () {
    return {
      dateArr: '',
      dateArr1: ''
    }
  },
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch', 0, 10);
    },
    onReset () {
      this.queryFormData.keyword = '';
      this.queryFormData.cooperatorName = '';
      this.dateArr = null;
      this.dateArr1 = null;
    }
  },
  watch: {
    dateArr: function (newVal, oldVal) {
      if (newVal == null) {
        this.queryFormData.deliveryDateFrom = null;
        this.queryFormData.deliveryDateTo = null;
      } else {
        this.queryFormData.deliveryDateFrom = newVal[0];
        this.queryFormData.deliveryDateTo = newVal[1];
      }
    },
    dateArr1: function (newVal, oldVal) {
      if (newVal == null) {
        this.queryFormData.contractDateFrom = null;
        this.queryFormData.contractDateTo = null;
      } else {
        this.queryFormData.contractDateFrom = newVal[0];
        this.queryFormData.contractDateTo = newVal[1];
      }
    },
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

  .delivery-recon-toolbar >>> .el-form-item__label {
    margin: 0px;
  }

  .delivery-recon-toolbar {
    display: flex; 
    flex-wrap: wrap;
    align-items: center;
  }

  .form-btn {
    min-width: 165px;
    display: flex;
    align-items: center;
  }
</style>