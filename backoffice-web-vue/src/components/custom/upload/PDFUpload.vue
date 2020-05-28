<template>
  <div>
    <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData"
      :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers" :on-exceed="handleExceed"
      :file-list="fileList" multiple :limit="5">
      <div slot="tip" class="el-upload__tip">只能上传PDF文件</div>
      <i class="el-icon-plus"></i>
      <div slot="file" slot-scope="{file}">
        <img class="el-upload-list__item-thumbnail" src="static/img/pdf.png" alt="">
        <span class="el-upload-list__item-actions">
          <span class="el-upload-list__item-preview" @click="onDownload(file)">
            <i class="el-icon-download"></i>
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
  </div>
</template>

<script>
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
        if (fileList > 1) {
          this.$message.warning(`已达最大文件数`);
          return false;
        }
      },
      handleRemove(file) {
        const index = this.fileList.indexOf(file);
        this.fileList.splice(index, 1);
      },
      onDownload(file) {
        console.log(JSON.stringify(file));
        window.open(file.url);
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
      }
    },
    data() {
      return {
        mediaUploadUrl: '/b2b/media/file/upload',
        fileList: []
      }
    },
    watch: {
      vFileList: function (newVal, oldVal) {
        this.fileList = newVal;
      },
      fileList: function (newVal, oldVal) {
        this.$emit("update:vFileList", newVal);
      },
    }
  };

</script>

<style scoped>
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
