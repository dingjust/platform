<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <user-group-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </user-group-basic-form>
    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import UserGroupBasicForm from './UserGroupBasicForm';

  export default {
    name: 'UserGroupFrom',
    components: {
      UserGroupBasicForm,
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
