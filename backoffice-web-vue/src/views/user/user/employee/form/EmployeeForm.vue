<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <employee-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </employee-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>角色/岗位</span>
      </div>
      <employee-roles-form ref="rolesForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </employee-roles-form>
    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import EmployeeBasicForm from './EmployeeBasicForm';
  import EmployeeRolesForm from './EmployeeRolesForm';

  export default {
    name: 'EmployeeFrom',
    components: {
      EmployeeBasicForm,
      EmployeeRolesForm
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
