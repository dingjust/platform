<template>
  <div class="animated fadeIn image-upload">
    <el-row :gutter="10">
      <el-col :span="24">
        <el-upload name="file" :action="mediaUploadUrl" :data="uploadFormData" :disabled="disabled" ref="upload"
          :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers" :file-list="fileList"
          :multiple="true" :on-exceed="handleExceed" :on-preview="handlePreview" :limit="limit"
          :on-remove="handleRemove" :class="{disabled:uploadDisabled,picClass:picClass}">
          <el-button size="small" type="primary" v-if="!readOnly">点击上传</el-button>
          <div slot="tip" class="el-upload__tip" style="margin-top:10px;" v-if="!readOnly">文件大小不超过5M</div>
        </el-upload>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'FilesUpload',
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
      }
    },
    methods: {
      onBeforeUpload(file) {
        if (file.size > 1024 * 1024 * 5) {
          this.$message.error('上传的文件不允许超过5M');
          return false;
        }
        return true;
      },
      onSuccess(response, file, fileList) {
        let uploadingIndex = fileList.findIndex((e) => e.status == 'uploading');
        if (uploadingIndex < 0) {
          let data = fileList.filter((e) => e.status == 'success').map((e) => e.response);
          data.forEach(item => {
            if (item) {
              this.slotData.push(item);
            }
          });
        }
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
        const images = this.fileList || [];
        const index = images.indexOf(file);
        if (index > -1) {
          this.slotData.splice(index, 1);
        }
        if (this.slotData.length === this.limit) {
          this.uploadDisabled = true;
        } else {
          this.uploadDisabled = false;
        }
      },
      handlePreview(file) {
        this.$confirm('是否打开页面?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          window.open(file.url);
        });
        // this.dialogImageUrl = file.artworkUrl;
        // this.dialogVisible = true;
      },
      handleExceed(files, fileList) {
        this.$message.warning('当前限制选择' + this.limit + ' 个图片');
      },
      isUploading() {
        let index = this.$refs.upload.uploadFiles.findIndex(file => file.status == 'uploading' || file.status ==
          'ready');
        return index != -1;
      },
    },
    computed: {
      fileList: function () {
        let files = [];
        if (this.slotData && this.slotData.length > 0) {
          this.slotData.forEach(image => {
            let file = {
              id: '',
              url: '',
              artworkUrl: '',
              name: ''
            }
            file.id = image.id;
            file.artworkUrl = image.url;
            file.url = image.url;
            file.name = image.name;
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
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    data() {
      return {
        dialogImageUrl: '',
        dialogVisible: false,
        uploadDisabled: false,
        cacheData: []
      }
    }
  };

</script>

<style>
</style>
