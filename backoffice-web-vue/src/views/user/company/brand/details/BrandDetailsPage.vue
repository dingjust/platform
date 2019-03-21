<template>
  <div class="animated fadeIn">
    <brand-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <brand-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <brand-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('BrandsModule');

  import BrandFormToolbar from '../toolbar/BrandFormToolbar';
  import BrandForm from '../form/BrandForm';

  export default {
    name: 'BrandDetailsPage',
    props: ['slotData'],
    components: {BrandFormToolbar, BrandForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      async onSubmit() {
        let formData = this.slotData;

        const url = this.apis().createBrand();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('品牌创建成功');
        this.$set(this.slotData, 'code', result);
        this.refresh();
        this.fn.closeSlider(true);
      },
      onCancel() {
        this.fn.closeSlider();
      },
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {}
    }
  }
</script>
