<template>
  <div class="animated fadeIn">
    <el-row class="info-basic-row" type="flex" :gutter="20">
      <el-col :span="14">
        <el-row type="flex" :gutter="20">
          <el-col :span="6">
            <!-- 商品图片 -->
            <div>
              <img class="purchase-product-img"
                :src="slotData.entries[0]!=null?slotData.entries[0].product.thumbnail.url:'static/img/nopicture.png'">
            </div>
          </el-col>
          <el-col :span="18">
            <!-- 商品详情 -->
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>产品名称：{{slotData.entries[0].product.name}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>商品货号：{{slotData.entries[0].product.code}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>
                  品&#12288;&#12288;类：{{slotData.entries[0].product.category!=null?slotData.entries[0].product.category.name:''}}
                </h6>
              </el-col>
              <el-col :span="12">
                <h6>交货货期：{{slotData.entries[0].deliveryDate | timestampToTime}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>销售价格：{{slotData.entries[0].unitPrice}}</h6>
              </el-col>
              <el-col :span="12">
                <h6>合作方式：{{getEnum('machiningTypes', slotData.cooperationMode)}}</h6>
              </el-col>
            </el-row>
            <el-row class="info-basic-row" type="flex">
              <el-col :span="12">
                <h6>生产数量：{{slotData.entries[0].quantity}}</h6>
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
                  收货地址：{{slotData.entries[0].shippingAddress!=null?slotData.entries[0].shippingAddress.details:''}}
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
            <h6>生产负责人：{{slotData.productionLeader.name}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>审批人：{{slotData.approvers[0].name}}</h6>
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
            <!-- <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData"
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
            </el-upload> -->
          </el-col>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ReceivingDetailsForm',
    props: ['slotData'],
    computed: {
      colors: function () {
        var colors = [];
        this.slotData.entries[0].colorSizeEntries.forEach(entry => {
          let index = colors.findIndex(color => color.code == entry.color.code);
          if (index == -1) {
            colors.push(entry.color);
          }
        });
        return colors;
      },
      sizes: function () {
        var sizes = [];
        this.slotData.entries[0].colorSizeEntries.forEach(entry => {
          let index = sizes.findIndex(size => size.code == entry.size.code);
          if (index == -1) {
            sizes.push(entry.size);
          }
        });
        return sizes;
      },
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
      dataTable: function () {
        var result = [];
        this.slotData.entries[0].colorSizeEntries.forEach(entry => {
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
        return result;
      },
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
      onBeforeUpload(file) {
        if (file.type !== 'application/pdf') {
          this.$message.error('选择的文件不是PDF文件');
          return false;
        }
        return true;
      },
      onSuccess(response) {
        this.pdfFile = response;
      },
      handleExceed(files, fileList) {
        if (fileList > 1) {
          this.$message.warning(`已达最大文件数`);
          return false;
        }
      },
      handlePreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      handleRemove(file) {
        this.fileList = [];
        this.pdfFile = '';
      },
      getColorSizeEntryQuantity(color, size) {
        let index = this.slotData.entries[0].colorSizeEntries.findIndex(entry => entry.color.code == color.code && entry
          .size.code == size.code);
        if (index != -1) {
          return this.slotData.entries[0].colorSizeEntries[index].quantity;
        } else {
          return '';
        }
      },
      // 展开/收起列表行
      onClickShowTable() {
        this.showTable = !this.showTable;
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

</style>
