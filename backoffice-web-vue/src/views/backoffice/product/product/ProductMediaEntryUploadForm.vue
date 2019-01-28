<template>
  <div class="animated fadeIn">
    <el-row :gutter="10">
      <el-col :span="4">
        {{slotData.format.label}}
        <el-input type="hidden" v-model="slotData.format.value"></el-input>
      </el-col>
      <el-col :span="20">
        <el-upload v-if="isPicture" ref="uploadForm"
                   name="files"
                   list-type="picture"
                   :multiple="true"
                   :data="data"
                   :action="uploadUrl"
                   :file-list="files"
                   :on-success="onUploadSuccess"
                   :on-error="onUploadError"
                   :on-progress="onUploading"
                   :before-upload="beforeUpload"
                   :auto-upload="false">
          <el-button size="small" type="primary">点击上传</el-button>

          <div v-if="slotData.format.value=='normalPicture'" slot="tip" class="el-upload__tip">
            只能上传jpg/png文件，建议像素尺寸（宽*高）750*700，且不超过400KB
          </div>
          <div v-else-if="slotData.format.value=='detailPicture'" slot="tip" class="el-upload__tip">
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
          <el-button size="small" type="primary">点击上传</el-button>
          <div slot="tip" class="el-upload__tip">只能上传文件，且不超过5MB</div>
        </el-upload>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: "ProductMediaEntryUploadEntry",
    props: ["slotData", "isNewlyCreated"],
    methods: {
      onSubmit() {
        this.$refs.uploadForm.submit();
      },
      onUploadSuccess(response, file, files) {
        if (response === "") {
          this.$message.success("上传成功");
          this.$refs.uploadForm.clearFiles();
        }
      },
      onUploadError(error, file, files) {
        this.$message.error("上传失败" + "," + JSON.parse(error.message).message);
      },
      onUploading(event, file, files) {
        this.$message("正在上传，请稍等");
      },
      beforeUpload(file) {
        console.log(this.slotData.format.value);
        const formatValue = this.slotData.format.value;
        let flat = true;

        if (formatValue == "normalPicture") {
          if (file.type != "image/png" && file.type != "image/jpeg") {
            this.$message.error("只能上传jpg/png文件");
            flat = false;
          }
          if (file.size > 1024 * 400) {
            this.$message.error("上传的文件不能超过400KB");
            flat = false;
          }
        }

        if (formatValue == "detailPicture") {
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
      }
    },
    computed: {
      data: function () {
        return {
          code: this.slotData.code,
          format: this.slotData.format.value,
          files: this.files
        };
      },
      isPicture: function () {
        return this.slotData.format.value !== "bom" &&
          this.slotData.format.value !== "technicalDocuments";
      }
    },
    data() {
      return {
        uploadUrl: "/djbackoffice/product/media/upload",
        files: []
      };
    }
  };
</script>
