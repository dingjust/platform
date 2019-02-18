<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateBase">编辑</el-button>
        </span>
      </div>
      <product-base-form :slot-data="slotData"
                         :read-only="true"
                         :is-newly-created="isNewlyCreated">
      </product-base-form>
    </el-card>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品图片</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateMedias">编辑</el-button>
        </span>
      </div>
      <product-medias-form ref="productMediasForm"
                           :slot-data="slotData"
                           :is-newly-created="isNewlyCreated">
      </product-medias-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品颜色/尺码</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateVariants">编辑</el-button>
        </span>
      </div>
      <product-variants-form ref="productVariantsForm"
                             :slot-data="slotData"
                             :read-only="true"
                             :is-newly-created="isNewlyCreated">
      </product-variants-form>
    </el-card>
    <!--<div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>库存</span>
        &lt;!&ndash; TODO: <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateInventory">编辑</el-button>
        </span>&ndash;&gt;
      </div>
      <product-stock-levels-form ref="productStockLevelsForm"
                                 :slot-data="slotData"
                                 :read-only="true"
                                 :is-newly-created="isNewlyCreated">
      </product-stock-levels-form>
    </el-card>-->

    <div class="pt-2"></div>
    <el-row :gutter="10" v-show="!preview">
      <el-col :span="24">
        <el-button class="btn-block" size="mini" @click="onClose()">关闭</el-button>
      </el-col>
    </el-row>

    <el-dialog title="更新基本信息" width="80%"
               :visible.sync="baseFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <product-base-form ref="baseForm"
                         :slot-data="baseData"
                         :read-only="false"
                         :is-newly-created="false">
      </product-base-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="baseFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitBaseForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="更新颜色/尺码" width="60%"
               :visible.sync="variantsFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <product-variants-form ref="variantsForm"
                             :slot-data="variantsData"
                             :read-only="false"
                             :is-newly-created="false">
      </product-variants-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="variantsFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitVariantsForm">确 定</el-button>
      </div>
    </el-dialog>
    <!--<el-dialog title="更新库存" width="80%"
               :visible.sync="inventoryFormDialogVisible" :modal="false">
      <product-specification-form ref="inventoryForm"
                                  :slot-data="inventoryData"
                                  :read-only="false"
                                  :is-newly-created="false">
      </product-specification-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="inventoryFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitInventoryForm">确 定</el-button>
      </div>
    </el-dialog>-->
    <el-dialog title="更新图片" width="80%"
               :visible.sync="mediasFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <product-media-upload-form ref="mediasForm"
                                 :slot-data="mediasData"
                                 :read-only="false">
      </product-media-upload-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="closeMediasForm">取 消</el-button>
        <el-button type="primary" @click="onSubmitMediasForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import ProductBaseForm from './ProductBaseForm';
  import ProductStockLevelsForm from './ProductStockLevelsForm';
  import ProductMediasForm from './ProductMediasForm';
  import ProductSpecificationForm from './ProductSpecificationForm';
  import ProductMediaUploadForm from './ProductMediaUploadForm';
  import ProductVariantsForm from './ProductVariantsForm';

  export default {
    name: 'ProductDetailsPage',
    components: {
      ProductVariantsForm,
      ProductMediaUploadForm,
      ProductSpecificationForm,
      ProductBaseForm,
      ProductMediasForm,
      ProductStockLevelsForm
    },
    props: ['slotData', 'isNewlyCreated', 'preview'],
    methods: {
      refresh() {
        this.$refs['productMediasForm'].refresh();
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
