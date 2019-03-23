<template>
  <div class="animated fadeIn">
    <b2-b-customer-form-toolbar :read-only="isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <b2-b-customer-form ref="form" :slot-data="slotData" :read-only="isNewlyCreated"/>
    <div class="pt-2"></div>
    <b2-b-customer-form-toolbar :read-only="isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('B2BCustomersModule');

  import B2BCustomerFormToolbar from '../toolbar/B2BCustomerFormToolbar';
  import B2BCustomerForm from '../form/B2BCustomerForm';

  export default {
    name: 'B2BCustomerDetailsPage',
    props: ['slotData'],
    components: {B2BCustomerFormToolbar, B2BCustomerForm},
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
        let url = this.apis().createB2BCustomer();
        let result = {};
        if(formData.id&&formData.id!=null){
          url = this.apis().updateB2BCustomer(formData.uid);
          result = await this.$http.put(url, formData);

        }else {
          result = await this.$http.post(url, formData);
        }
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.$set(this.slotData, 'code', result);
        this.refresh(this.apis().getB2BCustomers());
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
