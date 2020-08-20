<template>
  <div>
    <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData" ref="upload"
      :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers" :on-exceed="handleExceed"
      :file-list="fileList" multiple :limit="fileLimit" :class="{hide:hideUpload}">
      <div slot="tip" class="el-upload__tip">只能上传PDF文件</div>
      <i class="el-icon-plus"></i>
      <div slot="file" slot-scope="{file}">
        <img class="el-upload-list__item-thumbnail" src="static/img/pdf.png" alt="">
        <span class="el-upload-list__item-actions">
          <span class="el-upload-list__item-preview" @click="onDownload(file)">
            <i class="el-icon-zoom-in"></i>
          </span>
          <span v-if="!disabled" class="el-upload-list__item-delete" @click="handleRemove(file)">
            <i class="el-icon-delete"></i>
          </span>
          <span v-if="!disabled" class="el-upload-list__item-file-name">
          </span>
        </span>
        <!-- <el-row type="flex" justify="center"> -->
        <div class="el-upload-under-file-name" style="font-szie:10px">{{file.name}}</div>
        <!-- </el-row> -->
      </div>
    </el-upload>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" style="width: 100%" append-to-body :close-on-click-modal="false">
      <pdf-preview v-if="pdfVisible" :fileUrl="fileUrl" />
    </el-dialog>
  </div>
</template>

<script>
  import PdfPreview from '@/components/custom/upload/PdfPreview'

  export default {
    name: 'PDFUpload',
    props: {
      vFileList: {
        type: Array,
        required: true
      },
      fileLimit: {
        type: Number,
        default: 5
      },
      disabled: {
        type: Boolean,
        default: false
      }
    },
    components: {
      PdfPreview
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
        this.fileList.push(response);
        if (this.fileList.length === this.limit) {
          this.uploadDisabled = true;
        } else {
          this.uploadDisabled = false;
        }
      },
      handleExceed(files, fileList) {
        // if (fileList > 1) {
          this.$message.warning(`已达最大文件数`);
          // return false;
        // }
      },
      handleRemove(file) {
        const index = this.fileList.indexOf(file);
        this.fileList.splice(index, 1);
      },
      onDownload(file) {
        // this.$confirm('是否打开页面?', '', {
        //   confirmButtonText: '是',
        //   cancelButtonText: '否',
        //   type: 'warning'
        // }).then(() => {
        //   window.open(file.url);
        // });
        console.log(file);
        this.fileUrl = file.url;
        this.pdfVisible = true;
      },
      //是否还有正在上传文件
      isUploading() {
        let index = this.$refs.upload.uploadFiles.findIndex(file => file.status == 'uploading' || file.status ==
          'ready');
        return index != -1;
      }
    },
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
      },
      canUpload: function () {
        if (this.disabled || this.fileList.length === this.fileLimit) {
          return false;
        }
        return true;
      }
    },
    data() {
      return {
        mediaUploadUrl: '/b2b/media/file/upload',
        fileList: [],
        pdfVisible: false,
        fileUrl: '',
        hideUpload: false
      }
    },
    watch: {
      vFileList: function (newVal, oldVal) {
        this.fileList = newVal;
      },
      fileList: function (newVal, oldVal) {
        this.$emit("update:vFileList", newVal);
        this.hideUpload = this.fileList.length >= this.fileLimit || this.disabled;
      },
    }
  };

</script>

<style scoped>
  /deep/ .hide .el-upload--picture-card {
    display: none!important;
  }

  /deep/ .el-upload--picture-card {
    width: 80px;
    height: 80px;
    line-height: 80px;
  }

  /deep/ .el-table--enable-row-hover .el-table__body tr:hover>td {
    background-color: #FFFFFF !important;
  }

  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    width: 80px;
    height: 80px;
    border: 0px solid;
  }

  /deep/ .el-upload-list--picture-card .el-upload-list__item-thumbnail {
    width: 70%;
    height: 70%;
    margin-left: 15%;
  }

  .el-upload-under-file-name {
    /* align-content: center; */
    text-align: center;
    align-content: center;
  }

</style>
