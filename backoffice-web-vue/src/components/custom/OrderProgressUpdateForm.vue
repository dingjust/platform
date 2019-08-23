<template>
  <div class="finance-form-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">编辑</h6>
      </div>
    </el-row>
    <el-row type="flex" align="middle" class="progress-update-form-row">
      <el-col :span="3">
        <h6 class="progress-update-form-text1">预计完成日期:</h6>
      </el-col>
      <el-col :span="6" :offset="1">
        <div style="width:100%;">
          <el-date-picker style="width:100%;" class="progress-update-form-datepicker" v-model="form.date" type="date"
            placeholder="选择日期">
          </el-date-picker>
        </div>
      </el-col>
      <el-col :span="3" :offset="1">
        <h6 class="progress-update-form-text1">完成数量:</h6>
      </el-col>
      <el-col :span="6">
        <el-input v-model="form.num" type="number" placeholder="填写数量"></el-input>
      </el-col>
    </el-row>
    <el-row type="flex" align="top" class="progress-update-form-row">
      <el-col :span="3">
        <h6 class="progress-update-form-text1">备注信息:</h6>
      </el-col>
      <el-col :span="16" :offset="1">
        <el-input type="textarea" :rows="7" placeholder="填写备注" v-model="form.remarks">
        </el-input>
      </el-col>
    </el-row>
    <el-row type="flex" align="top" class="progress-update-form-row">
      <el-col :span="3">
        <h6 class="progress-update-form-text1">上传图片:</h6>
      </el-col>
      <el-col :span="16" :offset="1">
        <images-upload class="order-purchase-upload" :slot-data="form.attachments" />
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ImagesUpload from './ImagesUpload';

  export default {
    name: 'OrderProgressUpdateForm',
    components: {
      ImagesUpload
    },
    mixins: [],
    computed: {

    },
    methods: {

    },
    data() {
      return {
        form: {
          date: '',
          num: '',
          remarks: '',
          attachments: []
        }
      }
    },
    created() {

    },
    mounted() {}

  }

</script>
<style>
  .progress-update-form-text1 {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
    font-size: 12px;
    padding-top: 5px;
  }

  .progress-update-form-datepicker {
    font-size: 12px;
  }

  .progress-update-form-row {
    margin-bottom: 10px;
  }

  .order-purchase-upload {

  }

  .order-purchase-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .order-purchase-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

</style>
