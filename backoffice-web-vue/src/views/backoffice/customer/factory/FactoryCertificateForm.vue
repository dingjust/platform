<template>
  <el-card>
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="注册时间" prop="registrationDate">
            <el-date-picker class="w-100" type="month" placeholder="选择日期"
                            v-model="slotData.registrationDate"
                            :value-format="defaultDateValueFormat">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="税号" prop="taxNumber">
            <el-input v-model="slotData.taxNumber"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="开户行" prop="bankOfDeposit">
            <el-input v-model="slotData.bankOfDeposit"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <el-row :gutter="10" v-if="isNewlyCreated">
      <el-col :span="20">
        <el-upload ref="uploadForm"
                   name="files"
                   list-type="picture"
                   :multiple="true"
                   :data="data"
                   :action="uploadUrl"
                   :file-list="files"
                   :on-success="onUploadSuccess"
                   :on-error="onUploadError"
                   :on-progress="onUploading"
                   :auto-upload="false">
          <el-button size="small" type="primary">点击上传认证证件</el-button>
          <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过5MB</div>
        </el-upload>
      </el-col>
    </el-row>
  </el-card>
</template>

<script>
  export default {
    name: 'FactoryCertificateForm',
    props: ['slotData', 'isNewlyCreated', 'readOnly'],
    methods: {
      onSubmit() {
        console.log(this.slotData);
        this.$refs.uploadForm.submit();
      },
      validate(callback) {
        return this.$refs['form'].validate(callback);
      },
      getValue() {
        let certificateData = {};
        certificateData.uid = this.slotData.uid;
        certificateData.registrationDate = this.slotData.registrationDate;
        certificateData.taxNumber = this.slotData.taxNumber;
        certificateData.bankOfDeposit = this.slotData.bankOfDeposit;
        return certificateData;
      },
      onUploadSuccess(response, file, files) {
        if (response === '') {
          this.$message.success('上传成功');
          this.$refs.uploadForm.clearFiles();
          this.fn.closeSlider();
        }
      },
      onUploadError(error, file, files) {
        let msg = '';
        if (file.size >= (1024 * 1024 * 5)) {
          msg = '，上传的文件不能超过5MB'
        }
        this.$message.error('上传失败' + msg);
      },
      onUploading(event, file, files) {
        this.$message('正在上传，请稍等');
      }
    },
    computed: {
      data: function () {
        return {
          code: this.slotData.uid
        };
      }
    },
    data() {
      return {
        rules: {},
        uploadUrl: '/djfactory/factory/media/upload',
        files: []
      };
    }
  };
</script>
