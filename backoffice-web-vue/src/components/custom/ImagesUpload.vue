<template>
  <div class="animated fadeIn image-upload">
    <el-row :gutter="10">
      <el-col :span="24">
        <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData"
          :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers" :file-list="fileList"
          :on-exceed="handleExceed" :on-preview="handlePreview" :limit="limit" :on-remove="handleRemove"
          :class="{disabled:uploadDisabled,picClass:picClass}">
          <i class="el-icon-plus" slot="default"></i>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible" :modal="false">
          <img width="100%" :src="dialogImageUrl" alt="">
        </el-dialog>
      </el-col>
    </el-row>
  </div>
</template>

<script>
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
      }
    },
    methods: {
      onBeforeUpload (file) {
        if (file.size > 1024 * 1024 * 5) {
          this.$message.error('上传的文件不允许超过5M');
          return false;
        }
        return true;
      },
      onSuccess (response) {
        this.slotData.push(response);
        if (this.slotData.length === this.limit) {
          this.uploadDisabled = true;
        } else {
          this.uploadDisabled = false;
        }
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

        const images = this.fileList || [];
        const index = images.indexOf(file);
        this.slotData.splice(index, 1);
        if (this.slotData.length === this.limit) {
          this.uploadDisabled = true;
        } else {
          this.uploadDisabled = false;
        }
      },
      handlePreview (file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      handleExceed (files, fileList) {
        this.$message.warning('当前限制选择' + this.limit + ' 个图片');
      }
    },
    computed: {
      fileList: function () {
        let files = [];
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
            if (image.convertedMedias.length > 0) {
              image.convertedMedias.forEach(convertedMedia => {
                if (convertedMedia.mediaFormat === 'DefaultProductPreview') { file.url = convertedMedia.url; }
              })
            }
            files.push(file);
          })
        }

        if (this.slotData.length === this.limit) {
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
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    data () {
      return {
        dialogImageUrl: '',
        dialogVisible: false,
        uploadDisabled: false
      }
    }
  };
</script>

<style>
  .image-upload .disabled .el-upload--picture-card {
    display: none!important;
  }

  .image-upload  .el-upload-list__item {
    transition: none !important;
  }

  .image-upload .picClass .el-upload-list--picture-card .el-upload-list__item{
    width: 100%;
    height: 100%;
  }
</style>
