<template>
  <div class="animated fadeIn">
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
    <el-row :gutter="10" v-if="!readOnly">
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
  </div>
</template>

<script>
  export default {
    name: 'FactoryCertificateForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        this.$refs.form.validate(callback);
      },
      onFilterCategories(query) {
        this.categories = [];
        if (query && query !== '') {
          this.loading = true;
          setTimeout(() => {
            this.loading = false;
            this.getCategories(query);
          }, 200);
        }
      },
      async getCategories(query) {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
      async getStyles() {
        const url = this.apis().getAllStyles();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.styles = result;
      }
    },
    data() {
      return {
        loading: false,
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          skuID: [{required: true, message: '必填', trigger: 'blur'}],
          category: [{required: true, message: '必填', trigger: 'blur'}],
          price: [{required: true, message: '必填', trigger: 'blur'}]
        },
        categories: [],
        companies: [],
        styles: [],
        categoryProps: {
          label: 'name',
          value: 'code',
          children: 'children'
        }
      };
    },
    created() {
      this.getCategories('');
      this.getStyles();
    }
  };
</script>
