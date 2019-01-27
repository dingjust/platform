<template>
  <div class="animated fadeIn">
    <el-row :gutter="10">
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
          <el-button slot="trigger" size="small" type="primary">选取图片</el-button>
          <el-button style="margin-left: 10px;" size="small" type="success" @click="onSubmit">上传到服务器</el-button>
          <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过500kb</div>
        </el-upload>
      </el-col>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: "ConsignmentProgressMediasUploadForm",
    props: ["slotData", "isNewlyCreated"],
    inject:['refresh'],
    methods: {
      onSubmit() {
        this.$refs.uploadForm.submit();
      },
      onUploadSuccess(response, file, files) {
        if (response === "") {
          this.$message.success("上传成功");
          this.$refs.uploadForm.clearFiles();
          setTimeout(() => {
            this.refresh();
          }, 500);
        }
      },
      onUploadError(error, file, files) {
        let msg = "";
        this.$message.error("上传失败" + msg);
      },
      onUploading(event, file, files) {
        this.$message("正在上传，请稍等");
      },
      /*beforeUpload(file) {
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
      }*/
    },
    computed: {
      data: function () {
        return {
          id: this.slotData.id,
          files: this.files,
        };
      }
    },
    data() {
      return {
        uploadUrl: "/djbackoffice/consignment/progress/media/upload",
        files: []
      }
    }
  };
</script>
