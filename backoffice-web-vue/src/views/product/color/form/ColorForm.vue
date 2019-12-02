<template>
  <div class="animated fadeIn">
    <el-row class="color-info-title-row">
      <div class="color-info-title">
        <h6 class="color-info-title_text">基本信息</h6>
      </div>
    </el-row>
    <color-basic-form ref="basicForm" :slot-data="slotData" :read-only="readOnly"/>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import ColorBasicForm from './ColorBasicForm';

  export default {
    name: 'ColorFrom',
    components: {
      ColorBasicForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        // TODO: validation
        // return true;
        return this.$refs['basicForm'].validate();
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
<style scoped>
  .color-info-title-row {
    margin-bottom: 20px;
  }
  .color-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }
  .color-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }
</style>
