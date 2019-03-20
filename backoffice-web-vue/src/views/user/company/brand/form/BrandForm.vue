<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <brand-basic-form ref="basicForm"
                        :slot-data="slotData"
                        :read-only="readOnly">
      </brand-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>认证信息</span>
      </div>
      <brand-certificate-form ref="certificateForm"
                              :slot-data="slotData"
                              :read-only="readOnly">
      </brand-certificate-form>
    </el-card>
  </div>
</template>

<script>
  import BrandBasicForm from './BrandBasicForm';
  import BrandCertificateForm from './BrandCertificateForm';

  export default {
    name: 'BrandFrom',
    components: {
      BrandBasicForm,
      BrandCertificateForm,
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
