<template>
  <div class="animated fadeIn">
    <employee-form-toolbar :read-only="isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <employee-form ref="form" :slot-data="slotData" :read-only="isNewlyCreated"/>
    <div class="pt-2"></div>
    <employee-form-toolbar :read-only="isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('EmployeesModule');

  import EmployeeFormToolbar from '../toolbar/EmployeeFormToolbar';
  import EmployeeForm from '../form/EmployeeForm';

  export default {
    name: 'EmployeeDetailsPage',
    props: ['slotData'],
    components: {EmployeeFormToolbar, EmployeeForm},
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
        let url = this.apis().createEmployee();
        let result = {};
        if(formData.id&&formData.id!=null){
          url = this.apis().updateEmployee();
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
        this.refresh(this.apis().getEmployees());
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
