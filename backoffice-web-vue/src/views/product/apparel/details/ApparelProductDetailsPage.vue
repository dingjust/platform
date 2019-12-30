<template>
  <div class="animated fadeIn">
    <apparel-product-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel" />
    <div class="pt-2"></div>
    <apparel-product-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated" :isRead="isRead"/>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers('ApparelProductsModule');

  import ApparelProductFormToolbar from '../toolbar/ApparelProductFormToolbar';
  import ApparelProductForm from '../form/ApparelProductForm';

  export default {
    name: 'ApparelProductDetailsPage',
    props: ['formData', 'readOnly'],
    components: {
      ApparelProductFormToolbar,
      ApparelProductForm
    },
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit () {
        if (this.$refs['form'].validate()) {
          this._onSubmit();
        }
      },
      onCancel () {
        this.fn.closeSlider();
      },
      async _onSubmit () {
        let formData = this.slotData;

        const url = this.apis().createApparelProduct();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('产品创建成功，产品编号： ' + result);
        this.$set(this.slotData, 'code', result);
        this.refresh();
        this.fn.closeSlider(true);
        this.$emit('afterCreate');
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data () {
      return {
        slotData: {},
        isRead: false
      }
    },
    created () {
      if (this.isTenant()) {
        this.slotData = this.formData;
        this.isRead = this.readOnly;
        return;
      }
      if (this.$route.params.slotData != null) {
        this.slotData = this.$route.params.slotData;
      } else {
        this.slotData = this.$store.state.ApparelProductsModule.formData;
      }
    }
  }
</script>
