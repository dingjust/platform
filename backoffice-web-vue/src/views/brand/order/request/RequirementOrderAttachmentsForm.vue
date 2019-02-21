<template>
  <div class="animated fadeIn">
    <div>
      <ul>
        <li v-for="media in slotData.attachments">
          <a :href="media.url" target="_blank">{{media.name}}</a>
          <span @click="onRemove(media)"><i class="el-icon-delete"></i></span>
        </li>
      </ul>
    </div>
    <div style="width: 50%;">
      <el-upload
        ref="uploadForm"
        :action="actionUrl"
        name="file"
        :show-file-list="false"
        :data="data"
        :before-upload="onBeforeUpload"
        :on-remove="onHandleRemove"
        :before-remove="onBeforeRemove"
        :on-success="onSuccess"
        :file-list="uploadingList">
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
      onSubmit() {
        this.$refs.uploadForm.submit();
      },
      onRemove(item) {
        // TODO: 删除
        alert(JSON.stringify(item));
      },
      onBeforeUpload(file) {
        if (file.size > 1024 * 1024 * 10) {
          this.$message.error('上传的文件不允许超过10M');
          return false;
        }

        return true;
      },
      onHandleRemove(file, fileList) {
        console.log(file, fileList);
      },
      onBeforeRemove(file, fileList) {
        return this.$confirm(`确定移除 ${file.name}？`);
      },
      onSuccess(response, file, fileList) {
        console.log(JSON.stringify(response));
        this.slotData.attachments.push(response);
        this.$set(this.slotData, "attachments", this.slotData.attachments);
      }
    },
    computed: {
      data: function () {
        return {
          fileFormat: 'DefaultFileFormat',
        };
      },
      medias: function () {
        // console.log(JSON.stringify(this.slotData.attachments));
        return [{
          id: 1,
          name: 'food.jpeg',
          url: 'https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg?imageMogr2/thumbnail/360x360/format/webp/quality/100'
        }, {
          id: 2,
          name: 'food2.jpeg',
          url: 'https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg?imageMogr2/thumbnail/360x360/format/webp/quality/100'
        }]
      }
    },
    data() {
      return {
        actionUrl: 'https://localhost:9002/djwebservices/v2/apparel-zh/media/file/upload',
        uploadingList: [],
      };
    },
  };
</script>
