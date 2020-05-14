<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="sales-plan-form-title">
            <h6>生产任务明细</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>任务单号:&#12288;{{code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>订单状态:&#12288;{{form.status}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <receiving-details-form/>
      <el-form>
        <production-task-invoice-form :title="title"/>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import ReceivingDetailsForm from '../form/ReceivingDetailsForm';
  import InvoiceDetailsForm from '../form/InvoiceDetailsForm';
  import ProductionTaskProductForm from '../form/ProductionTaskProductForm';
  import ProductionTaskInvoiceForm from '../form/ProductionTaskInvoiceForm';
  export default {
    name: 'ProductionTaskDetails',
    props: ['code'],
    components: {ProductionTaskInvoiceForm, ProductionTaskProductForm, InvoiceDetailsForm, ReceivingDetailsForm},
    methods: {
      onConfirm () {

      },
      onCreate () {

      }
    },
    data () {
      return {
        title: '生产需求',
        form: {
          id: 'WX1020399853247895712',
          status: '未审核'
        },
        product: {
          name: '全棉磨毛斜布',
          code: 'CO00000001',
          category: 'polo衫',
          date: '2019-2-19',
          price: 120000000.00,
          machiningType: 'LABOR_AND_MATERIAL',
          quantity: 100000,
          orderForm: '订单来源',
          relationOrder: 'CO00000001',
          address: '广东省广州市海珠区云顶同创汇二期707'
        },
        options: [{
          value: '选项1',
          label: '黄金糕'
        }, {
          value: '选项2',
          label: '双皮奶'
        }, {
          value: '选项3',
          label: '蚵仔煎'
        }, {
          value: '选项4',
          label: '龙须面'
        }, {
          value: '选项5',
          label: '北京烤鸭'
        }],
        value: ''
      }
    }
  }
</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-product-img {
    width: 120px;
    height: 120px;
    border-radius: 10px;
    margin-right: 20px;
  }

  .info-basic-row {
    margin-top: 10px;
  }












  .border-container{
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    padding-top:10px;
  }

  .production-task-btn {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    height: 40px;
    color: #606266;
  }
</style>
