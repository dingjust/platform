<template>
  <div class="animated fadeIn">
    <el-row :gutter="10">
      <el-col :span="20">
        <el-upload ref="uploadForm"
                   name="files"
                   list-type="picture"
                   :limit = 1
                   :multiple="false"
                   :data="data"
                   :action="uploadUrl"
                   :file-list="files"
                   :on-success="onUploadSuccess"
                   :on-error="onUploadError"
                   :on-progress="onUploading"
                   :before-upload="beforeUpload"
                   :auto-upload="false">
          <el-button size="small" type="primary">点击上传</el-button>
          <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，建议长图像素尺寸（宽*高）495*780，短图像素尺寸（宽*高）495*580，且不超过200KB</div>
        </el-upload>
      </el-col>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: "CarouselMediaForm",
    props: ["slotData", "isNewlyCreated"],
    methods: {
      getValue() {
        return this.slotData;
      },
      onSubmit() {
        this.$refs.uploadForm.submit();
      },
      onUploadSuccess(response, file, files) {
        if (response === "") {
          this.$message.success("上传成功");
          this.$refs.uploadForm.clearFiles();
          this.fn.closeSlider();
        }
      },
      onUploadError(error, file, files) {
        let msg = "";
        if (file.size >= (1024 * 200)) {
          msg = "，上传的文件不能超过200KB"
        }
        this.$message.error("上传失败" + msg);
      },
      onUploading(event, file, files) {
        this.$message("正在上传，请稍等");
      },
      beforeUpload(file) {
        let flat = true;
        if (file.type != "image/png" && file.type != "image/jpeg") {
          this.$message.error("只能上传jpg/png文件");
          flat = false;
        }
        if (file.size > 1024*200) {
          this.$message.error("上传的文件不能超过200KB");
          flat = false;
        }
        return flat;
      }
    },
    computed: {
      data: function () {
        return {
          id: this.slotData.id
        };
      }
    },
    data() {
      return {
        uploadUrl: "/djbackoffice/system/hot-products/updateMedia",
        files: []
      }
    }
  };
</script>
