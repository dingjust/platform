<template>
  <div>
    <el-row class="info-title-row" type="flex" align="center" justify="space-between">
      <h6 class="info-title_text">上传图片：</h6>
      <h6 class="info-title_info">大小不超过5m一张，最多5张主图,图像分辨率为180X180</h6>
    </el-row>
    <el-tabs v-model="activeName" class="product-images-form-tab">
      <el-tab-pane label="上传图片" name="images">
        <images-upload class="product-images-form-upload" :slot-data="slotData.images" />
      </el-tab-pane>
      <el-tab-pane label="上传图片详情" name="detailImages">
        <images-upload class="product-images-form-upload" :slot-data="slotData.details" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import ImagesUpload from '@/components/custom/ImagesUpload';

  export default {
    name: "ApparelProductImagesForm",
    props: ["slotData", "readOnly"],
    components: {
      ImagesUpload,
    },
    computed: {

    },
    methods: {

    },
    data() {
      return {
        activeName: 'images'
      };
    },
    created() {}
  };

</script>
<style>
  .product-images-form-tab .el-tabs__active-bar {
    background-color: #ffd60c;
  }

  .product-images-form-tab .el-tabs__item.is-active {
    color: #ffd60c;
  }

  .product-images-form-tab .el-tabs__item:hover {
    color: #ffd60c;
    cursor: pointer;
  }

  .product-images-form-tab .el-radio-button--small .el-radio-button__inner {
    margin-left: 5px;
    margin-right: 5px;
    border: 0px;
  }

  .info-title_info {
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-size: 10px;
  }

  .product-images-form-upload {
    margin-left: 50px;
  }

  .product-images-form-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .product-images-form-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }
  
</style>
