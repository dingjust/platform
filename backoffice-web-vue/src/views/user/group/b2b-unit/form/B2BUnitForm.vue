<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <b2-b-unit-basic-form ref="basicForm"
                            :slot-data="slotData"
                            :read-only="readOnly">
      </b2-b-unit-basic-form>
    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import B2BUnitBasicForm from './B2BUnitBasicForm';

  export default {
    name: 'B2BUnitFrom',
    components: {
      B2BUnitBasicForm,
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
