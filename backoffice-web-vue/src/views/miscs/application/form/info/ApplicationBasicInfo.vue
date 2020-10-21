<template>
  <div>
    <el-row type="flex" :gutter="20">
      <el-col>
        <el-form-item label="基本信息" style="margin-bottom: 0px"></el-form-item>
      </el-col>
    </el-row>
    <el-divider></el-divider> 
    <el-row type="flex" :gutter="20">
      <el-col :span="12">
        <el-form-item label="应用名称" prop="appName" :rules="[{ required: true, message: '必填', trigger: 'change'}]">
          <el-input v-model="formData.appName" />
        </el-form-item>
      </el-col>
      <!-- <el-col :span="12">
        <el-form-item label="英文名称">
          <el-input v-model="formData.englishName" />
          <h6 class="tip-title">
            显示在英文版微信中的名称
          </h6>
        </el-form-item>
      </el-col> -->
    </el-row>
    <!-- <el-row type="flex" :gutter="20">
      <el-col :span="24">
        <el-form-item label="应用简介">
          <el-input type="textarea" v-model="formData.profile"></el-input>
          <h6 class="tip-title">最多80字</h6>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" :gutter="20">
      <el-col :span="24">
        <el-form-item label="英文简介">
          <el-input type="textarea" v-model="formData.englishProfile"></el-input>
          <h6 class="tip-title">最多80字</h6>
        </el-form-item>
      </el-col>
    </el-row> -->
    <!-- <el-row type="flex" :gutter="20">
      <el-col :span="12">
        <el-form-item label="应用官网">
          <el-input v-model="formData.link"></el-input>
          <h6 class="tip-title">
            请填写正确的应用官网，否则可能审核不通过
          </h6>
        </el-form-item>
      </el-col>
    </el-row> -->

    <!-- 28*28logo -->
    <div class="app-smallImg">
      <div style="min-width: 80px">
        <h6 class="title-text">应用图片</h6>
      </div>
      <div style="width: 320px;">
        <el-form-item label="" label-width="0px" prop="appSmallImg"
          :rules="[{ required: true, type: 'array', message: '必填', trigger: 'change'}]">
          <h6 class="tip-title">请上传应用水印图片</h6>
          <h6 class="tip-title">28*28像素，仅支持PNG格式，大小不超过300KB</h6>
          <files-upload :slotData="formData.appSmallImg" :limit="99" :showFile="false" 
                        @changUploading="changUploading($event, 'uploadSmall')"/>
          <div v-if="isSmallUploading" style="margin-top: 10px;">
            <el-progress type="circle" :percentage="25" style="width: 28px;height: 28px;"></el-progress>
          </div>
          <div v-else-if="showImg" style="margin-top: 10px;">
            <img style="width:28px;height: 28px" :src="smallImgUrl" />
          </div>
        </el-form-item>
      </div>
      <div style="display: flex;min-width: 140px">
        <el-divider direction="vertical" ></el-divider>
        <div>
          <h6 class="tip-title" style="margin-top: 5px">参考案例</h6>
          <img style="width: 28px;height: 28px" src="static/img/logo3_28x28.png"/>
        </div>
      </div>
    </div>

    <!-- 108*108logo -->
    <div class="app-bigImg">
      <div style="margin-left: 80px;width: 320px;">
        <el-form-item label="" label-width="0px" prop="appBigImg"
          :rules="[{ required: true, type: 'array', message: '必填', trigger: 'change'}]">
          <h6 class="tip-title">请上传应用高清图片</h6>
          <h6 class="tip-title">108*108像素，仅支持PNG格式，大小不超过300KB</h6>
          <files-upload :slotData="formData.appBigImg" :limit="99" :showFile="false" 
                        @changUploading="changUploading($event, 'uploadBig')"/>
          <div v-if="isBigUploading" style="margin-top: 10px;">
            <el-progress type="circle" :percentage="25" style="width: 108px;height: 108px;" ></el-progress>
          </div>
          <div v-else-if="showBigImg" style="margin-top: 10px;">
            <img style="width: 108px;height: 108px" :src="bigImgUrl" />
          </div>
        </el-form-item>
      </div>
      <div style="display: flex;min-width: 140px">
        <el-divider direction="vertical"></el-divider>
        <div>
          <h6 class="tip-title" style="margin-top: 5px">参考案例</h6>
          <img style="width: 108px;height: 108px" src="static/img/logo3.png"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ImagesUpload, FilesUpload } from '@/components'
export default {
  name: 'ApplicationBasicInfo',
  props: ['formData'],
  components: {
    ImagesUpload,
    FilesUpload
  },
  computed: {
    showBigImg: function () {
      return this.formData.appBigImg.length > 0;
    },
    bigImgUrl: function () {
      return this.formData.appBigImg[this.formData.appBigImg.length - 1].url;
    },
    showImg: function () {
      return this.formData.appSmallImg.length > 0;
    },
    smallImgUrl: function () {
      return this.formData.appSmallImg[this.formData.appSmallImg.length - 1].url;
    }
  },
  methods: {
    isImgUpload () {
      return this.isSmallUploading || this.isBigUploading;
    },
    changUploading (flag, img) {
      if (img === 'uploadBig') {
        this.isBigUploading = flag;
      } else if (img === 'uploadSmall') {
        this.isSmallUploading = flag;
      }
    }
  },
  data () {
    return {
      isSmallUploading: false,
      isBigUploading: false
    }
  }  
}
</script>

<style scoped>
  .app-smallImg {
    display: flex;
  }

  .app-bigImg {
    display: flex;
    margin-top: 10px;
  }

  .tip-title {
    color:#909399;
    /* margin-bottom: 0px; */
  }

  .el-divider--horizontal {
    margin: 0px 0px 20px 0px;
  }

  .el-divider--vertical {
    /* height: 100%; */
    margin: 0 15px;
  }

  .title-text {
    font-size: 14px;
    color: #606266;
  }

  .app-smallImg >>> .el-divider--vertical {
    height: 65px;
  }

  .app-bigImg >>> .el-divider--vertical {
    height: 145px;
  }

  .app-smallImg >>> .el-progress-circle {
    width: 28px!important;
    height: 28px!important;
  }
  
  .app-bigImg >>> .el-progress-circle {
    width: 108px!important;
    height: 108px!important;
  }

</style>