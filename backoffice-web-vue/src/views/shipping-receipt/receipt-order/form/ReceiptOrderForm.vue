<!-- 
 * @description: 收货单表单
 * @fileName: ReceiptOrderForm.vue 
 * @author: yj 
 * @date: 2020-06-22 13:58:22
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>收货单详情</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>状态：待核验</h6>
          </div>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="3">
          <!-- <img width="54px" height="54px"
              :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'"> -->
          <img width="100px" height="100px" :src="'static/img/nopicture.png'">
        </el-col>
        <el-col :span="21">
          <el-row type="flex" style="padding: 10px 0px">
            <el-col :span="8">
              <h6 class="basic-label">产品名称：{{shippingOder.product.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">货号：{{shippingOder.product.skuID}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6 class="basic-label">发货方：{{shippingOder.shipParty.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">收货方：{{shippingOder.receiveParty.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">发货负责人：{{shippingOder.merchandiser.name}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="12">
              <h6 class="basic-label">收货地址：{{shippingOder.deliveryAddress.details}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px"
            v-if="!shippingOder.isOfflineConsignment&&shippingOder.consignment!=null">
            <el-col :span="8">
              <h6 class="basic-label">发货方式：{{shippingOder.consignment.carrierDetails.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">发货单号：{{shippingOder.consignment.trackingID}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px" v-else>
            <el-col :span="8">
              <h6 class="basic-label">物流方式：{{shippingOder.offlineConsignorMode}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">送货人：{{shippingOder.offlineConsignorName}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">联系方式：{{shippingOder.offlineConsignorPhone}}</h6>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" style="margin-top:20px">
        <el-col :span="4" :offset="4">
          <el-radio v-model="receivingMode" label="BY_PACKAGE">按箱号</el-radio>
          <el-radio v-model="receivingMode" label="BY_LIST">按总列表</el-radio>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row" v-if="receivingMode=='BY_PACKAGE'">
        <el-col :span="24">
          <color-size-box-table :vdata="data" :colorSizeEntries="colorSizeEntries" :readOnly="false" />
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row" v-if="receivingMode=='BY_LIST'">
        <el-col :span="24">
          <color-size-table :data="summaryData[0].colorSizeEntries" :readOnly="false" />
        </el-col>
      </el-row>
      <el-row type="flex" style="margin-top:20px">
        <el-col :span="8" :offset="4">
          <el-row type="flex">
            <h6>有无退货：</h6>
            <el-radio v-model="isHaveReturn" :label="true">有退货</el-radio>
            <el-radio v-model="isHaveReturn" :label="false">无退货</el-radio>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="8" :offset="2">
          <h6>发货单：{{shippingOder.code}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
        <template>
          <el-col :span="4">
            <el-button class="material-btn" @click="onSubmit">确认收货</el-button>
          </el-col>
        </template>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable,
    ColorSizeTable
  } from '@/components/'

  export default {
    name: 'ReceiptOrderForm',
    props: {
      //收货单id
      id: {
        require: true
      }
    },
    components: {
      ColorSizeBoxTable,
      ColorSizeTable,
    },
    computed: {
      //箱总数
      boxAmount: function () {
        var amount = 0;
        if (this.data != null) {
          this.data.forEach(sheet => {
            sheet.colorSizeEntries.forEach(entry => {
              let num = parseFloat(entry.quantity);
              if (!Number.isNaN(num)) {
                amount += num;
              }
            })
          });
        }
        return amount;
      },
      //总列表总数
      summaryAmount: function () {
        var amount = 0;
        if (this.summaryData != null) {
          this.summaryData.forEach(sheet => {
            sheet.colorSizeEntries.forEach(entry => {
              let num = parseFloat(entry.quantity);
              if (!Number.isNaN(num)) {
                amount += num;
              }
            })
          });
        }
        return amount;
      },
      //发货单数
      shippingOrderAmount: function () {
        var amount = 0;
        if (this.shippingOder != null) {
          this.shippingOder.packageSheets.forEach(sheet => {
            sheet.colorSizeEntries.forEach(entry => {
              let num = parseFloat(entry.quantity);
              if (!Number.isNaN(num)) {
                amount += num;
              }
            })
          });
        }
        return amount;
      },
    },
    methods: {
      onSubmit() {
        //校验数量与订单差异
        let num = this.receivingMode == 'BY_PACKAGE' ? this.boxAmount : this.summaryAmount;
        if (num != this.shippingOrderAmount) {
          this.$confirm('收货数与发货总数不一致，是否创建收货单？创建后不允许修改', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this._onSubmit();
          }).catch(() => {

          });
        } else {
          this._onSubmit();
        }
      },
      async _onSubmit() {
        const url = this.apis().receiptOrderCreate();

        let submitForm = {
          isHaveReturn: this.isHaveReturn,
          receivingMode: this.receivingMode,
          packageSheets: this.receivingMode == 'BY_PACKAGE' ? this.data : this.summaryData
        };
        const result = await this.$http.post(url, submitForm, {
          id: this.shippingOder.id
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == '0') {
          this.$message.error(result.msg);
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          //有退货则提示创建退货单
          if (this.isHaveReturn) {
            this.onReturnedMessage();
          }
        }
      },
      //提示是否创建退货单
      onReturnedMessage() {
        this.$confirm('是否马上创建退货单？', '提示', {
          confirmButtonText: '马上创建',
          cancelButtonText: '下次再说',
          type: 'info'
        }).then(() => {

        }).catch(() => {

        });
      }
    },
    data() {
      return {
        data: [],
        shippingOder: '',
        summaryData: [],
        colorSizeEntries: [],
        receivingMode: 'BY_PACKAGE',
        isHaveReturn: false
      }
    },
    created() {
      if (this.$route.params.shippingOrder == null) {
        this.$router.go(-1);
      } else {
        //设置colorSizeEntries
        this.$set(this, 'shippingOder', JSON.parse(JSON.stringify(this.$route.params.shippingOrder)));
        this.$set(this, 'colorSizeEntries', JSON.parse(JSON.stringify(this.$route.params.shippingOrder
          .packageSheets[0].colorSizeEntries)));
        this.$set(this, 'data', JSON.parse(JSON.stringify(this.$route.params.shippingOrder.packageSheets)));
        //整理按总汇表单数据
        let summaryData = [];
        this.$route.params.shippingOrder.packageSheets.forEach(sheet => {
          if (summaryData.length == 0) {
            summaryData.push(JSON.parse(JSON.stringify(sheet)));
          } else {
            //整合数据
            for (let i = 0; i < sheet.colorSizeEntries.length; i++) {
              let num = parseInt(sheet.colorSizeEntries[i].quantity);
              if (!Number.isNaN(num)) {
                summaryData[0].colorSizeEntries[i].quantity += num;
              }
            }
          }
        });
        this.$set(this, 'summaryData', summaryData);
      }
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .receipt-order-container h6 {
    font-size: 14px;
    color: #606266;
  }

  .receipt-order-container {
    padding-bottom: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 150px;
    height: 35px;
  }

</style>
