<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <label-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </label-basic-form>
    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import LabelBasicForm from './LabelBasicForm';

  export default {
    name: 'LabelFrom',
    components: {
      LabelBasicForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        return this.$refs['basicForm'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
