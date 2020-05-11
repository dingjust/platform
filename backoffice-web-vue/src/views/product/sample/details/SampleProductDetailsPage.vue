<template>
  <div class="animated fadeIn">
    <sample-product-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated"
                         :isRead="readOnly" :isDialogOpen="isDialogOpen" @closeDialog="closeDialog"/>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers('SampleProductsModule');

  import SampleProductForm from '../form/SampleProductForm';

  export default {
    name: 'SampleProductDetailsPage',
    props: ['formData', 'readOnly'],
    components: {
      SampleProductForm
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
      },
      closeDialog () {
        this.$emit('closeDialog');
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
        isDialogOpen: false
      }
    },
    created () {
      if (this.isTenant()) {
        this.slotData = this.formData;
        return;
      }
      if (this.$route.params.slotData != null) {
        this.slotData = this.$route.params.slotData;
      } else {
        this.slotData = this.$store.state.SampleProductsModule.newFormData;
        this.isDialogOpen = true;
      }
    }
  }
</script>
