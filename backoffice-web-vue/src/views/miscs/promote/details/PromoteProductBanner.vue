<template>
  <div class="product-carousel-style">
    <el-form ref="form" :inline="true" size="mini">
      <el-row>
        <el-form-item>
          <template slot="label">
            <h6 style="color: #F56C6C" class="title-style">*图片1</h6>
          </template>
          <images-upload-single :formData="carouselData[0].media" @getPicture="getPicture($event, 0)" @removePicture="removePicture(0)"/>
          <h6 style="color: #909399;padding-left: 120px;">(宽高比例 6:1 图片效果最佳)</h6>
        </el-form-item>
        <el-form-item>
          <template slot="label">
            <h6 class="title-style">绑定链接：</h6>
          </template>
          <el-input v-model="carouselData[0].url" placeholder="请输入商品链接" size="mini" class="input-style"></el-input>
        </el-form-item>
      </el-row>
      <el-row>
        <el-form-item>
          <template slot="label">
            <h6 class="title-style">图片2</h6>
          </template>
          <images-upload-single :formData="carouselData[1].media" @getPicture="getPicture($event, 1)" @removePicture="removePicture(1)"/>
          <h6 style="color: #909399;padding-left: 120px;">(宽高比例 6:1 图片效果最佳)</h6>
        </el-form-item>
        <el-form-item>
          <template slot="label">
            <h6 class="title-style">绑定链接：</h6>
          </template>
          <el-input v-model="carouselData[1].url" placeholder="请输入商品链接" size="mini" class="input-style"></el-input>
        </el-form-item>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center">
      <el-button @click="onSubmit" style="background-color: #FFD60C" size="medium">保存并提交</el-button>
    </el-row>
  </div>
</template>

<script>
  import ImagesUpload from '../../../../components/custom/ImagesUpload';
  import ImagesUploadSingle from '../../../../components/custom/ImagesUploadSingle';
  export default {
    name: 'PromoteProductBanner',
    props: [],
    components: {ImagesUploadSingle, ImagesUpload},
    computed: {
    },
    methods: {
      async getCarousel () {
        const type = this.carouselType;
        const url = this.apis().getCarouselsList(type);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        result.data.forEach(item => {
          if (item.media == null) {
            item.media = {};
          }
        })
        const length = result.data.length
        for (let i = 0; i < 2 - length; i++) {
          let item = {
            media: {},
            url: '',
            active: true,
            type: 'CT005'
          }
          result.data.push(item);
        }
        if (length > 0) {
          this.carouselData = result.data;
        }
        this.$emit('returnCount');
      },
      getPicture (picture, index) {
        this.carouselData[index].media = Object.assign({}, picture);
      },
      removePicture (index) {
        this.carouselData[index].media = {};
      },
      async onSubmit () {
        const flag = this.carouselData.some(item => {
          return JSON.stringify(item.media) != '{}';
        })
        if (!flag) {
          this.$message.error('至少要有1张轮播图');
          return;
        }
        const url = this.apis().updateAllCarousels();
        const result = await this.$http.put(url, this.carouselData);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('操作成功');
        this.getCarousel();
        this.$emit('returnCount');
      }
    },
    data () {
      return {
        count: 0,
        carouselData: this.$store.state.PromoteProductModule.bannerFormData,
        carouselType: 'CT005'
      }
    },
    watch: {
      carouselData: {
        handler (val) {
          if (val) {
            this.$emit('operationCount');
          }
        },
        deep: true
      }
    },
    created () {
      this.getCarousel();
      this.$emit('returnCount');
    }
  }
</script>

<style scoped>

  .product-carousel-style {
    padding: 15px;
  }

  .title-style {
    padding-top: 25px;
    padding-right: 10px;
  }

  .input-style {
    margin-top: 18px;
    width: 400px
  }

  /deep/ .el-upload--picture-card {
    width: 400px;
    height: 66px;
    line-height: 66px;
  }

  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    width: 400px;
    height: 66px;
  }
</style>

