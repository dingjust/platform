<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="12">
          <div class="application-list-title">
            <h6>{{this.id ? '应用信息' : '添加应用'}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <div style="margin-left: 20px">
        <el-form ref="form" :model="formData" label-width="80px" label-position="left" :hide-required-asterisk="true">
          <application-basic-info ref="basicInfo" :formData="formData" />
          <application-develop-info :formData="formData" />
        </el-form>
      </div>
      <el-row type="flex" justify="center" :gutter="50">
        <el-button class="sumbit-btn" @click="onSave">{{this.id ? '保存' : '添加'}}</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import ApplicationBasicInfo from './info/ApplicationBasicInfo'
import ApplicationDevelopInfo from './info/ApplicationDevelopInfo'
export default {
  name: 'ApplicationManagementForm',
  props: ['id'],
  components: {
    ApplicationBasicInfo,
    ApplicationDevelopInfo
  },
  methods: {
    onSave () {
      if (this.$refs.basicInfo.isImgUpload()) {
        this.$message.warning('应用图片正在上传当中，请稍后再试！');
        return;
      }
      this.$refs.form.validate((valid) => {
        if (valid) {
          this._onSave();
        } else {
          this.$message.error('请完善表单信息！');
        }
      })
    },
    async _onSave () {
      // 整理提交数据
      let data = {
        id: this.formData.id ? this.formData.id : null,
        appName: this.formData.appName,
        appBigImg: this.formData.appBigImg.length > 0 ? this.formData.appBigImg[this.formData.appBigImg.length - 1] : {},
        appSmallImg: this.formData.appSmallImg.length > 0 ? this.formData.appSmallImg[this.formData.appSmallImg.length - 1] : {}
      }

      if (this.formData.iosCheck) {
        data.iosDownloadUrl = this.formData.iosDownloadUrl;
        data.bundleId = this.formData.bundleId;
        data.bundleTestId = this.formData.bundleTestId;
        data.universalLinks = this.formData.universalLinks;
      }

      if (this.formData.androidCheck) {
        data.androidDownloadUrl = this.formData.androidDownloadUrl;
        data.appSignature = this.formData.appSignature;
        data.appPackageName = this.formData.appPackageName;
      }

      const url = this.apis().createApplication();
      const result = await this.$http.post(url, data);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.$message.success('添加应用成功！');
        this.$router.push('/miscs/application');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('添加应用失败！');
      }
    },
    validateField (name) {
      this.$refs.form.validateField(name);
    },
    async getDetail () {
      const id = this.id;
      const url = this.apis().getApplicationDetail(id);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code ===  1) {
        this.formData = Object.assign(this.formData, result.data);
        this.formData.appBigImg = [result.data.appBigImg];
        this.formData.appSmallImg = [result.data.appSmallImg];
        if (result.data.iosDownloadUrl) {
          this.formData.iosCheck = true;
        } 
        if (result.data.androidDownloadUrl) {
          this.formData.androidCheck = true;
        } 
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      }
    }
  },
  data () {
    return {
      formData: {
        appName: '',
        appBigImg: [],
        appSmallImg: [],
        iosDownloadUrl: '',
        bundleId: '',
        bundleTestId: '',
        universalLinks: '',
        androidDownloadUrl: '',
        appSignature: '',
        appPackageName: '',
        iosCheck: false,
        androidCheck: false
      }
    }
  },
  watch: {
    'formData.appBigImg': function (n, o) {
      this.validateField('appBigImg');
    },
    'formData.appSmallImg': function (n, o) {
      this.validateField('appSmallImg');
    }
  },  
  created () {
    if (this.id) {
      this.getDetail();
    }
  }
}
</script>

<style scoped>
  .application-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .sumbit-btn {
    width: 100px;
    color: #606266;
    background-color: #ffd60c;
  }
</style>