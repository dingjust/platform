<template>
  <div>
    <el-row type="flex" justify="start" class="purchase-row" v-if="readOnly">
      <el-col :span="6">
        <h6>采购单号：{{order.code}}</h6>
      </el-col>
      <el-col :span="6">
        <h6>关联款号：{{formData.task.productionTask.product.skuID}}</h6>
      </el-col>
      <el-col :span="6">
        <h6>关联需求：{{formData.task.code}}</h6>
      </el-col>
      <el-col :span="6">
        <h6>创建时间：{{order.creationtime | timestampToTime}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start">
      <el-col :span="18">
        <el-row type="flex" justify="start" class="purchase-row">
          <el-col :span="8">
            <h6>物料编号：{{formData.materials.code}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>物料属性：{{getEnum('MaterialsType', formData.materials.materialsType)}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>到料时间：{{formData.materials.specList[0].estimatedRecTime | timestampToTime}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="purchase-row">
          <el-col :span="8">
            <div style="display: flex;flex-wrap: wrap;">
              <h6>是否含税：{{formData.task.includeTax ? '是' : '否'}}</h6>
              <h6 v-if="formData.task.includeTax" style="margin-left: 30px">税点：{{formData.task.taxPoint * 100}}%</h6>
            </div>
          </el-col>
          <el-col :span="8">
            <h6>品质要求：{{getEnum('QualityRequirementType', formData.task.qualityRequirement)}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>供应商：{{formData.cooperatorName}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="purchase-row">
          <h6>收货地址：{{formData.task.shippingAddress.details}}</h6>
        </el-row>
      </el-col>
      <el-col :span="6">
        <div class="box">
          <el-row type="flex" justify="space-between" align="middle">
            <h6>合同：</h6>
            <template v-if="!readOnly">
              <el-upload name="file" :action="mediaUploadUrl" :data="uploadFormData" ref="upload" :before-upload="onBeforeUpload"
                        :on-success="onSuccess" :headers="headers" :file-list="fileList" :on-exceed="handleExceed"
                        :limit="limit" :on-remove="handleRemove" :on-change="onChange">
                <el-button type="text">
                  <i class="iconfont2_2" style="font-size: 20px;">&#xe6b9;</i>
                  <h6 class="upload-title">点击上传</h6>
                </el-button>
              </el-upload>
            </template>
          </el-row>
          <div class="contract-list">
            <template v-if="order.attachAgreements && order.attachAgreements.length > 0">
              <template v-for="(item, index) in order.attachAgreements">
                <div :key="item.id" :title="item.name" class="contract-item" style="width: 60px">
                  <div class="mask" :key="item.id">
                    <el-button type="text" @click="showContract(item)">
                      <i style="font-size: 22px;color: #fff;font-size: 20px;" class="el-icon-zoom-in"></i>
                    </el-button>
                    <el-button type="text" @click="onDelete(item, index)">
                      <i style="font-size: 22px;color: #fff;font-size: 20px;" class="el-icon-delete"></i>
                    </el-button>
                  </div>
                  <el-row type="flex" justify="center" align="middle">
                    <div>
                      <img style="width: 100%" src="static/img/word.png"/>
                    </div>
                  </el-row>
                  <el-row type="flex" justify="center" align="middle">
                    <h6 class="upload-text nowrap-text">{{item.name}}</h6>
                  </el-row>
                </div>
              </template>
            </template>
            <div v-if="isUploading">
              <el-progress type="circle" :percentage="25" style="width: 40px;height: 40px;margin-top: 10px"></el-progress>
            </div>
          </div>    
        </div>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="imgVisible" width="40%" append-to-body :close-on-click-modal="false">
      <img width="100%" :src="dialogImageUrl" alt="">
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" append-to-body
      :close-on-click-modal="false">
      <pdf-preview v-if="pdfVisible" :fileUrl="pdfUrl" />
    </el-dialog>
  </div>
</template>

<script>
import ImageUtil from '@/plugins/ImageUtil';
import PdfPreview from '@/components/custom/upload/PdfPreview'


export default {
  name: 'PurchaseOrderBasicInfo',
  props: {
    order: {
      required: true
    },
    formData: {
      required: true
    },
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  components: {
    PdfPreview
  },
  computed: {
    uploadFormData: function () {
      return {
        fileFormat: 'DefaultFileFormat',
        conversionGroup: 'DefaultProductConversionGroup'
      };
    },
    headers: function () {
      const token = sessionStorage.getItem('token');
      return {
        Authorization: 'Bearer ' + token
      }
    },
    fileList: function () {
      let files = [];
      let type;
      if (this.order.attachAgreements && this.order.attachAgreements.length > 0) {
        this.order.attachAgreements.forEach(image => {
          let file = {
            id: '',
            url: '',
            artworkUrl: ''
          }
          file.id = image.id;
          file.artworkUrl = image.url;
          file.url = image.url;
          // image.url = '';
          if (image.convertedMedias.length > 0) {
            image.convertedMedias.forEach(convertedMedia => {
              if (convertedMedia.mediaFormat === 'DefaultProductPreview') {
                file.url = convertedMedia.url;
              }
              if (convertedMedia.mediaFormat === 'DefaultProductDetail') {
                file.artworkUrl = convertedMedia.url;
              }
            })
          }
          files.push(file);
        })
      }

      if (this.order.attachAgreements.length === this.limit) {
        this.uploadDisabled = true;
      } else {
        this.uploadDisabled = false;
      }
      return files;
    },
  },
  methods: {
    onChange (file, fileList) {
      this.isUploading = false;
    },
    onBeforeUpload(file) {
      this.isUploading = true;

      if (file.size > 1024 * 1024 * 10) {
        this.$message.error('上传的文件不允许超过10M');
        return false;
      } else {
        if (file.type === 'image/jpeg' || file.type === 'image/jpg' || file.type === 'image/png') {
          //若为Edge浏览器直接返回
          let userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
          //Edge跳过压缩
          if (userAgent.indexOf("Edge") > -1) {
            return true;
          }
          return new Promise((resolve, reject) => {
            //压缩图片
            let reader = new FileReader();
            let img = new Image();
            reader.onload = (e) => {
              img.src = e.target.result;
              img.onload = function () {
                const data = ImageUtil.compressImage(img, img.width, img.height, 0.5);
                const newFile = ImageUtil.dataURLtoFile(data, file.name);
                resolve(newFile);
              };
            }
            reader.readAsDataURL(file);              
          });
        }
        return true;
      }
    },
    onSuccess(response) {
      this.order.attachAgreements.push(response);
      if (this.order.attachAgreements.length === this.limit) {
        this.uploadDisabled = true;
      } else {
        this.uploadDisabled = false;
      }
    },
    handleExceed(files, fileList) {
      this.$message.warning('当前限制选择' + this.limit + ' 个图片');
    },
    async handleRemove(file) {
      const images = this.fileList || [];
      const index = images.indexOf(file);
      this.order.attachAgreements.splice(index, 1);
      if (this.order.attachAgreements.length === this.limit) {
        this.uploadDisabled = true;
      } else {
        this.uploadDisabled = false;
      }
    },
    showContract (item) {
      if (item.mediaType === 'application/pdf') {
        this.pdfUrl = item.url;
        this.pdfVisible = true;
      } else if (item.mediaType === 'image/png' || item.mediaType === 'image/jpeg' || item.mediaType === 'image/jpg') {
        this.dialogImageUrl = item.url;
        this.imgVisible = true;
      } else {
        this.$message.warning('暂不支持此文件类型预览！');
      }
    },
    onDelete (item, index) {
      this.order.attachAgreements.splice(index, 1);
    }
  },
  data () {
    return {
      imgVisible: false,
      pdfVisible: false,
      dialogVisible: false,
      dialogImageUrl: '',
      limit: 5,
      pdfUrl: '',
      isUploading: false
    }
  }
}
</script>

<style scoped>
  .purchase-row {
    margin: 0px 0px 10px 0px;
  }

  .box {
    border: 2px solid #ededed;
    border-radius: 5px;
    width: 100%;
    height: 100%;
    padding: 5px 0px 0px 5px;
  }

  .upload-title {
    margin: 0px;
    font-size: 12px;
  }

  button {
    outline: none;
  }

  /deep/ .el-upload-list {
    display: none;
  }

  .upload-text {
    margin-bottom: 0px;
    font-size: 12px;
  }

  .nowrap-text {
    display: inline-block;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .contract-item {
    padding: 5px;
    border-radius: 5px;
  }
  /* .contract-item:hover { */
    /* background-color: #ffd60c; */
  /* } */

  .contract-item:hover .mask {
    opacity: 1;
  }

  .contract-list {
    display: flex;
    flex-wrap: wrap;
  }

  /deep/ .el-progress-circle {
    width: 40px!important;
    height: 40px!important;
  }

  .mask {
    display: flex;
    justify-content: center;
    position: absolute;
    background-color: rgba(0,0,0,.5);
    width: 50px;
    opacity: 0;
    height: 64px;
    z-index: 9;
    border-radius: 5px;
  }
  
</style>