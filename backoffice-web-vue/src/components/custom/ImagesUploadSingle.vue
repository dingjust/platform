<template>
  <div class="animated fadeIn image-upload">
    <el-row :gutter="10">
      <el-col :span="24">
        <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData" :disabled="disabled"
          :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers" :file-list="fileList"
          :on-exceed="handleExceed" :on-preview="handlePreview" :limit="limit" :on-remove="handleRemove"
          :class="{hide:hideUploadShow,disabled:uploadDisabled}">
          <i class="el-icon-plus" slot="default"></i>
          <div slot="tip" class="el-upload__tip"><slot name="picBtn" ></slot></div>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible" append-to-body width="50%">
          <img width="100%" :src="dialogImageUrl" alt="">
        </el-dialog>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ImagesUploadSingle',
    props: {
      formData: {
        required: true
      },
      disabled: {
        type: Boolean,
        default: false
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    methods: {
      onChange () {
        this.hideUpload = true;
      },
      onBeforeUpload (file) {
        if (file.size > 1024 * 1024 * 10) {
          this.$message.error('上传的文件不允许超过10M');
          return false;
        }

        return true;
      },
      handleExceed (files, fileList) {
        this.$message.warning('当前限制选择' + this.limit + ' 个图片');
      },
      onSuccess (response) {
        // this.formData = response;
        this.$emit('getPicture', response);
        // console.log(response);
        this.hideUpload = true;
        this.uploadDisabled = true;
      },
      handlePreview (file) {
        this.dialogImageUrl = file.artworkUrl;
        this.dialogVisible = true;
      },
      async handleRemove (file) {
        // console.log(JSON.stringify(file));
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

        // this.fileList = [];
        this.$emit('removePicture');
        // this.formData = {};
        this.hideUpload = false;
        this.uploadDisabled = false;
      }
    },
    computed: {
      hideUploadShow: function () {
        if (JSON.stringify(this.formData) == '{}') {
          return false;
        }
        return true;
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
          Authorization: 'Bearer ' + token
          // Authorization: this.$store.getters.token
        }
      },
      fileList: function () {
        let files = [];
        if (this.formData && this.formData.id) {
          let file = {
            id: '',
            url: '',
            artworkUrl: ''
          }
          file.id = this.formData.id;
          file.artworkUrl = this.formData.url;
          file.url = this.formData.url;
          // image.url = '';
          if (this.formData.convertedMedias && this.formData.convertedMedias.length > 0) {
            this.formData.convertedMedias.forEach(convertedMedia => {
              if (convertedMedia.mediaFormat === 'DefaultProductPreview') { file.url = convertedMedia.url; }
            }
            )
          }
          files.push(file);
        }
        return files;
      }
    },
    data () {
      return {
        dialogImageUrl: '',
        dialogVisible: false,
        uploadDisabled: false,
        picClass: false,
        limit: 1,
        hideUpload: true
      }
    }
  };
</script>

<style>
  .hide .el-upload--picture-card {
    display: none!important;
  }

  .image-upload .disabled .el-upload--picture-card {
    display: none!important;
  }


  .image-upload  .el-upload-list__item {
    transition: none !important;
  }

  .image-upload .picClass .el-upload-list--picture-card .el-upload-list__item{
    width: 320px;
    height: 180px;
    position:absolute;left:0px; top:0px;clip:rect(0px 320px 180px 0px)
  }

  .image-upload .picClass .el-upload--picture-card {
    width:120px;
    height: 120px;
    line-height: 120px;
  }
</style>
