<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <industrial-cluster-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </industrial-cluster-basic-form>
    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import IndustrialClusterBasicForm from './IndustrialClusterBasicForm';

  export default {
    name: 'IndustrialClusterFrom',
    components: {
      IndustrialClusterBasicForm,
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
