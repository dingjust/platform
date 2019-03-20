<template>
  <div class="animated fadeIn">
    <b2-b-unit-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <b2-b-unit-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <b2-b-unit-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('B2BUnitsModule');

  import B2BUnitFormToolbar from '../toolbar/B2BUnitFormToolbar';
  import B2BUnitForm from '../form/B2BUnitForm';

  export default {
    name: 'B2BUnitDetailsPage',
    props: ['slotData'],
    components: {B2BUnitFormToolbar, B2BUnitForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit() {
        if (this.$refs['form'].validate()) {
          this._onSubmit();
        }
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;

        const url = this.apis().createB2BUnit();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('品牌创建成功');
        this.$set(this.slotData, 'code', result);
        this.refresh();
        this.fn.closeSlider(true);
      }
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
