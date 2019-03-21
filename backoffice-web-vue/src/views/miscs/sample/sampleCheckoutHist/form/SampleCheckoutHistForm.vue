<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <sample-checkout-hist-basic-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
  <el-card class="box-card">
    <div slot="header" class="clearfix">
      <span>附件</span>
    </div>
    <sample-checkout-hist-images-form :slot-data="slotData" :read-only="readOnly"/>
  </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <sample-checkout-hist-form-toolbar :read-only="false" @onSubmit="onSubmit" @onCancel="onCancel"/>
    </el-card>
  </div>
</template>

<script>
  import SampleCheckoutHistBasicForm from './SampleCheckoutHistBasicForm';
  import SampleCheckoutHistImagesForm from './SampleCheckoutHistImagesForm';
  import SampleCheckoutHistFormToolbar from '../toolbar/SampleCheckoutHistFormToolbar';

  export default {
    name: 'SampleCheckoutHistForm',
    props: ['slotData', 'readOnly'],
    components: {
      SampleCheckoutHistBasicForm,
      SampleCheckoutHistImagesForm,
      SampleCheckoutHistFormToolbar,
    },
    computed: {},
    methods: {
      async onSubmit() {
        const url = this.apis().createSampleCheckoutHist();
        const result = await this.$http.post(url, this.slotData);
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('创建样衣借还记录成功，样衣编号：' + result);
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
