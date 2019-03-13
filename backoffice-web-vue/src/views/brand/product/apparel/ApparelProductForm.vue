<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>图片</span>
      </div>
      <apparel-product-images-form :slot-data="slotData"
                                   :is-newly-created="isNewlyCreated">
      </apparel-product-images-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <apparel-product-base-form ref="productBaseForm" :slot-data="slotData"
                                 :is-newly-created="isNewlyCreated">
      </apparel-product-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品颜色/尺码</span>
      </div>
      <apparel-product-variants-form :slot-data="slotData"
                                     :is-newly-created="isNewlyCreated">
      </apparel-product-variants-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品属性</span>
      </div>
      <apparel-product-attributes-form :slot-data="slotData"
                                       :is-newly-created="isNewlyCreated">
      </apparel-product-attributes-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini" @click="onSubmit">保存</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('BrandApparelProductsModule');

  import ApparelProductImagesForm from './ApparelProductImagesForm';
  import ApparelProductBaseForm from './ApparelProductBaseForm';
  import ApparelProductVariantsForm from './ApparelProductVariantsForm';
  import ApparelProductAttributesForm from './ApparelProductAttributesForm';
  import ApparelProductDetailsPage from './ApparelProductDetailsPage';

  export default {
    name: 'ProductForm',
    props: ['slotData'],
    components: {
      ApparelProductImagesForm,
      ApparelProductBaseForm,
      ApparelProductVariantsForm,
      ApparelProductAttributesForm,
      ApparelProductDetailsPage
    },
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit() {
        let formData = Object.assign({}, this.slotData);
        this.$refs['productBaseForm'].validate(valid => {
          if (valid) {
            if (formData.price <= 0) {
              this.$message.error('供货价必须大于0');
              return false;
            }

            this._onSubmit(formData);

            return true;
          }

          return false;
        });
      },
      async _onSubmit(formData) {
        // console.log(JSON.stringify(formData))
        const result = await this.$http.post('/b2b/products/apparel/create', formData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('创建成功，产品编码：' + result.code);

        this.$set(this.slotData, 'id', result.id);
        this.$set(this.slotData, 'code', result.code);

        this.refresh();
        this.fn.closeSlider();
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        active: 0,
        mediasFormDialogVisible: false
      };
    }
  };
</script>
