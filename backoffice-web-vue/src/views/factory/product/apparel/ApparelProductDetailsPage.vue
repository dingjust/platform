<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品图片</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateMedias">编辑</el-button>
        </span>
      </div>
      <apparel-product-images-form ref="productImagesForm"
                                   :slot-data="slotData"
                                   :is-newly-created="isNewlyCreated">
      </apparel-product-images-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateBase">编辑</el-button>
        </span>
      </div>
      <apparel-product-base-form :slot-data="slotData"
                                 :read-only="true"
                                 :is-newly-created="isNewlyCreated">
      </apparel-product-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品颜色/尺码</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateVariants">编辑</el-button>
        </span>
      </div>
      <apparel-product-variants-form ref="productVariantsForm"
                                     :slot-data="slotData"
                                     :read-only="true"
                                     :is-newly-created="isNewlyCreated">
      </apparel-product-variants-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>商品属性</span>
   <!--     <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateAttributes">编辑</el-button>
        </span>-->
      </div>
      <apparel-product-attributes-form :slot-data="slotData"
                                 :read-only="true"
                                 :is-newly-created="isNewlyCreated">
      </apparel-product-attributes-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10" v-show="!preview">
      <el-col :span="24">
        <el-button class="btn-block" size="mini" @click="onClose()">关闭</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ApparelProductBaseForm from './ApparelProductBaseForm';
  import ApparelProductImagesForm from './ApparelProductImagesForm';
  import ApparelProductVariantsForm from './ApparelProductVariantsForm';
  import ApparelProductAttributesForm from "./ApparelProductAttributesForm";

  export default {
    name: 'ProductDetailsPage',
    components: {
      ApparelProductImagesForm,
      ApparelProductBaseForm,
      ApparelProductVariantsForm,
      ApparelProductAttributesForm,
    },
    props: ['slotData', 'isNewlyCreated', 'preview'],
    methods: {
      refresh() {
        this.$refs['productVariantsForm'].refresh();
      },
      onClose() {
        this.fn.closeSlider();
      },
      onUpdateBase() {
        Object.assign(this.baseData, this.slotData);
        this.baseFormDialogVisible = true;
      },
      onSubmitBaseForm() {
        let formData = Object.assign({}, this.baseData);

        let staircasePrices = formData.staircasePrices;
        // 按最大值排序
        staircasePrices.sort(function (a, b) {
          if (a.maxQuantity > b.maxQuantity) {
            return 1;
          }
          if (a.maxQuantity < b.maxQuantity) {
            return -1;
          }

          return 0;
        });

        const len = staircasePrices.length;
        if (len > 1) {
          for (let i = 0; i < len - 1; i++) {
            if (staircasePrices[i].maxQuantity > staircasePrices[i + 1].minQuantity) {
              this.$message.error('阶梯价格定义不符合规则【不允许有重叠价格区间】');
              return false;
            }
          }
        }

        this.$refs['baseForm'].validate(valid => {
          if (valid) {
            if (formData.price <= 0) {
              this.$message.error('供货价必须大于0');
              return false;
            }

            this._onSubmitBaseForm(formData);

            return true;
          }

          return false;
        });
      },
      async _onSubmitBaseForm(formData) {
        const result = await this.$http.put('/djbackoffice/product', formData);

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        const product = result;
        this.$message.success('更新成功，产品编码：' + product.code);

        this.baseFormDialogVisible = false;
        this.$set(this.slotData, 'name', this.baseData.name);
        this.$set(this.slotData, 'categories', this.baseData.categories);
        this.$set(this.slotData, 'belongTo', this.baseData.belongTo);
        this.$set(this.slotData, 'material', this.baseData.material);
        this.$set(this.slotData, 'content', this.baseData.content);
        this.$set(this.slotData, 'startingAmount', this.baseData.startingAmount);
        this.$set(this.slotData, 'skuID', this.baseData.skuID);
        this.$set(this.slotData, 'year', this.baseData.year);
        this.$set(this.slotData, 'season', this.baseData.season);
        this.$set(this.slotData, 'placeOfOrigin', this.baseData.placeOfOrigin);
        this.$set(this.slotData, 'brand', this.baseData.brand);
        this.$set(this.slotData, 'price', this.baseData.price);
        this.$set(this.slotData, 'style', this.baseData.style);
        this.$set(this.slotData, 'postageFree', this.baseData.postageFree);
        this.$set(this.slotData, 'gramWeight', this.baseData.gramWeight);
        this.$set(this.slotData, 'staircasePrices', this.baseData.staircasePrices);

        this.refresh();
      },
      onUpdateVariants() {
        this.variantsData.code = this.slotData.code;
        this.variantsData.name = this.slotData.name;
        this.variantsFormDialogVisible = true;
      },
      onSubmitVariantsForm() {
        let form = this.$refs['variantsForm'];

        let formData = {
          code: this.slotData.code,
          variants: []
        };

        const _entries = form.getValue();
        for (let i = 0; i < _entries.length; i++) {
          formData.variants.push({
            color: _entries[i].color.code,
            size: _entries[i].size.code
          })
        }

        this._onSubmitVariantsForm(formData);
      },
      async _onSubmitVariantsForm(formData) {
        const result = await this.$http.put('/djbackoffice/product/variants', formData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新成功');
        this.$refs['variantsForm'].doRefresh();
        this.$refs['productVariantsForm'].doRefresh();
        this.variantsFormDialogVisible = false;
      },
      onUpdateInventory() {
        this.inventoryData.code = this.slotData.code;
        this.inventoryFormDialogVisible = true;
      },
      onSubmitInventoryForm() {
      },
      onUpdateMedias() {
        this.mediasData.code = this.slotData.code;
        this.mediasFormDialogVisible = true;
      },
      onSubmitMediasForm() {
        this.$refs['mediasForm'].onSubmit();
      },
      closeMediasForm() {
        if (this.slotData.code != null && this.slotData.code !== '') {
          this.$refs['productMediasForm'].refresh();
          this.mediasFormDialogVisible = false;
        }
      }
    },
    computed: {},
    data() {
      return {
        baseFormDialogVisible: false,
        baseData: {
          id: '',
          code: '',
          name: '',
          categories: [],
          belongTo: {
            uid: '',
            name: ''
          },
          material: '',
          content: '',
          stereotype: '',
          startingAmount: 0,
          skuID: '',
          year: '',
          season: '',
          placeOfOrigin: '',
          brand: '',
          style: '',
          genderGroup: '',
          price: 0,
          suggestedPrice: 0,
          price1: 0,
          price2: 0,
          price3: 0,
          postageFree: '',
          gramWeight: ''
        },
        variantsFormDialogVisible: false,
        variantsData: {
          code: ''
        },
        inventoryFormDialogVisible: false,
        inventoryData: {
          code: ''
        },
        mediasFormDialogVisible: false,
        mediasData: {
          code: '',
          format: ''
        }
      };
    }
  };
</script>
