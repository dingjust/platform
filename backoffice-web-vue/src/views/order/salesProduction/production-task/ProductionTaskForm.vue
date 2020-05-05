<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-plan-form-title">
            <h6>创建生产任务</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form>
        <el-row type="flex" align="middle" :gutter="20">
          <el-col :span="8">
            <el-form-item label="任务编号" label-width="80px">
              <el-input placeholder="系统自动生成" :disabled="true" size="mini"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="关联订单" label-width="80px">
              <el-input placeholder="系统自动生成" :disabled="true" size="mini"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <production-task-product-form/>
        <el-divider></el-divider>
        <div class="border-container">
          <production-task-receiving-form/>
        </div>
        <production-task-invoice-form/>
        <el-row type="flex" justify="center" style="margin-top: 20px">
          <el-button class="material-btn">创建任务</el-button>
        </el-row>
      </el-form>
    </el-card>
    <el-dialog :visible.sync="productListVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
    </el-dialog>
  </div>
</template>

<script>
  import ProductionTaskReceivingForm from '../form/ProductionTaskReceivingForm';
  import ProductionTaskInvoiceForm from '../form/ProductionTaskInvoiceForm';
  import ProductionTaskProductForm from '../form/ProductionTaskProductForm';
  export default {
    name: 'SalesPlanForm',
    components: {
      ProductionTaskProductForm,
      ProductionTaskInvoiceForm,
      ProductionTaskReceivingForm

    },
    computed: {

    },
    methods: {

    },
    data () {
      return {
        productListVisible: false
      }
    },
    created () {

    },
    mounted () {

    }
  };
</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .info-input-prepend {
    display: inline-block;
    /*margin-top: 5px; */
    width: 100px;
    font-size: 14px;
    font-weight: 500;
    padding-top: 9px;
    padding-left: 10px;
  }

  .border-container{
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    padding-top:10px;
    background-color: #F5F5F5;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>
