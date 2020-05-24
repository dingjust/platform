<template>
  <div class="animated fadeIn">
    <el-row type="flex" :gutter="20">
      <el-col :span="14">
        <el-row type="flex" :gutter="20">
          <el-col :span="6">
            <!-- 商品图片 -->
            <img class="purchase-formData-img"
                 :src="slotData.product.thumbnail && slotData.product.thumbnail.length!=0 ?
                 slotData.product.thumbnail.url : 'static/img/nopicture.png'">
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
                <h6>品&#12288;&#12288;类：{{slotData.product.category.name}}</h6>
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
                <h6>订单来源：{{slotData.creator.name}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col>
                <h6>关联订单：{{slotData.relationOrder}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col>
                <h6>收货地址：{{slotData.deliveryAddress.details}}</h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex">
          <!-- 商品color/size表 -->
          <el-col>
            <el-row>
              <el-table :data="showData" border>
                <el-table-column label="颜色" prop="colorName"></el-table-column>
                <template v-for="(item, index) in sizeList">
                  <el-table-column :label="item.name" :prop="item.name"></el-table-column>
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
            <h6>合作商：{{slotData.cooperator.partner.name}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-row-title_row">
          <el-col :span="12">
            <h6>联系人：{{slotData.cooperator.partner.contactPerson}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.cooperator.partner.contactPhone}}</h6>
          </el-col>
        </el-row>
<!--        <el-row class="info-row-title_row">-->
<!--          <el-col>-->
<!--            <h6>工厂：</h6>-->
<!--          </el-col>-->
<!--        </el-row>-->
<!--        <el-row class="info-row-title_row">-->
<!--          <el-col :span="12">-->
<!--            <h6>联系人：{{slotData.partner.factory.contactsPerson}}</h6>-->
<!--          </el-col>-->
<!--          <el-col :span="12">-->
<!--            <h6>联系方式：{{slotData.partner.factory.contactsPhone}}</h6>-->
<!--          </el-col>-->
<!--        </el-row>-->
        <el-row type="flex">
          <el-col :span="6">
            <div class="info-row-title">
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="info-row-title_row">
          <el-col :span="12">
            <h6>生产负责人：{{isFactory() ? slotData.factoryOperator.name : slotData.brandOperator.name}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>审批人：{{isFactory() ? slotData.factoryOperator.name : slotData.brandOperator.name}}</h6>
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
            <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData"
                       :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers" :on-exceed="handleExceed"
                       :file-list="fileList" :on-preview="handlePreview" multiple :limit="1" :on-remove="handleRemove">
              <div slot="tip" class="el-upload__tip">只能上传PDF文件</div>
              <i class="el-icon-plus"></i>
              <div slot="file" slot-scope="{file}">
                <img class="el-upload-list__item-thumbnail" src="../../../../../../static/img/pdf.png" alt="">
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
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ProductionOrderTopInfo',
    props: ['slotData'],
    computed: {
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup'
        };
      },
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    methods: {
      onBeforeUpload (file) {
        if (file.type !== 'application/pdf') {
          this.$message.error('选择的文件不是PDF文件');
          return false;
        }
        return true;
      },
      onSuccess (response) {
        this.pdfFile = response;
      },
      handleExceed (files, fileList) {
        if (fileList > 1) {
          this.$message.warning(`已达最大文件数`);
          return false;
        }
      },
      handlePreview (file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      handleRemove (file) {
        this.fileList = [];
        this.pdfFile = '';
      },
      // 构建color/size表数据
      initColorSizeData () {
        let row = {};
        this.slotData.entries.forEach(item => {
          let index = this.colorSizeData.findIndex(val => val.colorName == item.product.color.name);
          if (index > -1) {
            this.colorSizeData[index][item.product.size.name] = item.quantity;
            this.colorSizeData[index].colorCount += item.quantity;
          } else {
            row.colorName = item.product.color.name;
            row.colorCode = item.product.color.code;
            row[item.product.size.name] = item.quantity;
            row.colorCount = item.quantity;
            this.colorSizeData.push(row);
            row = {};
          }
          let indexS = this.sizeList.findIndex(val => val.name == item.product.size.name);
          if (indexS < 0) {
            this.sizeList.push(item.product.size);
          }
        })
        this.showData = [this.colorSizeData[0]];
      },
      // 展开/收起列表行
      onClickShowTable () {
        this.showTable = !this.showTable;
        if (this.showTable) {
          this.showData = this.colorSizeData;
          return;
        }
        this.showData = [this.colorSizeData[0]];
      }
    },
    data () {
      return {
        defaultDateValueFormat: 'yyyy-MM-dd"T"HH:mm:ssZ',
        mediaUploadUrl: '/b2b/media/file/upload',
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
      'slotData.entries': function (newVal, oldVal) {
        if (newVal.length > 0) {
          this.initColorSizeData();
        }
      }
    },
    created () {
    }
  }
</script>

<style scoped>
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

  /deep/ .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  /deep/ .el-table--enable-row-hover .el-table__body tr:hover > td {
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
</style>
