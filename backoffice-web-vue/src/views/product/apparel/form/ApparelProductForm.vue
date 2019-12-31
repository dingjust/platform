<template>
  <div>
    <el-form ref="form" :model="slotData">
      <el-card class="box-card">
        <el-row class="info-title-row">
          <div class="info-title">
            <h6 class="info-title_text">基本信息</h6>
          </div>
        </el-row>
        <apparel-product-basic-form :slot-data="slotData" :read-only="false">
        </apparel-product-basic-form>
        <el-divider></el-divider>
        <el-row class="info-title-row">
          <h6 class="info-title_text">选择品类：</h6>
        </el-row>
        <apparel-product-categories-form :slot-data="slotData"></apparel-product-categories-form>
        <el-divider></el-divider>
        <apparel-product-colors-form :slot-data="slotData">
        </apparel-product-colors-form>
        <el-divider></el-divider>
        <apparel-product-sizes-form :slot-data="slotData">
        </apparel-product-sizes-form>
        <el-divider></el-divider>
        <apparel-product-images-form :slot-data="slotData" :read-only="readOnly">
        </apparel-product-images-form>
      </el-card>
      <div class="pt-2"></div>
      <div class="pt-2"></div>
      <el-card class="box-card">
        <apparel-product-price-form :slot-data="slotData">
        </apparel-product-price-form>
      </el-card>
      <div class="pt-2"></div>
      <el-card class="box-card">
        <apparel-product-attributes-form :slot-data="slotData" :read-only="readOnly">
        </apparel-product-attributes-form>
      </el-card>
      <el-row type="flex" justify="center" class="product-form-row">
        <el-button class="product-form-btn" @click="onUpdate()" v-if="this.slotData.code!=null&&this.slotData.code!=''">
          更新产品信息</el-button>
        <el-button class="product-form-btn" @click="onCreate()" v-if="this.slotData.code==null||this.slotData.code==''">
          确认创建产品</el-button>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import ApparelProductImagesForm from './ApparelProductImagesForm';
  import ApparelProductBasicForm from './ApparelProductBasicForm';
  import ApparelProductVariantsForm from './ApparelProductVariantsForm';
  import ApparelProductAttributesForm from './ApparelProductAttributesForm';
  import ApparelProductCategoriesForm from './ApparelProductCategoriesForm';
  import ApparelProductColorsForm from './ApparelProductColorsForm';
  import ApparelProductSizesForm from './ApparelProductSizesForm';
  import ApparelProductPriceForm from './ApparelProductPriceForm';

  export default {
    name: 'ApparelProductFrom',
    components: {
      ApparelProductImagesForm,
      ApparelProductBasicForm,
      ApparelProductVariantsForm,
      ApparelProductAttributesForm,
      ApparelProductCategoriesForm,
      ApparelProductColorsForm,
      ApparelProductSizesForm,
      ApparelProductPriceForm
    },
    props: ['slotData', 'readOnly'],
    methods: {
      onUpdate() {
        if (this.slotData.images == null || this.slotData.images.length == 0) {
          this.$message.error('请上次产品主图');
          return
        }
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
      async _Update() {
        this.formData = Object.assign({}, this.slotData);
        this.slotData.variants = [];
        this.steppedPrices = [];
        const url = this.apis().updateOfApparelProduct(this.slotData.code);
        const result = await this.$http.put(url, this.slotData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success('更新基本信息成功');
        this.$router.go(-1);
      },
      onCreate() {
        if (this.slotData.images == null || this.slotData.images.length == 0) {
          this.$message.error('请上次产品主图');
          return
        }
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
      async _Create() {
        this.formData = Object.assign({}, this.slotData);
        const url = this.apis().createApparelProduct();
        const result = await this.$http.post(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('产品创建成功，产品编号： ' + result);
        // this.$set(this.slotData, 'code', result);
        this.$router.go(-1);
      }
    },
    computed: {},
    data() {
      return {
        imagesDialogVisible: false,
        basicDialogVisible: false,
        variantsDialogVisible: false,
        attributesDialogVisible: false,
        formData: {}
      }
    }
  }

</script>
<style>
  .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
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
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
  }

  .product-form-row {
    margin-top: 20px;
  }

</style>
