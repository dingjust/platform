<template>
  <div>
    <el-card class="box-card">
      <el-row class="info-title-row">
        <div class="info-title">
          <h6 class="info-title_text">基本信息</h6>
        </div>
      </el-row>
      <apparel-product-basic-form ref="basicForm" :slot-data="slotData" :read-only="false">
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
      <el-row class="info-title-row">
        <!-- <div class="info-title"> -->
        <h6 class="info-title_text">上传图片</h6>
        <!-- </div> -->
      </el-row>
      <el-divider></el-divider>
      <apparel-product-images-form ref="imagesForm" :slot-data="slotData" :read-only="readOnly">
      </apparel-product-images-form>
    </el-card>
    <div class="pt-2"></div>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品颜色/尺码</span>
        <span v-if="!isTenant()">
          <el-button class="float-right" type="text" @click="onUpdateVariants">编辑</el-button>
        </span>
      </div>
      <apparel-product-variants-form ref="variantsForm" :slot-data="slotData" :read-only="readOnly">
      </apparel-product-variants-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品属性</span>
        <span v-if="!isTenant()">
          <el-button class="float-right" type="text" @click="onUpdateAttributes">编辑</el-button>
        </span>
      </div>
      <apparel-product-attributes-form ref="attributesForm" :slot-data="slotData" :read-only="readOnly">
      </apparel-product-attributes-form>
    </el-card>
    <el-dialog v-if="!isTenant()" title="更新基本信息" :modal="false" :visible.sync="basicDialogVisible" :show-close="false"
      append-to-body width="50%">
      <apparel-product-basic-form ref="basicForm1" :slot-data="slotData" :read-only="false">
      </apparel-product-basic-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="basicDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onBasicFormSubmit">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog v-if="!isTenant()" title="更新颜色/尺码" :modal="false" :visible.sync="variantsDialogVisible"
      :show-close="false" append-to-body width="50%">
      <apparel-product-variants-form ref="variantsForm1" :slot-data="slotData" :read-only="false">
      </apparel-product-variants-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="variantsDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onVariantsFormSubmit">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog v-if="!isTenant()" title="更新属性" :modal="false" :visible.sync="attributesDialogVisible"
      :show-close="false" append-to-body width="50%">
      <apparel-product-attributes-form ref="attributesForm1" :slot-data="slotData" :read-only="false">
      </apparel-product-attributes-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="attributesDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onAttributesFormSubmit">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog v-if="!isTenant()" title="更新图片" :modal="false" :visible.sync="imagesDialogVisible" :show-close="false"
      append-to-body width="50%">
      <apparel-product-images-form ref="imagesForm2" :slot-data="slotData" :read-only="false">
      </apparel-product-images-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="imagesDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateImagesSubmit">确 定</el-button>
      </span>
    </el-dialog>
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

  export default {
    name: 'ApparelProductFrom',
    components: {
      ApparelProductImagesForm,
      ApparelProductBasicForm,
      ApparelProductVariantsForm,
      ApparelProductAttributesForm,
      ApparelProductCategoriesForm,
      ApparelProductColorsForm,
      ApparelProductSizesForm
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        // TODO: validation
        return true;
        // return this.$refs['basicForm'].validate(callback);
      },
      onUpdateImages() {
        this.formData = Object.assign({}, this.slotData);
        this.imagesDialogVisible = true;
      },
      async updateImagesSubmit() {
        const url = this.apis().updateImagesOfApparelProduct(this.slotData.code);
        const result = await this.$http.put(url, this.slotData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新图片成功');
        this.imagesDialogVisible = false;
      },
      onUpdateBasic() {
        this.formData = Object.assign({}, this.slotData);
        this.basicDialogVisible = true;
      },
      onBasicFormSubmit() {
        this.$refs['basicForm1'].validate(valid => {
          if (valid) {
            this._onUpdateBasic();
            this.basicDialogVisible = false;
            return true;
          }

          return false;
        });
      },
      async _onUpdateBasic() {
        const url = this.apis().updateBasicOfApparelProduct(this.slotData.code);
        const result = await this.$http.put(url, this.slotData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新基本信息成功');
      },
      onUpdateVariants() {
        this.formData = Object.assign({}, this.slotData);
        this.variantsDialogVisible = true;
      },
      onVariantsFormSubmit() {
        if (this.$refs['variantsForm1'].validate()) {
          this._onUpdateVariants();
          this.variantsDialogVisible = false;
        }
      },
      async _onUpdateVariants() {
        const url = this.apis().updateVariantsOfApparelProduct(this.slotData.code);
        const result = await this.$http.put(url, this.slotData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新颜色/尺码成功');
      },
      onUpdateAttributes() {
        this.formData = Object.assign({}, this.slotData);
        this.attributesDialogVisible = true;
      },
      onAttributesFormSubmit() {
        this.$refs['attributesForm1'].validate(valid => {
          if (valid) {
            this._onUpdateAttributes();
            this.attributesDialogVisible = false;
            return true;
          }

          return false;
        });
      },
      async _onUpdateAttributes() {
        const url = this.apis().updateAttributesOfApparelProduct(this.slotData.code);
        const result = await this.$http.put(url, this.slotData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新产品属性成功');
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
    font-size: 14px;
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

</style>
