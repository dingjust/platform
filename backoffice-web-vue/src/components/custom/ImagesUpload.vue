<template>
  <div class="animated fadeIn image-upload">
    <el-row :gutter="10">
      <el-col :span="24">
        <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData" ref="upload"
          :disabled="disabled" :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers"
          :file-list="fileList" :on-exceed="handleExceed" :on-preview="handlePreview" :limit="limit"
          :on-remove="handleRemove" :class="{disabled:uploadDisabled,picClass:picClass}">
          <i class="el-icon-plus" :style="custom ? 'border: 23px solid transparent;' : ''" slot="default"
            @click="onClick"></i>
          <div slot="tip" class="el-upload__tip">
            <slot name="picBtn"></slot>
          </div>
          <div slot="file" slot-scope="{file}" style="height: 100%">
            <template v-if="fileUrl(file) !== ''">
              <label class="el-upload-list__item-status-label">
                <i class="el-icon-upload-success el-icon-check" />
              </label>
              <img class="el-upload-list__item-thumbnail" :src="fileUrl(file)" alt="">
            </template>
            <template v-else>
              <el-progress type="circle" :percentage="100"></el-progress>
            </template>
            <span class="el-upload-list__item-actions">
              <span class="el-upload-list__item-preview" @click="onDetail(file)">
                <i class="el-icon-zoom-in"></i>
              </span>
              <span v-if="!disabled" class="el-upload-list__item-delete" @click="handleRemove(file)">
                <i class="el-icon-delete"></i>
              </span>
            </span>
          </div>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible" width="50%" append-to-body :close-on-click-modal="false">
          <img width="100%" :src="dialogImageUrl" alt="">
        </el-dialog>
        <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" append-to-body
          :close-on-click-modal="false">
          <pdf-preview v-if="pdfVisible" :fileUrl="pdfUrl" />
        </el-dialog>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ImageUtil from '@/plugins/ImageUtil';
  import PdfPreview from '@/components/custom/upload/PdfPreview'

  export default {
    name: 'ImagesUpload',
    props: {
      slotData: {
        type: Array,
        required: true
      },
      limit: {
        type: Number,
        default: 5
      },
      picClass: {
        type: Boolean,
        default: false
      },
      disabled: {
        type: Boolean,
        default: false
      },
      readOnly: {
        type: Boolean,
        default: false
      },
      // 是否通过自定义方式上传图片
      custom: {
        type: Boolean,
        default: false
      },
      uploadType: {
        type: String,
        default: ''
      }
    },
    components: {
      PdfPreview
    },
    methods: {
      fileUrl(file) {
        if (file.artworkUrl) {
          let fileType = this.getSuffix(file.artworkUrl);
          if (fileType === 'pdf') {
            return 'static/img/pdf.png';
          } else if (fileType === 'jpg' || fileType === 'jpeg' || fileType === 'png') {
            return file.artworkUrl;
          } else {
            return 'static/img/defaultIcon.png';
          }
        }
        return '';
      },
      onBeforeUpload(file) {
        if (this.uploadType && this.uploadType !== '') {
          if (file.type !== this.uploadType && !((file.type === 'image/jpeg' || file.type === 'image/jpg' || file.type === 'image/png') 
            && (this.uploadType === 'image/jpeg' || this.uploadType === 'image/jpg' || this.uploadType === 'image/png'))) {
            this.$message.warning('请选择与上一数据格式相同的文件');
            return false;
          }
        }

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
        this.slotData.push(response);
        if (this.slotData.length === this.limit) {
          this.uploadDisabled = true;
        } else {
          this.uploadDisabled = false;
        }
      },
      async handleRemove(file) {
        // TODO: 自定义删除方法（删除图片之前，清理product的others属性
        // const url = this.apis().removeMedia(file.id);
        // const result = await this.$http.delete(url);
        // if (result['errors']) {
        //   this.$message.error(result['errors'][0].message);
        //   return;
        // }
        // const images = this.fileList || [];
        // const index = images.indexOf(file);
        // images.splice(index, 1);
        // let newImages = [];
        // this.slotData.forEach(image => {
        //   if (image.id != file.id) {
        //     newImages.push(image);
        //   }
        // });
        // this.slotData = newImages;
        // this.$message.success("删除成功");
        if (file.status === 'ready') {
          return false;
        }
        
        const images = this.fileList || [];
        const index = images.indexOf(file);
        this.slotData.splice(index, 1);
        if (this.slotData.length === this.limit) {
          this.uploadDisabled = true;
        } else {
          this.uploadDisabled = false;
        }
      },
      handlePreview(file) {
        if (this.custom) {
          this.$emit('callback', file);
          return;
        }
        this.dialogImageUrl = file.artworkUrl;
        this.dialogVisible = true;
      },
      handleExceed(files, fileList) {
        this.$message.warning('当前限制选择' + this.limit + ' 个图片');
      },
      // 通过其他方式提交图片
      onClick() {
        if (this.custom) {
          this.$emit('onUpload');
        }
      },
      //是否还有正在上传文件
      isUploading() {
        let index = this.$refs.upload.uploadFiles.findIndex(file => file.status == 'uploading' || file.status ==
          'ready');
        return index != -1;
      },
      onDetail(file) {
        let fileType = this.getSuffix(file.artworkUrl);
        if (fileType === 'pdf') {
          this.pdfUrl = file.url;
          this.pdfVisible = true;
        } else if (fileType === 'jpg' || fileType === 'jpeg' || fileType === 'png') {
          if (this.custom) {
            this.$emit('callback', file);
            return;
          }
          this.dialogImageUrl = file.artworkUrl;
          this.dialogVisible = true;
        } else {
          this.$message('暂时不支持此类型的文件预览');
          // window.location.href = file.url;
        }
      },
      getSuffix(url) {
        let parser = document.createElement('a');
        parser.href = url
        let str = parser.pathname
        
        let index = str.lastIndexOf('.');
        return str.slice(index + 1);
      }
    },
    computed: {
      fileList: function () {
        let files = [];
        let type;
        if (this.slotData && this.slotData.length > 0) {
          this.slotData.forEach(image => {
            let file = {
              id: '',
              url: '',
              artworkUrl: ''
            }
            file.id = image.id;
            file.artworkUrl = image.url;
            file.url = image.url;
            // image.url = '';
            if (image.convertedMedias && image.convertedMedias.length > 0) {
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

        if (this.readOnly || this.slotData.length === this.limit) {
          this.uploadDisabled = true;
        } else {
          this.uploadDisabled = false;
        }
        return files;
      },
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup'
        };
      },
      headers: function () {

        const token = sessionStorage.getItem('token');
        return {
          //TODO:  store没刷新token
          // Authorization: this.$store.getters.token
          Authorization: 'Bearer ' + token
        }
      }
    },
    data() {
      return {
        dialogImageUrl: '',
        dialogVisible: false,
        uploadDisabled: false,
        pdfUrl: '',
        pdfVisible: false
      }
    }
  };

</script>

<style>
  .image-upload .disabled .el-upload--picture-card {
    display: none !important;
  }

  .image-upload .el-upload-list__item {
    transition: none !important;
  }

  .image-upload .picClass .el-upload-list--picture-card .el-upload-list__item {
    width: 320px;
    height: 180px;
    position: absolute;
    left: 0px;
    top: 0px;
    clip: rect(0px 320px 180px 0px)
  }

  .image-upload .picClass .el-upload--picture-card {
    width: 120px;
    height: 120px;
    line-height: 120px;
  }

</style>
