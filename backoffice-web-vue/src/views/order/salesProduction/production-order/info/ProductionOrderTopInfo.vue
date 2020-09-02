<template>
  <div class="animated fadeIn">
    <el-row class="info-basic-row" type="flex" :gutter="20">
      <el-col :span="14">
        <el-row type="flex" :gutter="20">
          <el-col :span="6">
            <!-- 商品图片 -->
            <div>
              <img class="purchase-product-img"
                :src="productionOrder.product.thumbnail!=null?productionOrder.product.thumbnail.url:'static/img/nopicture.png'">
            </div>
          </el-col>
          <el-col :span="18">
            <!-- 商品详情 -->
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>产品名称：{{productionOrder.product.name}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>商品货号：{{productionOrder.product.skuID}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>
                  品&#12288;&#12288;类：{{productionOrder.product.category!=null?productionOrder.product.category.name:''}}
                </h6>
              </el-col>
              <el-col :span="12">
                <h6>交货货期：{{productionOrder.deliveryDate | timestampToTime}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>销售价格：{{productionOrder.unitPrice}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>合作方式：{{getEnum('machiningTypes', slotData.cooperationMode)}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>生产数量：{{productionOrder.quantity}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>订单来源：{{getEnum('SalesProductionOrderType', slotData.type)}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col>
                <h6>关联订单：{{slotData.code}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col>
                <h6>
                  收货地址：{{productionOrder.shippingAddress!=null?productionOrder.shippingAddress.details:''}}
                </h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <!-- 商品color/size表 -->
        <el-row class="info-basic-row" type="flex">
          <el-col>
            <el-row>
              <el-table :data="showTable?dataTable:[dataTable[0]]" border>
                <el-table-column label="颜色" prop="color.name"></el-table-column>
                <template v-for="size in sizes">
                  <el-table-column :key="size.code" :label="size.name" :prop="size.code"></el-table-column>
                </template>
              </el-table>
            </el-row>
            <el-row type="flex" justify="center" align="center" class="info-basic-row">
              <i class="iconfont icon_arrow" v-if="!showTable" @click="onClickShowTable">&#xe714;&nbsp;展开列表</i>
              <i class="iconfont icon_arrow" v-if="showTable" @click="onClickShowTable">&#xe713;&nbsp;收回列表</i>
            </el-row>
          </el-col>
        </el-row>
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
            <!-- <h6>生产负责人：{{slotData.productionLeader!=null?slotData.productionLeader.name:''}}</h6> -->
            <h6>跟单员：{{operator}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>审批人：{{slotData.approvers!=null?slotData.approvers[0].name:''}}</h6>
          </el-col>
        </el-row>
        <!-- 查看单据 -->
        <order-view-button-group :slotData="slotData" />
        <!-- <el-row type="flex">
          <el-col :span="6">
            <div class="info-row-title">
              <h6>合同</h6>
            </div>
          </el-col>
        </el-row> -->
        <el-row style="margin-top: 10px;">
          <el-col :span="24">
            <production-contract :slotData="slotData" :contracts="contracts" :canSign="false" :readOnly="true"/>
            <!-- <contract-com :slotData="slotData" :contracts="slotData.agreements" :canSign="false" /> -->
          </el-col>
        </el-row>
        <!-- <el-row class="info-row-title_row" type="flex">
          <el-col>
            <PDFUpload :vFileList.sync="fileList" />
          </el-col>
        </el-row> -->
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    getSizeSequence
  } from '@/store/modules/shared'

  import PDFUpload from '@/components/custom/upload/PDFUpload';
  import OrderViewButtonGroup from './OrderViewButtonGroup';
  import ContractCom from '@/views/order/salesProduction/contract/ContractCom'
  import ProductionContract from '@/views/order/salesProduction/components/ProductionContract'

  export default {
    name: 'ProductionOrderTopInfo',
    props: ['slotData'],
    components: {
      PDFUpload,
      OrderViewButtonGroup,
      ContractCom,
      ProductionContract
    },
    computed: {
      // 已签合同列表
      contracts: function () {
        if (this.slotData.agreements) {
          return this.slotData.agreements.filter(item => item.state !== 'INVALID');
        }
        return [];
      },
      productionOrder: function () {
        if (this.slotData.taskOrderEntries != null && this.slotData.taskOrderEntries[0]) {
          return this.slotData.taskOrderEntries[0];
        } else {
          return {
            "code": "",
            "invoiceNeeded": "",
            "product": {
              "code": "",
              "name": "",
              "images": [],
              "thumbnail": "",
              "thumbnails": [

              ],
              "details": [],
              "category": "",
              "approvalStatus": "",
            },
            "unitPrice": "",
            "shippingAddress": "",
            "quantity": "",
            "deliveryDate": "",
            "productionProcessContent": "",
            "materialsSpecEntries": [],
            "colorSizeEntries": []
          };
        }
      },
      cooperator: function () {
        //来源自己情况
        if (this.slotData.originCompany != null && this.slotData.originCompany.uid == this.currentUser.companyCode) {
          if (this.slotData.targetCooperator) {
            if (this.slotData.targetCooperator.type == 'ONLINE') {
              return {
                name: this.slotData.targetCooperator.partner.name,
                contactPerson: this.slotData.targetCooperator.contactPerson,
                contactPhone: this.slotData.targetCooperator.contactPhone
              };
            }else{
              return this.slotData.targetCooperator;
            }
          }
        }

        //外接情况
        if (this.slotData.originCooperator != null) {
          if (this.slotData.originCooperator.type == 'ONLINE') {
            return Object.assign({}, this.slotData.originCooperator.partner);
          } else {
            return Object.assign({}, this.slotData.originCooperator);
          }
        } else {
          return {
            name: '',
            contactPerson: '',
            contactPhone: ''
          }
        }
      },
      sizes: function () {
        var sizes = [];
        if (this.productionOrder.colorSizeEntries != null) {
          this.productionOrder.colorSizeEntries.forEach(entry => {
            let index = sizes.findIndex(size => size.code == entry.size.code);
            if (index == -1) {
              sizes.push(entry.size);
            }
          });
        }
        //排序
        sizes.sort((o1, o2) => {
          let o1Sequence = getSizeSequence(o1.code);
          let o2Sequence = getSizeSequence(o2.code);
          if (o1Sequence && o2Sequence) {
            return o1Sequence - o2Sequence;
          } else if (o1Sequence && !o2Sequence) {
            return -1;
          } else if (!o1Sequence && o2Sequence) {
            return 1;
          } else {
            return -1;
          }
        });
        return sizes;
      },
      dataTable: function () {
        var result = [];
        if (this.productionOrder.colorSizeEntries != null) {
          this.productionOrder.colorSizeEntries.forEach(entry => {
            //找到颜色          
            let index = result.findIndex(item => {
              return item.color.code == entry.color.code;
            });
            if (index == -1) {
              var obj = {
                color: entry.color,
              };
              obj[entry.size.code] = entry.quantity;
              result.push(obj);
            } else {
              var obj = result[index];
              obj[entry.size.code] = entry.quantity;
            }
          });
        }
        //颜色为空处理
        result = result.filter(item => {
          let values = Object.values(item);
          if (values) {
            let numberArry = values.filter(val => Number.isInteger(val));
            return !numberArry.every(val => val == 0);
          } else {
            return false;
          }
        });

        return result;
      },
      //跟单员
      operator:function(){
        if(this.slotData.taskOrderEntries&&this.slotData.taskOrderEntries[0].merchandiser){
          return this.slotData.taskOrderEntries[0].merchandiser.name;
        }
        return '';
      }
    },
    methods: {
      // 展开/收起列表行
      onClickShowTable() {
        this.showTable = !this.showTable;
      },

    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        defaultDateValueFormat: 'yyyy-MM-dd"T"HH:mm:ssZ',
        VIEW_MODE_LIST: 'LIST',
        VIEW_MODE_TABS: 'TABS',
        fileList: [],
        disabled: false,
        sizeList: [],
        colorSizeData: [],
        showData: [],
        showTable: false
      }
    },
    watch: {

    },
    created() {}
  }

</script>

<style scoped>
  .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .purchase-product-img {
    width: 100%;
    border-radius: 10px;
    margin-right: 20px;
  }

  .purchase-formData-img {
    width: 120px;
    height: 120px;
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
