<template>
  <div class="animated fadeIn">
    <el-row class="info-basic-row" type="flex" :gutter="20" v-if="slotData!=null">
      <el-col :span="14">
        <el-row type="flex" :gutter="20">
          <el-col :span="6">
            <!-- 商品图片 -->
            <div>
              <img class="purchase-product-img"
                :src="slotData!=null?slotData.product.thumbnail.url:'static/img/nopicture.png'">
            </div>
          </el-col>
          <el-col :span="18">
            <!-- 商品详情 -->
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>产品名称：{{slotData.product.name}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>商品货号：{{slotData.product.skuID}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>
                  品&#12288;&#12288;类：{{slotData.product.category!=null?slotData.product.category.name:''}}
                </h6>
              </el-col>
              <el-col :span="12">
                <h6>交货货期：{{slotData.deliveryDate | timestampToTime}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>销售价格：{{slotData.unitPrice}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>合作方式：{{getEnum('machiningTypes', belongOrder.cooperationMode)}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>生产数量：{{slotData.quantity}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>订单来源：{{getEnum('SalesProductionOrderType', belongOrder.type)}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col>
                <h6>关联订单：{{belongOrder.code}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col>
                <h6>
                  收货地址：{{slotData.shippingAddress!=null?slotData.shippingAddress.details:''}}
                </h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <color-size-table :data="slotData.colorSizeEntries" :readOnly="true" />
      </el-col>
      <el-col :span="1">
        <el-divider direction="vertical"></el-divider>
      </el-col>
      <el-col :span="9">
        <!-- 合作商信息 -->
        <el-row type="flex">
          <el-col :span="6">
            <div class="info-row-title">
              <h6>合作商信息</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="info-row-title_row">
          <el-col>
            <h6>客户：{{cooperator.name}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-row-title_row">
          <el-col :span="12">
            <h6>联系人：{{cooperator.contactPerson}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{cooperator.contactPhone}}</h6>
          </el-col>
        </el-row>
        <!-- <el-row class="info-row-title_row">
          <el-col>
            <h6>工厂：</h6>
          </el-col>
        </el-row>
        <el-row class="info-row-title_row">
          <el-col :span="12">
            <h6>联系人：{{product.partner.factory.contactsPerson}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{product.partner.factory.contactsPhone}}</h6>
          </el-col>
        </el-row> -->
        <el-row type="flex">
          <el-col :span="6">
            <div class="info-row-title">
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="info-row-title_row">
          <el-col :span="12">
            <h6>生产负责人：{{belongOrder.productionLeader!=null?belongOrder.productionLeader.name:''}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>审批人：{{belongOrder.approvers!=null&&belongOrder.approvers[0]!=null?belongOrder.approvers[0].name:''}}
            </h6>
          </el-col>
        </el-row>
        <!-- <el-row type="flex">
          <el-col :span="6">
            <div class="info-row-title">
              <h6>合同</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="info-row-title_row" type="flex">
          <el-col>
            <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData"
              :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers" :on-exceed="handleExceed"
              :file-list="fileList" :on-preview="handlePreview" multiple :limit="1" :on-remove="handleRemove">
              <div slot="tip" class="el-upload__tip">只能上传PDF文件</div>
              <i class="el-icon-plus"></i>
              <div slot="file" slot-scope="{file}">
                <img class="el-upload-list__item-thumbnail" src="static/img/pdf.png" alt="">
                <span class="el-upload-list__item-actions">
                  <span v-if="!disabled" class="el-upload-list__item-delete" @click="handleRemove(file)">
                    <i class="el-icon-delete"></i>
                  </span>
                  <span v-if="!disabled" class="el-upload-list__item-file-name">
                    {{file.name}}
                  </span>
                </span>
              </div>
            </el-upload>
          </el-col>
        </el-row> -->
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    ColorSizeTable
  } from '@/components/index'

  export default {
    name: 'SalesPlanEntryDetail',
    props: ['slotData', 'belongOrder'],
    components: {
      ColorSizeTable,
    },
    computed: {
      // cooperatorName: function () {
      //   if (this.belongOrder.cooperator != null) {
      //     if (this.belongOrder.cooperator.type == 'ONLINE') {
      //       return this.belongOrder.cooperator.partner.name;
      //     } else {
      //       return this.belongOrder.cooperator.name;
      //     }
      //   } else if (this.belongOrder.originCooperator != null) {
      //     if (this.belongOrder.originCooperator.type == 'ONLINE') {
      //       return this.belongOrder.originCooperator.partner.name;
      //     } else {
      //       return this.belongOrder.originCooperator.name;
      //     }
      //   }
      // },
      // contactPerson: function () {
      //   if (this.belongOrder.cooperator != null) {
      //     if (this.belongOrder.cooperator.type == 'ONLINE') {
      //       return this.belongOrder.cooperator.partner.contactPerson;
      //     } else {
      //       return this.belongOrder.cooperator.contactPerson;
      //     }
      //   } else if (this.belongOrder.originCooperator != null) {
      //     if (this.belongOrder.originCooperator.type == 'ONLINE') {
      //       return this.belongOrder.originCooperator.partner.contactPerson;
      //     } else {
      //       return this.belongOrder.originCooperator.contactPerson;
      //     }
      //   }
      // },
      // contactPhone: function () {
      //   if (this.belongOrder.cooperator != null) {
      //     if (this.belongOrder.cooperator.type == 'ONLINE') {
      //       return this.belongOrder.cooperator.partner.contactPhone;
      //     } else {
      //       return this.belongOrder.cooperator.contactPhone;
      //     }
      //   } else if (this.belongOrder.originCooperator != null) {
      //     if (this.belongOrder.originCooperator.type == 'ONLINE') {
      //       return this.belongOrder.originCooperator.partner.contactPhone;
      //     } else {
      //       return this.belongOrder.originCooperator.contactPhone;
      //     }
      //   }
      // },
      cooperator: function () {
        if (this.belongOrder.targetCooperator) {
          if (this.belongOrder.targetCooperator.type == 'ONLINE') {
            return this.belongOrder.targetCooperator.partner;
          } else {
            return this.belongOrder.targetCooperator;
          }
        }
        return {
          name: '',
          contactPerson: '',
          contactPhone: ''
        }
      }
    },
    methods: {

    },
    data() {
      return {
        fileList: [],
        disabled: false,
        showTable: false,
      }
    },
    created() {

    }
  }

</script>

<style scoped>
  .purchase-product-img {
    width: 100%;
    border-radius: 10px;
    margin-right: 20px;
  }

  .info-basic-row {
    margin-top: 10px;
  }

  .info-row-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    margin-top: 10px;
  }

  .info-row-title_row {
    padding-left: 10px;
    margin-top: 10px;
  }

  .el-divider--vertical {
    height: 100%;
  }

  /deep/ .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  /deep/ .el-table--enable-row-hover .el-table__body tr:hover>td {
    background-color: #FFFFFF !important;
  }

  .icon_arrow {
    font-family: "iconfont" !important;
    font-size: 12px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-style: normal;
    -webkit-font-smoothing: antialiased;
    -webkit-text-stroke-width: 0.2px;
    -moz-osx-font-smoothing: grayscale;
    cursor: pointer;
  }

  .info-basic-row h6 {
    font-size: 10px;
  }

</style>
