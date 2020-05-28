<template>
  <div class="animated fadeIn">
    <el-row class="info-basic-row" type="flex" :gutter="20">
      <el-col :span="14">
        <el-row type="flex" :gutter="20">
          <el-col :span="6">
            <!-- 商品图片 -->
            <div>
              <img class="purchase-product-img"
                :src="slotData.product.thumbnail!=null?slotData.product.thumbnail.url:'static/img/nopicture.png'">
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
                <h6>交货货期：{{slotData.expectedDeliveryDate | timestampToTime}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>销售价格：{{slotData.unitPrice}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>合作方式：{{getEnum('machiningTypes', slotData.machiningType)}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>生产数量：{{slotData.totalQuantity}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>订单来源：{{getEnum('SalesProductionOrderType', slotData.orderSource)}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col>
                <h6>关联订单：{{slotData.relationOrderCode}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col>
                <h6>
                  收货地址：{{slotData.deliveryAddress!=null?slotData.deliveryAddress.details:''}}
                </h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex">
          <!-- 商品color/size表 -->
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
            <!-- <h6>生产负责人：{{slotData.productionLeader.name}}</h6> -->
          </el-col>
          <el-col :span="12">
            <!-- <h6>审批人：{{slotData.approvers[0].name}}</h6> -->
          </el-col>
        </el-row>
        <el-row type="flex">
          <el-col :span="6">
            <div class="info-row-title">
              <h6>合同</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="info-row-title_row" type="flex">
          <el-col>
            <PDFUpload :vFileList.sync="fileList" />
          </el-col>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import PDFUpload from '@/components/custom/upload/PDFUpload';


  export default {
    name: 'ProductionOrderTopInfo',
    props: ['slotData'],
    components: {
      PDFUpload
    },
    computed: {
      cooperatorName: function () {
        if (this.slotData.cooperator != null) {
          if (this.slotData.cooperator.type == 'ONLINE') {
            return this.slotData.cooperator.partner.name;
          } else {
            return this.slotData.cooperator.name;
          }
        }
      },
      contactPerson: function () {
        if (this.slotData.cooperator != null) {
          if (this.slotData.cooperator.type == 'ONLINE') {
            return this.slotData.cooperator.partner.contactPerson;
          } else {
            return this.slotData.cooperator.contactPerson;
          }
        }
      },
      contactPhone: function () {
        if (this.slotData.cooperator != null) {
          if (this.slotData.cooperator.type == 'ONLINE') {
            return this.slotData.cooperator.partner.contactPhone;
          } else {
            return this.slotData.cooperator.contactPhone;
          }
        }
      },
      sizes: function () {
        var sizes = [];
        if (this.slotData.colorSizeEntries != null) {
          this.slotData.colorSizeEntries.forEach(entry => {
            let index = sizes.findIndex(size => size.code == entry.size.code);
            if (index == -1) {
              sizes.push(entry.size);
            }
          });
        }
        return sizes;
      },
      dataTable: function () {
        var result = [];
        if (this.slotData.colorSizeEntries != null) {
          this.slotData.colorSizeEntries.forEach(entry => {
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
        return result;
      },
    },
    methods: {
      // 展开/收起列表行
      onClickShowTable() {
        this.showTable = !this.showTable;
      },

    },
    data() {
      return {
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
