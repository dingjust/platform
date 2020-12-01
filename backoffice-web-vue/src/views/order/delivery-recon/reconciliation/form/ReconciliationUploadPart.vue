<template>
  <el-row class="upload-part">
    <el-row type="flex">
      <h6 class="title-text" style="margin-bottom: 10px">纸质对账单
        <span style="color: #909399">(把已签署的对账单文件扫描上传到订单附件中作为备份)</span>
      </h6>
    </el-row>
    <el-row type="flex" style="margin-left: 25px">
      <el-form-item prop="paperSheetMedias" style="paper-sheet-medias"
        :rules="{required: needValidate, type: 'array', message: '合作商双方有其中一方未认证时，需上传已签署的对账单', trigger: 'change'}">
        <images-upload ref="imageUpload" :slotData="formData.paperSheetMedias" :limit="1"/>
      </el-form-item>
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
  props: ['formData', 'isAllApproval'],
  components: {
    FilesUpload,
    ImagesUpload
  },
  computed: {
    needValidate: function () {
      return this.formData.cooperator.id && this.isAllApproval;
    }
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

  .paper-sheet-medias {
    width: 100%;
  }

  /deep/ .is-error {
    width: 100%;
  }
  
  /deep/ .el-form-item__content {
    width: 100%;
  }

</style>