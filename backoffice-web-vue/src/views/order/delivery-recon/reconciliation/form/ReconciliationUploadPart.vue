<template>
  <el-row class="upload-part">
    <el-row type="flex">
      <h6 class="title-text">纸质对账单
        <span style="color: #909399">(把已签署的对账单文件扫描上传到订单附件中作为备份)</span>
      </h6>
    </el-row>
    <el-row type="flex" class="basic-container">
      <images-upload ref="imageUpload" :slotData="formData.paperSheetMedias" :limit="1"/>
    </el-row>
    <el-row type="flex">
      <h6 class="title-text">附件</h6>
    </el-row>
    <el-row type="flex" class="basic-container">
      <files-upload ref="filesUpload" :slotData="formData.medias" />
    </el-row>
  </el-row>
</template>

<script>
import { FilesUpload, ImagesUpload } from '@/components'

export default {
  name: 'ReconciliationUploadPart',
  props: ['formData'],
  components: {
    FilesUpload,
    ImagesUpload
  }
}
</script>

<style scoped>
  .upload-part {
    margin-top: 20px;
  }

  .basic-container {
    margin: 10px 0px 20px 25px;
  }

  .title-text {
    font-size: 14px;
    color: #606266;
    margin: 0px;
  }

  .upload-part >>> .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .upload-part >>> .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }
</style>