<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <address-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </address-basic-form>
    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import AddressBasicForm from './AddressBasicForm';

  export default {
    name: 'AddressFrom',
    components: {
      AddressBasicForm,
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
