<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <sample-product-basic-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
  <el-card class="box-card">
    <div slot="header" class="clearfix">
      <span>附件</span>
    </div>
    <sample-product-pictures-form :slot-data="slotData" :read-only="readOnly"/>
  </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <sample-product-form-toolbar :read-only="readOnly" @onSubmit="onSubmit" @onCancel="onCancel"/>
    </el-card>
  </div>
</template>

<script>
  import SampleProductBasicForm from './SampleProductBasicForm';
  import SampleProductPicturesForm from './SampleProductPicturesForm';
  import SampleProductFormToolbar from '../toolbar/SampleProductFormToolbar';

  export default {
    name: 'SampleProductForm',
    props: ['slotData', 'readOnly'],
    components: {
      SampleProductBasicForm,
      SampleProductPicturesForm,
      SampleProductFormToolbar,
    },
    computed: {},
    methods: {
      async onSubmit() {
        const url = this.apis().createSampleProduct();
        const result = await this.$http.post(url, this.slotData);
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('创建样衣成功，样衣编号：' + result);
        this.fn.closeSlider();
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    data() {
      return {}
    },
    created() {
    }
  }
</script>
