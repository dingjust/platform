<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>对账单详情</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :inline="true">
        <el-row type="flex" style="padding-left: 10px">
          <el-col :span="24">
            <reconciliation-orders-form-head :formData="formData" :readOnly="true"/>
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-left: 10px">
          <el-col :span="24">
            <reconciliation-shipping-orders-list :formData="formData" :readOnly="true"/>
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-left: 10px;margin-top: 20px">
          <el-col :span="24">
            <reconciliation-orders-form-foot :formData="formData" :readOnly="true"/>
          </el-col>
        </el-row>
        <el-row type="flex" justify="end" style="padding-left: 10px;margin-top: 20px">
          <el-col :span="6">
            <h5>应付金额：{{payable}}元</h5>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" style="margin-top: 20px" v-if="isCreator">
          <el-col :span="4">
            <el-button class="create-btn" @click="onReturn">返回</el-button>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" style="margin-top: 20px" v-else>
          <el-col :span="4">
            <el-button class="create-btn" @click="onCheck">核验</el-button>
          </el-col>
          <el-col :span="4">
            <el-button class="create-btn" @click="onApply">申请复议</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import ReconciliationOrdersFormHead from '../form/ReconciliationOrdersFormHead'
  import ReconciliationOrdersFormFoot from '../form/ReconciliationOrdersFormFoot'
  import ReconciliationShippingOrdersList from '../list/ReconciliationShippingOrdersList'
  export default {
    name: 'ReconciliationOrdersDetail',
    props: ['id'],
    components: {
      ReconciliationOrdersFormHead,
      ReconciliationOrdersFormFoot,
      ReconciliationShippingOrdersList
    },
    computed: {
      isCreator: function () {
        // TODO 判断是否为创建人
        return true;
      },
      payable: function () {
        let money = 0;
        this.formData.testData.forEach(item => {
          money += parseInt(item.totalPrice);
        })
        this.formData.chargedDetail.forEach(item => {
          if (item.price != '') {
            money -= parseInt(item.price);
          }
        })
        this.formData.increaseDetail.forEach(item => {
          if (item.price != '') {
            money += parseInt(item.price);
          }
        })
        return money;
      }
    },
    methods: {
      onCreate () {
        this.$router.go(-1);
      },
      onReturn () {
        this.$router.go(-1);
      },
      onCheck () {

      },
      onApply () {

      }
    },
    data () {
      return {
        formData: {
          orderCode: 'KY001010101',
          product: {
            name: '红烧猪蹄',
            skuID: '9527',
          },
          price: 88,
          quantity: 100000,
          machiningTypes: 'LABOR_AND_MATERIAL',
          expectedDeliveryDate: 1591847127000,
          testData: [{
            code: 'KY000001011',
            price: 88,
            quantity: 100000,
            expectedDeliveryDate: 1591847127000,
            expectedQuantity: 100000,
            totalPrice: 8800000
          }, {
            code: 'KY000001011',
            price: 88,
            quantity: 100000,
            expectedDeliveryDate: 1591847127000,
            expectedQuantity: 100000,
            totalPrice: 8800000
          }],
          chargedDetail: [{
            price: '',
            remarks: ''
          }],
          increaseDetail: [{
            price: '',
            remarks: ''
          }]  
        }
      }
    },
    created () {

    }
  }
</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
    border-radius: 10px;
  }
</style>