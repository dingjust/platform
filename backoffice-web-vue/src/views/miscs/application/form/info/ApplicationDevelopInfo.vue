<template>
  <div>
    <el-row type="flex" :gutter="20">
      <el-col>
        <el-form-item label="开发信息" style="margin-bottom: 0px"></el-form-item>
      </el-col>
    </el-row>
    <el-divider></el-divider> 
    <div style="display: flex">
      <div style="min-width: 80px;color: #606266;">
        <h6>应用平台</h6>
      </div>
      <div style="width: 100%">
        <h6 class="tip-title basic-row">请至少选择一个平台</h6>
        <el-checkbox class="basic-row" v-model="formData.iosCheck">ios 应用</el-checkbox>
        <div style="margin-left: 22px">
          <div class="border-container">
            <el-form-item label="AppStore下载地址" prop="iosDownloadUrl" :rules="[{ required: formData.iosCheck, message: '必填', trigger: 'change'}]">
              <el-input v-model="formData.iosDownloadUrl" ></el-input>
            </el-form-item>
            <el-form-item label="Bundle ID" prop="bundleId" :rules="[{ required: formData.iosCheck, message: '必填', trigger: 'change'}]">
              <el-input v-model="formData.bundleId" ></el-input>
            </el-form-item>
            <el-form-item label="测试版本Bundle ID" prop="bundleTestId" :rules="[{ required: formData.iosCheck, message: '必填', trigger: 'change'}]">
              <el-input v-model="formData.bundleTestId" ></el-input>
            </el-form-item>
            <el-form-item label="Universal Links" prop="universalLinks" :rules="[{ required: formData.iosCheck, message: '必填', trigger: 'change'}]">
              <el-input v-model="formData.universalLinks" ></el-input>
            </el-form-item>
          </div>
        </div>
        <el-divider></el-divider> 
        <el-checkbox class="basic-row" v-model="formData.androidCheck">Android 应用</el-checkbox>
        <div style="margin-left: 22px">
          <el-form-item label="应用下载地址" prop="androidDownloadUrl" :rules="[{ required: formData.androidCheck, message: '必填', trigger: 'change'}]">
            <el-input v-model="formData.androidDownloadUrl" ></el-input>
          </el-form-item>
          <el-form-item label="应用签名" prop="appSignature" :rules="[{ required: formData.androidCheck, message: '必填', trigger: 'change'}]">
            <el-input v-model="formData.appSignature" ></el-input>
          </el-form-item>
          <el-form-item label="应用包名" prop="appPackageName" :rules="[{ required: formData.androidCheck, message: '必填', trigger: 'change'}]">
            <el-input v-model="formData.appPackageName" ></el-input>
          </el-form-item>
        </div>
        <el-divider></el-divider> 
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ApplicationDevelopInfo',
  props: ['formData']  
}
</script>

<style scoped>
  .tip-title {
    color:#909399;
    margin-bottom: 0px;
  }

  .basic-row {
    margin-bottom: 10px;
  }

  .el-divider--horizontal {
    margin: 0px 0px 20px 0px;
  }

  .border-container {
    border: 1px solid #DCDFE6;
    padding: 20px;
    margin-bottom: 20px;
  }
</style>