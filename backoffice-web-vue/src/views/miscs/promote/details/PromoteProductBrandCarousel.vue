<template>
  <div class="product-carousel-style">
    <el-form ref="form" size="mini" label-width="100px">
      <template v-for="index of 4">
        <el-row type="flex" :key="index" style="margin-bottom: 20px">
          <div class="image-cell">
            <h6 class="image-title" :style="index === 1 ? 'color: #F56C6C' : ''">{{(index === 1 ? '*' : '')}} 图片 {{index}}</h6>
            <el-form-item label-width="0px">
              <images-upload-single :formData="carouselData[index - 1].media" @getPicture="getPicture($event, index - 1)" @removePicture="removePicture(index - 1)"/>
              <h6 style="color: #909399;padding-left: 60px;">(1920 * 1080)</h6>
            </el-form-item>
          </div>
          <div class="input-cell">
            <el-form-item label="绑定链接：">
              <el-input v-model="carouselData[index-1].url" size="mini" ></el-input>
            </el-form-item>
            <el-form-item label="颜色1：">
              <el-input v-model="carouselData[index-1].colorValue1" size="mini"></el-input>
            </el-form-item>
            <el-form-item label="颜色2：">
              <el-input v-model="carouselData[index-1].colorValue2" size="mini"></el-input>
            </el-form-item>
          </div>
        </el-row>
      </template>
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
    name: 'PromoteProductBrandCarousel',
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
        for (let i = 0; i < 4 - length; i++) {
          let item = {
            media: {},
            url: '',
            active: true,
            type: 'CT003'
          }
          result.data.push(item);
        }
        this.carouselData = result.data;
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
        // let formData = [];
        // this.carouselData.forEach((item, index) => {
        //   if (JSON.stringify(item.media) != '{}') {
        //     formData.push(item);
        //   }
        // });
        // return;
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
        carouselData: this.$store.state.PromoteProductModule.carouselBrandFormData,
        carouselType: 'CT003'
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
  .image-cell {
    display: flex;
  }

  .image-title {
    margin: 50px 10px 0 0;
  }

  .input-cell {
    margin-top: 0.5em;
    display: flex;
    flex-direction: column;
    flex-grow: 0.5;
  }

 .product-carousel-style {
   padding: 15px;
 }

 .title-style {
   padding-top: 40px;
   padding-right: 10px;
 }

 .input-style {
   margin-top: 35px;
   width: 400px
 }

 .product-carousel-style >>> .el-upload--picture-card {
   width: 192px;
   height: 108px;
   line-height: 108px;
 }

 .product-carousel-style >>> .el-upload-list--picture-card .el-upload-list__item {
   width: 192px;
   height: 108px;
 }
</style>
