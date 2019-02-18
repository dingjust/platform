<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <el-form ref="collectionsForm" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
        <el-row :gutter="20">
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="名称" prop="name">
                <el-input type="textarea" :rows="2" v-model="slotData.name"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="跳转动作" prop="action">
                <el-input type="textarea" :rows="2" v-model="slotData.action"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-col :span="12">
            <el-form-item label="描述" prop="description">
              <el-input type="textarea" :rows="2" v-model="slotData.description"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="是否启用" prop="active">
              <el-radio-group v-model="slotData.active">
                <el-radio :label="true">启用</el-radio>
                <el-radio :label="false">禁用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-row :gutter="10">
        <el-col :span="24">
          <el-upload ref="uploadForm"
                     name="files"
                     list-type="picture"
                     :limit=1
                     :multiple="false"
                     :data="data"
                     :action="uploadUrl"
                     :file-list="files"
                     :on-success="onUploadSuccess"
                     :on-error="onUploadError"
                     :on-progress="onUploading"
                     :before-upload="beforeUpload"
                     :auto-upload="false">
            <el-button size="small" type="primary">点击上传图片</el-button>
            <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，建议像素尺寸（宽*高）580*300，且不超过200KB</div>
          </el-upload>
        </el-col>
      </el-row>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit">确定</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'CollectionsForm',
    components: {},
    props: ['slotData', 'readOnly'],
    methods: {
      onSubmit() {
        const collectionsForm = this.$refs['collectionsForm'];
        collectionsForm.validate(valid => {
          if (!valid) {
            return false;
          }
          this.$refs.uploadForm.submit();
          return true;
        });
      },
      onUploadSuccess(response, file, files) {
        if (response === '') {
          this.$message.success('上传成功');
          this.$refs.uploadForm.clearFiles();
          this.fn.closeSlider();
        }
      },
      onUploadError(error, file, files) {
        let msg = '';
        if (file.size >= (1024 * 200)) {
          msg = '，上传的文件不能超过200KB'
        }
        this.$message.error('上传失败' + msg);
      },
      onUploading(event, file, files) {
        this.$message('正在上传，请稍等');
      },
      onCancel() {
        this.fn.closeSlider();
      },
      beforeUpload(file) {
        let flat = true;
        if (file.type != 'image/png' && file.type != 'image/jpeg') {
          this.$message.error('只能上传jpg/png文件');
          flat = false;
        }
        if (file.size > 1024*200) {
          this.$message.error('上传的文件不能超过200KB');
          flat = false;
        }
        return flat;
      }
    },
    computed: {
      data: function () {
        return {
          name: this.slotData.name,
          action: this.slotData.action,
          description: this.slotData.description,
          active: this.slotData.active,
          files: this.files
        };
      },
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }

    },
    data() {
      return {
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          action: [{required: true, message: '必填', trigger: 'blur'}]
        },
        uploadUrl: '/djbackoffice/system/collections',
        files: []
      };
    }
  };
</script>
