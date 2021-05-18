<template>
  <div class="addition-row">
    <el-row>
      <h6>附件及备注</h6>
    </el-row>
    <el-row type="flex" justify="start" class="addition-row">
      <el-form-item label="备注" style="width: 100%">
        <el-input type="textarea" :rows="2" placeholder="请输入内容" v-model="formData.remarks" />
      </el-form-item>
    </el-row>
    <el-row class="addition-row" type="flex" justify="start">
      <el-form-item label="附件">
        <images-upload class="order-purchase-upload" :slot-data="formData.attachments" />
      </el-form-item>
    </el-row>
  </div>
</template>

<script>
import {
  ImagesUpload
} from '@/components'

export default {
  name: 'OutboundOrderAdditionInfo',
  props: ['formData'],
  components: {
    ImagesUpload
  }
}
</script>

<style scoped>
.addition-row {
  padding-left: 10px;
}

.order-purchase-upload {
  margin-left: 5px;
}

.order-purchase-upload>>>.el-upload--picture-card {
  width: 100px;
  height: 100px;
  line-height: 100px;
}

.order-purchase-upload>>>.el-upload-list--picture-card .el-upload-list__item {
  width: 100px;
  height: 100px;
}
</style>