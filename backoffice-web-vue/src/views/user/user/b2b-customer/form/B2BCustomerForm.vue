<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <b2-b-customer-basic-form ref="basicForm"
                                :slot-data="slotData"
                                :read-only="readOnly">
      </b2-b-customer-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>角色/岗位</span>
      </div>
      <b2-b-customer-roles-form ref="rolesForm"
                                :slot-data="slotData"
                                :read-only="readOnly">
      </b2-b-customer-roles-form>
    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import B2BCustomerBasicForm from './B2BCustomerBasicForm';
  import B2BCustomerRolesForm from './B2BCustomerRolesForm';

  export default {
    name: 'B2BCustomerFrom',
    components: {
      B2BCustomerBasicForm,
      B2BCustomerRolesForm
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
