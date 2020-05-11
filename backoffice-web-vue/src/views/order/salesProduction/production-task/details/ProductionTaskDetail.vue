<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-row>
          <el-col :span="13">
            <div class="sales-plan-form-title">
              <h6>生产任务明细</h6>
            </div>
          </el-col>
          <el-col :span="11">
            <el-row>
              <el-col :span="12">
                <h6>任务单号:&#12288;{{form.id}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>对应单号:&#12288;{{form.id}}</h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <div class="pt-2"></div>
        <el-row type="flex" :gutter="20">
          <el-col :span="12">
            <div class="border-container">
              <receiving-details-form/>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="border-container">
              <invoice-details-form/>
            </div>
          </el-col>
        </el-row>
        <el-row type="flex" style="margin-top: 20px">
          <el-col :span="24">
            <production-task-product-form :code="2"/>
          </el-col>
        </el-row>
        <el-divider></el-divider>
        <el-row type="flex">
          <el-col :span="12">
            <el-form-item label="关联销售订单" label-width="150px">
              <el-input></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="对应外发订单" label-width="150px">
              <el-input></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex">
          <el-col :span="12">
            <el-form-item label="分配" label-width="150px">
              <el-select v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-row type="flex" justify="center" :gutter="50">
        <el-col :span="4">
          <el-button class="production-task-btn" @click="onConfirm">接受</el-button>
        </el-col>
        <el-col :span="4">
          <el-button class="production-task-btn" @click="onCreate">创建外发订单</el-button>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import ReceivingDetailsForm from '../form/ReceivingDetailsForm';
  import InvoiceDetailsForm from '../form/InvoiceDetailsForm';
  import ProductionTaskProductForm from '../form/ProductionTaskProductForm';
  export default {
    name: 'ProductionTaskDetails',
    props: ['code'],
    components: {ProductionTaskProductForm, InvoiceDetailsForm, ReceivingDetailsForm},
    methods: {
      onConfirm () {

      },
      onCreate () {

      }
    },
    data () {
      return {
        form: {
          id: 'WX1020399853247895712'
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
