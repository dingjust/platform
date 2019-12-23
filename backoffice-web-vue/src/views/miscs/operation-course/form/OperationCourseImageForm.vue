<template>
  <div class="animated fadeIn">
    <el-form :model="slotData" ref="dynamicValidateForm" label-width="100px" class="demo-dynamic">
        <el-form-item  label="描述">
        <el-input v-model="slotData.description" size="mini" :disabled="!readOnly"></el-input>
        </el-form-item>
      <el-form-item  label="序号">
        <el-input v-model="slotData.index" size="mini" :disabled="!readOnly"></el-input>
      </el-form-item>

      <el-form-item>
        <el-upload
          name="file"
          :disabled="!readOnly"
          :action="mediaUploadUrl"
          list-type="picture-card"
          :data="uploadFormData"
          :before-upload="onBeforeUpload"
          :on-success="onSuccess"
          :headers="headers"
          :file-list="fileList"
          :limit = "1"
          :on-preview="handlePreview"
          :on-remove="handleRemove">
          <i class="el-icon-plus"></i>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible" :modal="false" :close-on-click-modal="false">
          <img width="100%" :src="dialogImageUrl" alt="">
        </el-dialog>
        <el-col :span="10">
          <el-button v-if="readOnly" @click.prevent="removeDomain(info)">删除</el-button>
        </el-col>
      <span>推荐图片上传分辨率为1920*1080</span>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'OperationCourseImageForm',
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
        this.slotData.media = response;
      },
      async handleRemove() {
        //TODO: 自定义删除方法（删除图片之前，清理product的others属性
        const url = this.apis().removeMedia(this.slotData.media.id);
        const result = await this.$http.delete(url);
        this.slotData.media = {};
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        // this.slotData.media = {};
        this.$message.success("删除成功");
      },
      handlePreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      removeDomain(){
        this.$emit('removeDomain', this.slotData);
      },
    },
    computed: {
      fileList:function(){
        let files = [];
        if(this.slotData.media&&this.slotData.media.id){
          let file = {
            id:"",
            url:"",
            artworkUrl:"",
          }
          file.id = this.slotData.media.id;
          file.artworkUrl = this.slotData.media.url;
          file.url = this.slotData.media.url;
          // image.url = '';
          if(this.slotData.media.convertedMedias&&this.slotData.media.convertedMedias.length > 0){
            this.slotData.media.convertedMedias.forEach(convertedMedia=>{
                if(convertedMedia.mediaFormat === 'DefaultProductPreview')
                  file.url = convertedMedia.url;
              }
            )
          }
          files.push(file);
        }
        return files;
      },
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup',
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
        dialogVisible: false,
      }
    },
  };
</script>
