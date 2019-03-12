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
      <apparel-product-base-form :slot-data="slotData"
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
      onSubmit() {
        let formData = Object.assign({}, this.slotData);
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
        // console.log(JSON.stringify(staircasePrices));
        const len = staircasePrices.length;
        if (len > 1) {
          for (let i = 0; i < len - 1; i++) {
            if (staircasePrices[i].maxQuantity > staircasePrices[i + 1].minQuantity) {
              this.$message.error('阶梯价格定义不符合规则【不允许有重叠价格区间】');
              return false;
            }
          }
        }
        for (let i = 0; i < len; i++) {
          if (staircasePrices[i].maxQuantity === '' || typeof (staircasePrices[i].maxQuantity) === 'undefined' || staircasePrices[i].minQuantity === '' || typeof (staircasePrices[i].minQuantity) === 'undefined') {
            this.$message.error('阶梯价格定义不符合规则【不允许有空值】');
            return false;
          }
          if (staircasePrices[i].maxQuantity === 0 && staircasePrices[i].minQuantity === 0) {
            this.$message.error('阶梯价格定义不符合规则【最大与最小值不允许同时为0】');
            return false;
          }
        }
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
        let request = this.$http.post;
        if (!this.isNewlyCreated) {
          request = this.$http.put;
        }

        let form = this.$refs['productVariantsForm'];

        const _entries = form.getValue();
        for (let i = 0; i < _entries.length; i++) {
          formData.variants.push({
            color: _entries[i].color.code,
            size: _entries[i].size.code
          })
        }

        const result = await request('/b2b/products/apparel', formData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        const product = result;
        this.$message.success('创建成功，产品编码：' + product.code);

        this.$set(this.slotData, 'id', product.id);
        this.$set(this.slotData, 'code', product.code);

        this.next(1);

        this.$refs['productDetailsPage'].refresh();
      },
      onCancel() {
        this.fn.closeSlider();
      },
      onMediaUpload() {
        this.$refs['productMediaUploadForm'].onSubmit();
        setTimeout(() => {
          this.$refs['productMediasForm'].refresh()
        }, 2000);
      },
      onInventoryUpdate() {
        let form = this.$refs['productVariantsForm'];

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

        this._onInventoryUpdate(formData);
      },
      async _onInventoryUpdate(formData) {
        const result = await this.$http.put('/djbackoffice/product/variants', formData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新颜色/尺码成功，产品编码：' + formData.code);

        this.next(3);

        this.$refs['productDetailsPage'].refresh();
      },
      onClose() {
        this.fn.closeSlider(true);
      },
      next(active) {
        this.active = active;
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
