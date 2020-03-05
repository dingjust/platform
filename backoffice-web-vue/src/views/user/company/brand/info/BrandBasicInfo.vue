<template>
  <div class="animated fadeIn factory-basic">
    <el-row>
      <div class="titleClass">
        <h6>基本信息</h6>
      </div>
    </el-row>
    <div style="margin: 20px 20px 40px 40px">
      <el-row type="flex" justify="start" align="middle">
        <el-col :span="2">
          <h6 style="font-size: 12px">
            上传企业LOGO
          </h6>
        </el-col>
        <el-col :span="18">
          <el-form-item prop="profilePicture">
            <images-upload :limit="1" :slot-data="this.profilePictures" :disabled="true" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" align="bottom" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">公司名称</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{formData.name}}<span
              style="color: red;font-size:8px;margin-left:10px;">({{formData.approvalStatus == 'approved' ? '已认证' : '未认证'}})</span>
          </h6>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" align="bottom" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">联系人<span style="color: red">*</span></h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{formData.contactPerson}}</h6>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">手机号码<span style="color: red">*</span></h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{formData.contactPhone}}</h6>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">座机号码</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{formData.name}}</h6>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" align="bottom" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">地址<span style="color: red">*</span></h6>
          </el-row>
        </el-col>
        <el-col :span="8">
          <h6 class="info-data">{{formData.contactAddress.details}}</h6>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations
  } = createNamespacedHelpers('BrandsModule');

  import ImagesUpload from '../../../../../components/custom/ImagesUpload';

  export default {
    name: 'BrandBasicInfo',
    props: ['formData', 'readOnly'],
    components: {
      ImagesUpload
    },
    methods: {
    },
    data() {
      return {
        profilePictures: [],
      };
    },
    watch: {

    },
    created() {
      console.log(this.formData);
      if (this.formData.profilePicture != null) {
        this.profilePictures = [this.formData.profilePicture];
      }
    }
  };

</script>

<style scoped>
  .factory-basic .rowClass {
    margin-top: 20px;
  }

  .titleClass {
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

  .el-col-24 {
    width: auto;
  }

  /deep/ .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 70px;
    font-weight: bold;
    font-size: 10px;
  }

  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 12px;
    /*font-weight: bold;*/
  }

  .el-input--mini .el-input__inner {
    width: 100%;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .info-data {
    font-size: 12px;
    padding-top: 5px;
    /* padding-bottom: 2px; */
  }

  .info-row {
    margin-bottom: 10px;
  }

</style>
