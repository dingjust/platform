<template>
  <div>
    <el-form ref="form" :model="slotData">
      <el-card v-if="isFactory()" class="box-card product-card-1">
        <el-row type="flex" align="middle">
          <el-col :span="3">
              <h6 class="info-input-prepend">
                货品类型
                <span style="color:red;">*</span>
              </h6>
          </el-col>
          <el-col :span="8">
            <el-form-item prop="productType" :rules="[
                { required: true, message: '请选择货品类型', trigger: 'change'}]">
              <el-checkbox-group v-model="slotData.productType">
                <template v-for="type in productTypes">
                  <el-checkbox :label="type.code" :disabled="isDisabled(type.code)">{{type.name}}</el-checkbox>
                </template>
              </el-checkbox-group>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <h6 class="product-card-1_text">
              注：库存尾货不能和现货、期货同时选择
            </h6>
          </el-col>
        </el-row>
      </el-card>
      <el-card class="box-card">
        <el-row class="info-title-row">
          <div class="info-title">
            <h6 class="info-title_text">基本信息</h6>
          </div>
        </el-row>
        <apparel-product-basic-form :slot-data="slotData" :read-only="false" :isRead="isRead">
        </apparel-product-basic-form>
        <el-divider></el-divider>
        <!--<el-row class="info-title-row">-->
          <!--<h6 class="info-title_text">选择品类：</h6>-->
        <!--</el-row>-->
        <!--<apparel-product-categories-form :slot-data="slotData" :isRead="isRead"></apparel-product-categories-form>-->
        <!--<el-divider></el-divider>-->
        <apparel-product-colors-sizes-form :slot-data="slotData" :isRead="isRead"></apparel-product-colors-sizes-form>
        <el-divider></el-divider>
        <!--<apparel-product-sizes-form :slot-data="slotData" :isRead="isRead"></apparel-product-sizes-form>-->
        <!--<el-divider></el-divider>-->
        <apparel-product-images-form :slot-data="slotData" :read-only="readOnly" :isRead="isRead">
        </apparel-product-images-form>
      </el-card>
      <div v-if="isShowSpotPrices()">
        <div class="pt-2"></div>
        <el-card class="box-card">
          <apparel-product-spot-price-form :slot-data="slotData" :isRead="isRead"></apparel-product-spot-price-form>
        </el-card>
      </div>
     <div v-if="isShowPrices()">
       <div class="pt-2"></div>
       <el-card class="box-card">
         <apparel-product-price-form :slot-data="slotData" :isRead="isRead"></apparel-product-price-form>
       </el-card>
     </div>
      <!--<el-card class="box-card">-->
        <!--<apparel-product-attributes-form :slot-data="slotData" :read-only="readOnly" :isRead="isRead">-->
        <!--</apparel-product-attributes-form>-->
      <!--</el-card>-->
      <el-row type="flex" justify="center" class="product-form-row">
        <el-button class="product-form-btn" @click="onUpdate()"
          v-if="this.slotData.code!=null&&this.slotData.code!=''&&!isRead">更新产品信息</el-button>
        <el-button class="product-form-btn" @click="onCreate()"
          v-if="(this.slotData.code==null||this.slotData.code=='')&&!isRead">确认创建产品</el-button>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('ApparelProductsModule');

  import ApparelProductImagesForm from './ApparelProductImagesForm';
  import ApparelProductBasicForm from './ApparelProductBasicForm';
  import ApparelProductVariantsForm from './ApparelProductVariantsForm';
  import ApparelProductAttributesForm from './ApparelProductAttributesForm';
  import ApparelProductCategoriesForm from './ApparelProductCategoriesForm';
  import ApparelProductColorsForm from './ApparelProductColorsForm';
  import ApparelProductSizesForm from './ApparelProductSizesForm';
  import ApparelProductPriceForm from './ApparelProductPriceForm';
  import ApparelProductColorsSizesForm from './ApparelProductColorsSizesForm';
  import ApparelProductSpotPriceForm from "./ApparelProductSpotPriceForm";

  export default {
    name: 'ApparelProductFrom',
    components: {
      ApparelProductSpotPriceForm,
      ApparelProductColorsSizesForm,
      ApparelProductImagesForm,
      ApparelProductBasicForm,
      ApparelProductVariantsForm,
      ApparelProductAttributesForm,
      ApparelProductCategoriesForm,
      ApparelProductColorsForm,
      ApparelProductSizesForm,
      ApparelProductPriceForm
    },
    props: [ 'readOnly', 'isRead'],
    computed: {
      ...mapGetters({
        slotData: 'newFormData'
      })
    },
    mounted () {
      // window.addEventListener('beforeunload', e => this.beforeunloadHandler(e));
    },
    methods: {
      ...mapActions({
        resetFormData: 'resetFormData'
      }),
      isShowSpotPrices () {
        if (this.isFactory() && this.slotData.productType != null &&
          (this.slotData.productType.indexOf('SPOT_GOODS') > -1 || this.slotData.productType.indexOf('TAIL_GOODS') > -1)) {
          return true;
        } else {
          return false;
        }
      },
      isShowPrices () {
        if (this.isFactory() && this.slotData.productType != null &&
          (this.slotData.productType.indexOf('FUTURE_GOODS') > -1)) {
          return true;
        } else {
          return false;
        }
      },
      // beforeunloadHandler (e) {
      //   e = e || window.event
      //   if (e) {
      //     e.returnValue = '关闭提示'
      //   }
      //   return '关闭提示'
      // },
      onUpdate () {
        // if (this.slotData.images == null || this.slotData.images.length == 0) {
        //   this.$message.error('请上次产品主图');
        //   return;
        // }
        this.$refs['form'].validate(valid => {
          if (valid) {
            this._Update();
            return true;
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _Update () {
        this.formData = Object.assign({}, this.slotData);
        this.formData.category = {code: this.slotData.category[1]};
        this.slotData.variants = [];
        this.steppedPrices = [];
        var colorSizes = [];
        this.formData.colorSizes.forEach((item) => {
          var obj = {
            'colorCode': item[0].colorCode,
            'colorName': item[0].color,
            'sizes': []
          };
          if (item[0].previewImg != null && item[0].previewImg.length > 0) {
            obj.previewImg = item[0].previewImg[0];
          }
          item.forEach((item1) => {
            obj.sizes.push({
              'code': item1.sizeCode,
              'name': item1.size,
              'quality': item1.quality
            });
          });
          colorSizes.push(obj);
        });
        this.formData.colorSizes = colorSizes;
        const url = this.apis().updateOfApparelProduct(this.slotData.code);
        const result = await this.$http.put(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('更新产品信息成功');
        this.$router.go(-1);
      },
      onCreate () {
        // if (this.slotData.images == null || this.slotData.images.length == 0) {
        //   this.$message.error('请上次产品主图');
        //   return;
        // }
        this.$refs['form'].validateField('category');
        this.$refs['form'].validate(valid => {
          if (valid) {
            this._Create();
            return true;
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _Create () {
        this.formData = Object.assign({}, this.slotData);
        this.formData.category = {code: this.slotData.category[1]};
        var colorSizes = [];
        this.formData.colorSizes.forEach((item) => {
          var obj = {
            'colorCode': item[0].colorCode,
            'colorName': item[0].color,
            'sizes': []
          };
          if (item[0].previewImg != null && item[0].previewImg.length > 0) {
            obj.previewImg = item[0].previewImg[0];
          }
          item.forEach((item1) => {
            obj.sizes.push({
              'code': item1.sizeCode,
              'name': item1.size,
              'quality': item1.quality
            });
          });
          colorSizes.push(obj);
        });
        this.formData.colorSizes = colorSizes;
        const url = this.apis().createApparelProduct();
        const result = await this.$http.post(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('产品创建成功，产品编号： ' + result.code);
        // this.$set(this.slotData, 'code', result);
        this.$router.go(-1);
      },
      isDisabled (typeCode) {
        var flag = false;
        switch (typeCode) {
          case 'SPOT_GOODS':
            if (this.slotData.productType.indexOf('TAIL_GOODS') > -1) {
              flag = true;
            }
            break;
          case 'FUTURE_GOODS':
            if (this.slotData.productType.indexOf('TAIL_GOODS') > -1) {
              flag = true;
            }
            break;
          case 'TAIL_GOODS':
            if (this.slotData.productType.indexOf('SPOT_GOODS') > -1 || this.slotData.productType.indexOf('FUTURE_GOODS') > -1) {
              flag = true;
            }
            break;
        }
        return flag;
      }
    },
    data () {
      return {
        productTypes: this.$store.state.EnumsModule.ProductTypes,
        imagesDialogVisible: false,
        basicDialogVisible: false,
        variantsDialogVisible: false,
        attributesDialogVisible: false,
        formData: {}
      };
    },
    destroyed () {
      this.resetFormData();
    //   window.removeEventListener('beforeunload', e => this.beforeunloadHandler(e))
    }
  };
</script>
<style scoped>
  .info-title {
    width: 100%;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 14px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
  }

  .info-title-row {
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

  .info-input-prepend2 {
    display: inline-block;
    margin: 0 5px;
    width: 20px;
    font-size: 12px;
    color: rgba(0, 0, 0, 0.45);
  }

  .product-form-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 150px;
  }

  .product-form-row {
    margin-top: 20px;
  }

  .product-card-1 {
    margin-bottom: 10px;
  }

  .product-card-1_text{
    color: red;
  }

  /deep/ .el-form-item--mini.el-form-item, .el-form-item--small.el-form-item{
    margin-bottom: 0px;
  }
</style>
