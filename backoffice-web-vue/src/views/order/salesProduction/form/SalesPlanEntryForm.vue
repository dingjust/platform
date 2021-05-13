<template>
  <div class="animated fadeIn">
    <el-form :model="slotData" ref="form" label-position="left" :inline="true">
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
                  <h6>商品货号：{{slotData.product.code}}</h6>
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
            </el-col>
          </el-row>
          <color-size-table :data="slotData.colorSizeEntries" />
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
              <h6>客户：{{cooperatorName}}</h6>
            </el-col>
          </el-row>
          <el-row class="info-row-title_row">
            <el-col :span="12">
              <h6>联系人：{{contactPerson}}</h6>
            </el-col>
            <el-col :span="12">
              <h6>联系方式：{{contactPhone}}</h6>
            </el-col>
          </el-row>
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
        </el-col>
      </el-row>
      <div class="price-row">
        <div class="price-row">
          <el-row type="flex" align="middle">
            <el-form-item prop="totalPrimeCost" label="订单报价"
              :rules="{required: true, message: '不能为空', trigger: 'blur'}">
              <el-input placeholder="订单报价" v-model="slotData.totalPrimeCost" :disabled="fromOrigin"
                v-number-input.float="{ min: 0 ,decimal:2}" size="mini">
                <span slot="suffix">元</span>
              </el-input>
            </el-form-item>
          </el-row>
          <h6 style="margin:0;padding:8px 0 0 10px;width:130px">报价单价：{{(getPrice(slotData))}}</h6>
        </div>
        <el-form-item prop="deliveryDate" label="交货日期"
          :rules="{required: true, message: '不能为空', trigger: 'blur'}">
          <el-date-picker v-model="slotData.deliveryDate" type="date" placeholder="选择日期" :disabled="fromOrigin">
          </el-date-picker>
        </el-form-item>
      </div>
      <!-- <el-row type="flex" :gutter="10" style="margin-top:20px">
        <el-col :span="8">
          <el-row type="flex" align="middle">
            <el-form-item prop="unitPrice" label="订单报价" label-width="100px"
              :rules="{required: true, message: '不能为空', trigger: 'blur'}">
              <el-input placeholder="订单报价" v-model="slotData.unitPrice" :disabled="fromOrigin"
                v-number-input.float="{ min: 0 ,decimal:2}" size="mini">
              </el-input>
            </el-form-item>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" align="middle">
            <el-form-item prop="deliveryDate" label="交货日期" label-width="100px"
              :rules="{required: true, message: '不能为空', trigger: 'blur'}">
              <el-date-picker v-model="slotData.deliveryDate" type="date" placeholder="选择日期" :disabled="fromOrigin">
              </el-date-picker>
            </el-form-item>
          </el-row>
        </el-col>
      </el-row> -->
      <el-row type="flex">
        <el-col :span="24">
          <my-address-form :vAddress.sync="slotData.shippingAddress" ref="addressComp" :readOnly="fromOrigin" />
        </el-col>
      </el-row>
      <el-row style="margin-top: 20px" type="flex" justify="center" align="middle" :gutter="50">
        <el-col :span="5">
          <el-button class="material-btn" @click="onSave">保存</el-button>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import {
    ColorSizeTable
  } from '@/components/index';
  import MyAddressForm from '@/components/custom/order-form/MyAddressForm';

  export default {
    name: 'SalesPlanEntryForm',
    // props: ['slotData', 'belongOrder'],
    props: {
      slotData: {
        type: Object
      },
      belongOrder: {
        type: Object
      },
      //是否来源外发，是则禁止修改产品
      fromOrigin: {
        type: Boolean,
        default: false
      },
      productionLeader: {
        // type: Object
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    components: {
      ColorSizeTable,
      MyAddressForm
    },
    computed: {
      cooperatorName: function () {
        if (this.belongOrder.cooperator != null) {
          if (this.belongOrder.cooperator.type == 'ONLINE') {
            return this.belongOrder.cooperator.partner.name;
          } else {
            return this.belongOrder.cooperator.name;
          }
        }
      },
      contactPerson: function () {
        if (this.belongOrder.cooperator != null) {
          if (this.belongOrder.cooperator.type == 'ONLINE') {
            return this.belongOrder.cooperator.partner.contactPerson;
          } else {
            return this.belongOrder.cooperator.contactPerson;
          }
        }
      },
      contactPhone: function () {
        if (this.belongOrder.cooperator != null) {
          if (this.belongOrder.cooperator.type == 'ONLINE') {
            return this.belongOrder.cooperator.partner.contactPhone;
          } else {
            return this.belongOrder.cooperator.contactPhone;
          }
        }
      },
    },
    methods: {
      getPrice (row) {
        let quantity = 0;
        row.colorSizeEntries.forEach(item => quantity += (item.quantity ? Number.parseInt(item.quantity) : 0));

        let price = 0;
        if (!Number.isNaN(Number.parseFloat(row.totalPrimeCost))) {
          price = Number.parseFloat(row.totalPrimeCost) / (quantity === 0 ? 1 : quantity);
        }
        return price.toFixed(2);
      },
      onSave() {
        this.$emit('onSave', this.slotData);
      }
    },
    data() {
      return {
        mediaUploadUrl: '/b2b/media/file/upload',
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

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }

  .price-row {
    display: flex;
    flex-wrap: wrap;
    justify-content: start;
  }

</style>
