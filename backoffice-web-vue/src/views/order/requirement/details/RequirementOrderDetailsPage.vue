<template>
  <div class="animated fadeIn">
    <requirement-order-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <requirement-order-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <requirement-order-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  import RequirementOrderFormToolbar from '../toolbar/RequirementOrderFormToolbar';
  import RequirementOrderForm from '../form/RequirementOrderForm';

  export default {
    name: 'RequirementOrderDetailsPage',
    props: ['slotData'],
    components: {RequirementOrderFormToolbar, RequirementOrderForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit() {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            const expectedDeliveryDate = this.slotData.details.expectedDeliveryDate;
            if (this.compareDate(new Date(), new Date(expectedDeliveryDate))) {
              this.$message.error('预计完成时间不能小于当前时间');
              return false;
            }

            this._onSubmit();
            return true;
          }

          return false;
        });
      },
      _getDate(timestamp) {
        const result = new Date(timestamp);
        return result.getFullYear() + '' + result.getMonth() + '' + result.getDate();
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;

        const url = this.apis().createRequirementOrder();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('发布需求成功，订单编号： ' + result);
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
