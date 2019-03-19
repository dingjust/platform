<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>图片</span>
      </div>
      <apparel-product-images-form ref="imagesForm"
                                   :slot-data="slotData"
                                   :read-only="readOnly">
      </apparel-product-images-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <apparel-product-basic-form ref="basicForm"
                                  :slot-data="slotData"
                                  :read-only="readOnly">
      </apparel-product-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品颜色/尺码</span>
      </div>
      <apparel-product-variants-form ref="variantsForm"
                                     :slot-data="slotData"
                                     :read-only="readOnly">
      </apparel-product-variants-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品属性</span>
      </div>
      <apparel-product-attributes-form ref="attributesForm"
                                       :slot-data="slotData"
                                       :read-only="readOnly">
      </apparel-product-attributes-form>
    </el-card>
  </div>
</template>

<script>
  import ApparelProductImagesForm from './ApparelProductImagesForm';
  import ApparelProductBasicForm from './ApparelProductBasicForm';
  import ApparelProductVariantsForm from './ApparelProductVariantsForm';
  import ApparelProductAttributesForm from './ApparelProductAttributesForm';

  export default {
    name: 'ApparelProductFrom',
    components: {
      ApparelProductImagesForm,
      ApparelProductBasicForm,
      ApparelProductVariantsForm,
      ApparelProductAttributesForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        // TODO: validation
        return true;
        // return this.$refs['basicForm'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
