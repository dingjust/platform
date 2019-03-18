<template>
  <div class="animated fadeIn">
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
          :file-list="slotData.attachments"
          :on-preview="handlePreview"
          :on-remove="handleRemove">
          <i class="el-icon-plus"></i>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible" :modal="false">
          <img width="100%" :src="dialogImageUrl" alt="">
        </el-dialog>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderAttachmentsForm',
    props: ['slotData', 'readOnly'],
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
        // console.log(JSON.stringify(file));
        const result = await this.$http.delete('/djwebservices/media/' + file.id);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        const attachments = this.slotData.attachments || [];
        const index = attachments.indexOf(file);
        attachments.splice(index, 1);

        this.$message.success("删除成功");
      },
      handlePreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      }
    },
    computed: {
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
        };
      },
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    data() {
      return {
        dialogImageUrl: '',
        dialogVisible: false
      }
    },
  };
</script>
