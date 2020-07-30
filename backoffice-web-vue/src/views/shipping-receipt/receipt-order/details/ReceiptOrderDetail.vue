<!-- 
 * @description: 收货单详情
 * @fileName: ReceiptOrderDetail.vue 
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
        <el-col :span="6">
          <h6>单号：{{formData.code}}</h6>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>状态：{{getEnum('ShippingSheetState', formData.state)}}</h6>
          </div>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="3">
          <img width="100px" height="100px"
            :src="formData.product.thumbnail!=null&&formData.product.thumbnail.length!=0?formData.product.thumbnail.url:'static/img/nopicture.png'">
        </el-col>
        <el-col :span="21">
          <el-row type="flex" style="padding: 10px 0px">
            <el-col :span="8">
              <h6 class="basic-label">产品名称：{{formData.product.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">发货方：{{formData.shipParty!=null?formData.shipParty.name:''}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">收货方：{{formData.receiveParty!=null?formData.receiveParty.name:''}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6 class="basic-label">货号：{{formData.product.skuID}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">发货负责人：{{formData.merchandiser.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">联系方式：{{formData.merchandiser.contactPhone?formData.merchandiser.contactPhone:''}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="12">
              <h6 class="basic-label">收货地址：{{formData.deliveryAddress.details}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px"
            v-if="!formData.isOfflineConsignment&&formData.consignment!=null">
            <el-col :span="8">
              <h6 class="basic-label">发货方式：{{formData.consignment.carrierDetails.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">发货单号：{{formData.consignment.trackingID}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px" v-else>
            <el-col :span="8">
              <h6 class="basic-label">物流方式：{{formData.offlineConsignorMode}}</h6>
            </el-col>
            <!-- <el-col :span="8">
              <h6 class="basic-label">送货人：{{formData.offlineConsignorName}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">联系方式：{{formData.offlineConsignorPhone}}</h6>
            </el-col> -->
          </el-row>
        </el-col>
      </el-row>
      <!-- <el-row type="flex" style="margin-top:20px">
        <el-col :span="4" :offset="4">
          <el-radio v-model="receivingMode" label="BY_PACKAGE">按箱号</el-radio>
          <el-radio v-model="receivingMode" label="BY_LIST">按总列表</el-radio>
        </el-col>
      </el-row> -->
      <el-row type="flex" justify="start" class="basic-row" v-if="formData.receivingMode=='BY_PACKAGE'">
        <el-col :span="24">
          <color-size-box-table :vdata="formData.packageSheets"
            :colorSizeEntries="formData.packageSheets[0].colorSizeEntries" :readOnly="true" />
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row" v-if="formData.receivingMode=='BY_LIST'">
        <el-col :span="24">
          <color-size-table :data="formData.packageSheets[0].colorSizeEntries" :readOnly="true" />
        </el-col>
      </el-row>
      <el-row type="flex" style="margin-top:20px">
        <el-col :span="8" :offset="4">
          <el-row type="flex">
            <h6>有无退货：</h6>
            <el-radio v-model="formData.isHaveReturn" :label="true" :disabled="true">有退货</el-radio>
            <el-radio v-model="formData.isHaveReturn" :label="false" :disabled="true">无退货</el-radio>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="8" :offset="2">
          <el-row type="flex">
            <h6>发货单：<el-button type="text" @click="onShipDetail">
                {{formData.logisticsSheet?formData.logisticsSheet.code:''}}
              </el-button>
            </h6>
          </el-row>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="shippingDetailVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <shipping-orders-detail :id="formData.logisticsSheet.id" v-if="shippingDetailVisible" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable,
    ColorSizeTable
  } from '@/components/'

  import ShippingOrdersDetail from '../../shipping-order/details/ShippingOrdersDetail'

  export default {
    name: 'ReceiptOrderDetail',
    props: {
      //收货单id
      id: {
        require: true
      }
    },
    components: {
      ColorSizeBoxTable,
      ColorSizeTable,
      ShippingOrdersDetail
    },
    computed: {
      //是收货方
      isReceiveParty: function () {
        if (this.formData.receiveParty != null && this.currentUser != null) {
          return this.currentUser.companyCode == this.formData.receiveParty.uid;
        } else {
          return false;
        }
      },
    },
    methods: {
      async getDetail() {
        // 获取收货单详情
        const url = this.apis().receiptOrderDetail(this.id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = Object.assign({}, result.data);
      },
      //发货单详情
      onShipDetail() {
        this.shippingDetailVisible = true;
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        shippingDetailVisible: false,
        formData: {
          product: {
            name: '',
            skuID: '',
          },
          shipParty: {
            name: '',
          },
          receiveParty: {
            name: ''
          },
          merchandiser: {
            name: ''
          },
          deliveryAddress: {
            details: ''
          },
        }
      }
    },
    created() {
      this.getDetail();
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

  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 125px;
    height: 32px;
  }

  .receipt-order-container h6 {
    font-size: 14px;
    color: #606266;
  }

  .receipt-order-container {
    padding-bottom: 10px;
  }

</style>
