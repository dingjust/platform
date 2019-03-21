<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <factory-basic-form ref="basicForm"
                          :slot-data="slotData"
                          :read-only="readOnly">
      </factory-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>认证信息</span>
      </div>
      <factory-certificate-form ref="certificateForm"
                                :slot-data="slotData"
                                :read-only="readOnly">
      </factory-certificate-form>
    </el-card>
  </div>
</template>

<script>
  import FactoryBasicForm from './FactoryBasicForm';
  import FactoryCertificateForm from './FactoryCertificateForm';

  export default {
    name: 'FactoryFrom',
    components: {
      FactoryBasicForm,
      FactoryCertificateForm,
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
