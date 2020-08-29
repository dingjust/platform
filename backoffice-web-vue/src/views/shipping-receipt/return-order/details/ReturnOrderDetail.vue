<!-- 
 * @description: 退货单详情
 * @fileName: ReturnOrderDetail.vue 
 * @author: yj 
 * @date: 2020-07-04 17:13:02
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn return-order-container">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>退货单详情</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>单号：{{formData.code}}</h6>
        </el-col>
        <el-col :span="4">
          <h6>创建时间：{{formData.creationtime | timestampToTime}}</h6>
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
              <h6 class="basic-label">退货方：{{formData.receiveParty!=null?formData.receiveParty.name:''}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">收货方：{{formData.shipParty!=null?formData.shipParty.name:''}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6 class="basic-label">货号：{{formData.product.skuID}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">退货人：{{formData.creator?formData.creator.name:''}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">联系方式：{{formData.creator?formData.creator.contactPhone:''}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="12">
              <h6 class="basic-label">收货地址：{{formData.deliveryAddress!=null?formData.deliveryAddress.details:''}}</h6>
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
            <el-col :span="8">
              <h6 class="basic-label">送货人：{{formData.offlineConsignorName}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">联系方式：{{formData.offlineConsignorPhone}}</h6>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row" v-if="formData.packageSheets!=null">
        <el-col :span="24">
          <color-size-table :data="formData.packageSheets[0].colorSizeEntries" :readOnly="true" />
        </el-col>
      </el-row>
      <el-row type="flex" :gutter="20" style="margin-top:20px">
        <el-col :span="24">
          <!-- <el-input type="textarea"  v-model="formData.remarks" :rows="5" :disabled="true">
          </el-input> -->
          <h6>退货原因：{{formData.remarks?formData.remarks:''}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" style="margin-top:20px">
        <template v-for="(media,index) in formData.medias">
          <el-image :key="'img'+index" class="image-item" :src="media.url" :preview-src-list="mediasUrlList">
          </el-image>
        </template>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="8" :offset="2">
          发货单：<el-button type="text" @click="onShipDetail" v-if="formData.logisticsSheet">
            {{formData.logisticsSheet.code}}</el-button>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
        <!-- 待退货收货 -->
        <template v-if="formData.state=='RETURN_TO_BE_RECEIVED'&&isShipOperator">
          <authorized :permission="['RETURN_SHEET_CONFIRM']">
            <el-button class="sumbit-btn" @click="onConfirm">确认收货</el-button>
          </authorized>
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
    name: 'ReturnOrderDetail',
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
      //是收货方
      isReceiveParty: function () {
        if (this.formData.receiveParty != null && this.currentUser != null) {
          return this.currentUser.companyCode == this.formData.receiveParty.uid;
        } else {
          return false;
        }
      },
      //是发货方跟单员
      isShipOperator: function () {
        if (this.formData.merchandiser) {
          return this.formData.merchandiser.uid == this.currentUser.uid;
        }
        return false;
      },
      //图片url list
      mediasUrlList: function () {
        return this.formData.medias.map(media => media.url);
      }
    },
    methods: {
      onShipDetail() {
        this.$router.push('/shipping/orders/' + this.formData.logisticsSheet.id);
      },
      async getDetail() {
        // 获取收货单详情
        const url = this.apis().returnOrderDetail(this.id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this, 'formData', Object.assign({}, result.data));
      },
      //确认收货
      onConfirm() {
        this.$confirm('是否确认收货?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onConfirm();
        }).catch(() => {

        });
      },
      async _onConfirm() {
        const url = this.apis().confirmReturnOrder(this.id);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.getDetail();
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
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
          medias: []
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

  .return-order-container h6 {
    font-size: 14px;
    color: #606266;
  }

  .return-order-container {
    padding-bottom: 10px;
  }

  .image-item {
    margin-right: 10px;
    width: 100px;
    height: 100px;
  }

</style>
