<template>
  <div class="animated fadeIn">
    <el-form :model="slotData" ref="dynamicValidateForm" label-width="100px" class="demo-dynamic">
      <el-form-item
        v-for="(info, index) in slotData.infos"
        :label="'步骤'"
        :key="index"
      >
        <operation-course-image-form ref="imageForm"
                                     :slot-data="info"
                                     :read-only="readOnly"
                                      @removeDomain="removeDomain(info)">
        </operation-course-image-form>

      </el-form-item>
      <el-button v-if="readOnly" @click="addDomain">新增步骤</el-button>
    </el-form>
  </div>
</template>

<script>
  import OperationCourseImageForm from './OperationCourseImageForm';
  export default {
    name: 'OperationCourseTitleForm',
    props: ['slotData', 'readOnly'],
    components: {
      OperationCourseImageForm,
    },
    methods: {
      onBeforeUpload(file) {
        if (file.size > 1024 * 1024 * 10) {
          this.$message.error('上传的文件不允许超过10M');
          return false;
        }

        return true;
      },
      onSuccess(response,info) {
        info.meida = response;
      },
      async handleRemove(info) {
        // TODO: 自定义删除方法（删除图片之前，清理product的others属性
        // const url = this.apis().removeMedia(this.slotData.media.id);
        // const result = await this.$http.delete(url);
        info.media = {};
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
      removeDomain(item) {
        var index = this.slotData.infos.indexOf(item)
        if (index !== -1) {
          this.slotData.infos.splice(index, 1)
        }
      },
      addDomain() {
        let info = {
          index:1,
          name:"",
          media:{},
        }
        info.index = this.slotData.infos.length+1;
        this.slotData.infos.push(info);
      }
    },
    computed: {
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
        dialogVisible: false
      }
    },
  };
</script>
