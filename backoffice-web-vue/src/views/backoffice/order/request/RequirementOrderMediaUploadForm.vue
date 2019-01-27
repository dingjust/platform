<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="formData"
             :rules="rules">
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="选择合同类型" prop="format">
            <el-select v-model="formData.format" class="w-100">
              <el-option
                v-for="item in formats"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-upload ref="uploadForm"
                   name="files"
                   :multiple="true"
                   list-type="picture-card"
                   :data="data"
                   :action="uploadUrl"
                   :file-list="files"
                   :on-success="onUploadSuccess"
                   :on-error="onUploadError"
                   :on-progress="onUploading"
                   :auto-upload="false">
          <i class="el-icon-plus"></i>
          <div slot="tip" class="el-upload__tip">文件大小不超过10MB</div>
        </el-upload>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import axios from "axios";

  export default {
    name: 'RequirementOrderMediaUploadForm',
    props: ['slotData', 'orderData', 'isNewlyCreated'],
    methods: {
      onSubmit() {
        this.$refs['form'].validate(valid => {
          if (valid) {
            this.$refs.uploadForm.submit();

            return true;
          }

          return false;
        });
      },
      onCancel() {
        this.fn.closeSlider();
      },
      onUploadSuccess(response, file, files) {
        if (response === '') {
          this.$message.success('上传成功');
          this.$refs.uploadForm.clearFiles();

          this.refresh();
        }
      },
      onUploadError(error, file, files) {
        this.$message.error('上传失败');
      },
      onUploading(event, file, files) {
        this.$message('正在上传，请稍等');
      },
      refresh() {
        axios.get("/djbackoffice/requirementOrder/contracts", {
          params: {
            code: this.slotData.code
          }
        }).then(response => {
          this.$set(this.orderData, "contracts", response.data);
        }).catch(error => {
          console.log(JSON.stringify(error));
          this.$message.error("更新需求信息失败，原因：" + error.response.data);
        });
      }
    },
    computed: {
      data: function () {
        return {
          code: this.slotData.code,
          format: this.formData.format,
          files: this.files
        };
      }
    },
    data() {
      return {
        uploadUrl: '/djbackoffice/requirementOrder/media/upload',
        files: [],
        formData: {
          code: this.slotData.code,
          format: 'businessContract',
        },
        formats: [
          {
            value: 'businessContract',
            label: '商家合同'
          }
        ],
        rules: {
          format: [
            {required: true, message: '必填', trigger: 'blur'}
          ]
        }
      }
    }
  }
</script>
