<template>
  <div>
    <el-row class="basic-form-row" type="flex" align="top">
      <el-col :span="2">
        <h6 class="info-input-prepend" style="margin-top: 41px;">添加主图<span style="color:red">*</span></h6>
      </el-col>
      <el-col :span="20">
        <el-form-item prop="images" :rules="[
                { required: true, message: '请上传主图', trigger: 'change'}]">
          <images-upload class="product-images-form-upload" :slot-data="slotData.images" :read-only="isRead" :disabled="isRead" :limit="5">
            <template slot="picBtn" slot-scope="props">
              <h6>大小不超过5M/张，且最多5张主图</h6>
            </template>
          </images-upload>
        </el-form-item>

        <!--<h6>大小不超过5M/张</h6>-->
        <!--<h6>最多5张主图</h6>-->
      </el-col>
    </el-row>
    <el-row class="basic-form-row" type="flex" align="top">
      <el-col :span="2">
        <h6 class="info-input-prepend" style="margin-top: 42px;">添加详情图</h6>
      </el-col>
      <el-col :span="20">
        <images-upload class="product-images-form-upload" :slot-data="slotData.details" :read-only="isRead" :disabled="isRead" :limit="8">
          <template slot="picBtn" slot-scope="props">
            <h6>大小不超过5M/张，且最多8张详情图</h6>
          </template>
        </images-upload>
      </el-col>
    </el-row>
    <!--<el-tabs v-model="activeName" class="product-images-form-tab">-->
      <!--<el-tab-pane label="上传图片" name="images">-->
        <!--<images-upload class="product-images-form-upload" :slot-data="slotData.images" :read-only="isRead" :disabled="isRead"/>-->
      <!--</el-tab-pane>-->
      <!--<el-tab-pane label="上传图片详情" name="detailImages">-->
        <!--<images-upload class="product-images-form-upload" :slot-data="slotData.details" :read-only="isRead" :disabled="isRead"/>-->
      <!--</el-tab-pane>-->
    <!--</el-tabs>-->
  </div>
</template>

<script>
  import ImagesUploadText from "../../../../components/custom/ImagesUploadText";
  import ImagesUpload from "../../../../components/custom/ImagesUpload";

  export default {
    name: 'ApparelProductImagesForm',
    props: ['slotData', 'readOnly', 'isRead'],
    components: {
      ImagesUpload,
      ImagesUploadText,
    },
    computed: {

    },
    methods: {

    },
    data () {
      return {
        activeName: 'images'
      };
    },
    created () {}
  };
</script>
<style>
  .basic-form-row {
    padding-left: 30px;
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    /* margin-top: 5px; */
    width: 60px;
    font-size: 12px;
    font-weight: 500;
  }
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
