<template>
  <div class="requirement-toolbar">
    <el-row>
      <el-form-item prop="title">
        <template slot="label">
          <h6 class="formLabel">主标题:</h6>
        </template>
        <el-input style="width: 200px" placeholder="请输入主标题" v-model="formData.title"></el-input>
      </el-form-item>
      <el-form-item prop="subTitle">
        <template slot="label">
          <h6 class="formLabel">副标题:</h6>
        </template>
        <el-input style="width: 200px" placeholder="请输入副标题" v-model="formData.subTitle"></el-input>
      </el-form-item>
    </el-row>
    <el-row>
      <el-form-item prop="picture">
        <template slot="label">
          <h6 class="formLabel" style="margin: 37px 14px 0px 0px">图片:</h6>
        </template>
        <images-upload-single :formData="formData.picture" @getPicture="getPicture" @removePicture="removePicture"/>
      </el-form-item>
    </el-row>
  </div>
</template>

<script>
    import ImagesUpload from '../../../../components/custom/ImagesUpload';
    import ImagesUploadSingle from '../../../../components/custom/ImagesUploadSingle';
    export default {
      name: 'PromoteProductToolbar',
      components: {ImagesUploadSingle, ImagesUpload},
      props: ['formData'],
      computed: {
      },
      methods: {
        getPicture (picture, index) {
          this.formData.picture = Object.assign({}, picture);
        },
        removePicture (index) {
          this.formData.picture = {};
        }
      },
      data () {
        return {
        }
      }
    }
</script>

<style>
  .requirement-toolbar .formLabel {
    font-size: 12px;display: inline-block;
  }

  .requirement-toolbar .el-range-editor--mini .el-range-separator{
    width: 30px;
  }

</style>
