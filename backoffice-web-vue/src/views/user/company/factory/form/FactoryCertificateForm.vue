<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="工商注册号或统一社会信用代码" prop="businessRegistrationNo">
            <el-input v-model="slotData.businessRegistrationNo"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="法定代表人" prop="legalRepresentative">
            <el-input v-model="slotData.legalRepresentative"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="法定代表人证件号码" prop="certificateOfLegal">
            <el-input v-model="slotData.certificateOfLegal"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
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
    <el-row :gutter="10">
      <el-col :span="24">
        <el-upload
          name="file"
          :disabled="readOnly"
          :action="mediaUploadUrl"
          list-type="picture-card"
          :data="uploadFormData"
          :before-upload="onBeforeUpload"
          :on-success="onSuccess"
          :headers="headers"
          :file-list="slotData.images"
          :on-preview="handlePreview"
          :on-remove="handleRemove">
          <i class="el-icon-plus"></i>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible" :modal="false" :close-on-click-modal="false">
          <img width="100%" :src="dialogImageUrl" alt="">
        </el-dialog>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'FactoryCertificateForm',
    props: ['slotData', 'readOnly'],
    computed: {
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup',
        };
      },
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    methods: {
      onBeforeUpload(file) {
        if (file.size > 1024 * 1024 * 10) {
          this.$message.error('上传的文件不允许超过10M');
          return false;
        }

        return true;
      },
      onSuccess(response) {
        this.slotData.attachments.push(response);
      },
      async handleRemove(file) {
        const url = this.apis().removeMedia(file.id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        const images = this.slotData.images || [];
        const index = images.indexOf(file);
        images.splice(index, 1);

        this.$message.success("删除成功");
      },
      handlePreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
    },
    data() {
      return {
        rules: {},
        dialogImageUrl: '',
        dialogVisible: false,
        styles: this.$store.state.EnumsModule.productStyles,
      };
    }
  };
</script>
