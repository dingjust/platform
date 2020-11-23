<template>
  <el-row class="upload-part">
    <el-row type="flex">
      <h6 class="title-text">合同</h6>
    </el-row>
    <el-row type="flex" class="basic-container">
      <images-upload :slotData="formData.contract" />
    </el-row>
    <el-row type="flex">
      <h6 class="title-text">附件</h6>
    </el-row>
    <el-row type="flex" class="basic-container">
      <files-upload :slotData="formData.enclosure" />
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