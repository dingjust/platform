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
          <el-date-picker style="width:100%;" class="progress-update-form-datepicker" v-model="slotData.estimatedDate"
            type="date" placeholder="选择日期">
          </el-date-picker>
        </div>
      </el-col>
      <el-col :span="3" :offset="1">
        <h6 class="progress-update-form-text1">完成数量:</h6>
      </el-col>
      <el-col :span="6">
        <el-input v-model="slotData.quantity" type="number" placeholder="填写数量"></el-input>
      </el-col>
    </el-row>
    <el-row type="flex" align="top" class="progress-update-form-row">
      <el-col :span="3">
        <h6 class="progress-update-form-text1">备注信息:</h6>
      </el-col>
      <el-col :span="16" :offset="1">
        <el-input type="textarea" :rows="7" placeholder="填写备注" v-model="slotData.remarks">
        </el-input>
      </el-col>
    </el-row>
    <el-row type="flex" align="top" class="progress-update-form-row">
      <el-col :span="3">
        <h6 class="progress-update-form-text1">上传图片:</h6>
      </el-col>
      <el-col :span="16" :offset="1">
        <images-upload class="order-purchase-upload" :slot-data="slotData.medias" />
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" align="top" class="progress-update-form-row">
      <el-button size="mini" class="update-form-submit" @click="onSubmit">确定</el-button>
    </el-row>
  </div>
</template>

<script>
  import ImagesUpload from './ImagesUpload';

  export default {
    name: 'OrderProgressUpdateForm',
    props: ['slotData', 'orderCode'],
    components: {
      ImagesUpload
    },
    mixins: [],
    computed: {

    },
    methods: {
      async onSubmit() {
        // if (this.compareDate(new Date(), new Date(this.slotData.estimatedDate))) {
        //   this.$message.error('预计完成时间不能小于当前时间');
        //   return false;
        // }
        // const url = this.apis().updateProgressOfPurchaseOrder(this.orderCode, this.slotData.id);
        // const result = await this.$http.put(url, this.slotData);
        // if (result['errors']) {
        //   this.$message.error(result['errors'][0].message);
        //   return;
        // }
        // this.$message.success('更新成功');
        this.$emit('editSubmit');
      }
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

  .order-purchase-upload {}

  .order-purchase-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .order-purchase-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .update-form-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
    margin-top: 50px;
  }

</style>
