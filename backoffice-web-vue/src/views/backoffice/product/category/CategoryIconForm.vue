<template>
  <div class="animated fadeIn">
    <el-row :gutter="10">
      <el-col :span="20">
        <el-upload ref="uploadForm"
                   name="files"
                   list-type="picture"
                   :limit=1
                   :data="data"
                   :multiple="false"
                   :action="uploadUrl"
                   :file-list="files"
                   :on-success="onUploadSuccess"
                   :on-error="onUploadError"
                   :on-progress="onUploading"
                   :auto-upload="false">
          <el-button size="small" type="primary">点击上传图标</el-button>
          <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过5MB</div>
        </el-upload>
      </el-col>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: "CategoryIconForm",
    props: ["slotData"],
    methods: {
      getValue() {
        return this.slotData;
      },
      onSubmit() {
        console.log(this.slotData);
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
        if (file.size >= (1024 * 1024 * 5)) {
          msg = "，上传的文件不能超过5MB"
        }
        this.$message.error("上传失败" + msg);
      },
      onUploading(event, file, files) {
        this.$message("正在上传，请稍等");
      }
    },
    computed: {
      data: function () {
        return {
          code: this.slotData.code
        }
      }
    },
    data() {
      return {
        uploadUrl: "/djbackoffice/product/category/uploadIcon",
        files: []
      }
    }
  };
</script>
