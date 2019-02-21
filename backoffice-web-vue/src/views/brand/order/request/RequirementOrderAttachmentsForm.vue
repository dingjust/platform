<template>
  <div class="animated fadeIn">
    <div v-if="slotData.attachments">
      <ul>
        <li v-for="(media, index) in slotData.attachments">
          <a :href="media.url" target="_blank">{{media.name}}</a>
          <span @click="onRemove(media, index)"><i class="el-icon-delete"></i></span>
        </li>
      </ul>
    </div>
    <div style="width: 50%;">
      <el-upload
        :action="mediaUploadUrl"
        name="file"
        :show-file-list="false"
        :data="uploadFormData"
        :before-upload="onBeforeUpload"
        :on-success="onSuccess"
        :file-list="files">
        <el-button size="small" type="primary">选择</el-button>
        <div slot="tip" class="el-upload__tip">单个文件不允许超过10M</div>
      </el-upload>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderAttachmentsForm',
    props: ['slotData', 'isNewlyCreated'],
    methods: {
      async onRemove(item, index) {
        const result = await this.$http.delete('/djwebservices/media/' + item.id);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        // 从列表删除
        this.slotData.attachments.splice(index, 1);
      },
      onBeforeUpload(file) {
        if (file.size > 1024 * 1024 * 10) {
          this.$message.error('上传的文件不允许超过10M');
          return false;
        }

        return true;
      },
      onSuccess(response) {
        this.slotData.attachments.push(response);
        this.$set(this.slotData, "attachments", this.slotData.attachments);
      }
    },
    computed: {
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
        };
      },
    },
    data() {
      return {
        files: [],
      };
    },
  };
</script>
