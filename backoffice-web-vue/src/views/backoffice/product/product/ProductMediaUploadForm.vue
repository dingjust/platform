<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="formData" :rules="rules">
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="选择多媒体格式" prop="format">
            <el-select v-model="formData.format" class="w-100" @change="showRule">
              <el-option v-for="item in formats" :key="item.value" :label="item.label" :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-upload v-if="isPicture" ref="uploadForm" name="files" list-type="picture-card"
                   :multiple="true"
                   :data="data"
                   :action="uploadUrl"
                   :file-list="files"
                   :on-success="onUploadSuccess"
                   :on-error="onUploadError"
                   :on-progress="onUploading"
                   :before-upload="beforeUpload"
                   :auto-upload="false">
          <i class="el-icon-plus"></i>

          <div v-if="this.picture=='normalPicture'" slot="tip" class="el-upload__tip">
            只能上传jpg/png文件，建议像素尺寸（宽*高）750*700，且不超过400KB
          </div>
          <div v-else-if="this.picture=='detailPicture'" slot="tip" class="el-upload__tip">
            只能上传jpg/png文件，建议像素尺寸750宽，且不超过300KB
          </div>
          <div v-else slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过5MB</div>
        </el-upload>
        <el-upload v-else ref="uploadForm" name="files"
                   :multiple="true"
                   list-type="picture"
                   :data="data"
                   :action="uploadUrl"
                   :file-list="files"
                   :on-success="onUploadSuccess"
                   :on-error="onUploadError"
                   :on-progress="onUploading"
                   :auto-upload="false">
          <el-button size="small" type="primary">点击上传文件</el-button>
          <div slot="tip" class="el-upload__tip">只能上传文件，且不超过5MB</div>
        </el-upload>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: "ProductMediaUploadForm",
    props: ["slotData", "isNewlyCreated"],
    methods: {
      onSubmit() {
        this.$refs["form"].validate(valid => {
          if (valid) {
            this.$refs.uploadForm.submit();

            return true;
          }

          return false;
        });
      },
      onUploadSuccess(response, file, files) {
        if (response === "") {
          this.$message.success("上传成功");
          this.$refs.uploadForm.clearFiles();
        }
      },
      onUploadError(error, file, files) {
        /*let msg = "";
        if (file.size >= (1024 * 1024 * 5)) {
          msg = "，上传的文件不能超过5MB"
        }*/
        console.log(error);
        this.$message.error("上传失败" + "，" + JSON.parse(error.message).message);
      },
      onUploading(event, file, files) {
        this.$message("正在上传，请稍等");
      },
      beforeUpload(file) {
        let flat = true;

        if (this.picture == "normalPicture") {
          if (file.type != "image/png" && file.type != "image/jpeg") {
            this.$message.error("只能上传jpg/png文件");
            flat = false;
          }
          if (file.size > 1024 * 400) {
            this.$message.error("上传的文件不能超过400KB");
            flat = false;
          }
        }

        if (this.picture == "detailPicture") {
          if (file.type != "image/png" && file.type != "image/jpeg") {
            this.$message.error("只能上传jpg/png文件");
            flat = false;
          }
          if (file.size > 1024 * 300) {
            this.$message.error("上传的文件不能超过300KB");
            flat = false;
          }
        }

        return flat;
      },
      showRule(value) {
        this.picture = value;
      }
    },
    computed: {
      data: function () {
        return {
          code: this.slotData.code,
          format: this.formData.format,
          files: this.files
        };
      },
      isPicture: function () {
        return this.formData.format !== "bom" ||
          this.formData.format !== "technicalDocuments";
      }
    },
    data() {
      return {
        uploadUrl: "/djbackoffice/product/media/upload",
        files: [],
        formData: {
          code: this.slotData.code,
          format: "masterPicture"
        },
        formats: [
          {
            value: "masterPicture",
            label: "缩略"
          },
          {
            value: "normalPicture",
            label: "主图"
          },
          {
            value: "detailPicture",
            label: "详细图"
          },
          {
            value: "bom",
            label: "BOM文件"
          },
          {
            value: "technicalDocuments",
            label: "技术文件"
          }
        ],
        rules: {
          format: [{required: true, message: "必填", trigger: "blur"}]
        },
        picture: "masterPicture"
      };
    }
  };
</script>
