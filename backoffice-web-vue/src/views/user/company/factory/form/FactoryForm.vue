<template>
  <div class="animated fadeIn factory-edit">
    <el-row class="factory-info-title-row">
      <div class="factory-info-title">
        <h6 class="factory-info-title_text">编辑资料</h6>
      </div>
    </el-row>
    <div class="titleCardClass">
      <el-form :model="formData">
        <el-row>
          <factory-basic-form v-if="factoryFormVisible" :form-data="formData"></factory-basic-form>
        </el-row>
        <el-row>
          <factory-contact-form :form-data="formData"></factory-contact-form>
        </el-row>
        <el-row>
          <factory-scale-form :form-data="formData"></factory-scale-form>
        </el-row>
        <el-row>
          <factory-capacity-form :form-data="formData"></factory-capacity-form>
        </el-row>
        <el-row>
          <factory-service-form :form-data="formData"></factory-service-form>
        </el-row>
      </el-form>
    </div>

    <el-row type="flex" justify="center">
      <el-button class="buttonClass" @click="onSave">
        <h6>保存</h6>
      </el-button>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters} = createNamespacedHelpers('FactoriesModule');
  import FactoryBasicForm from './FactoryBasicForm';
  import FactoryCertificateForm from './FactoryCertificateForm';
  import FactoryContactForm from './FactoryContactForm';
  import FactoryScaleForm from './FactoryScaleForm';
  import FactoryCapacityForm from './FactoryCapacityForm';
  import FactoryServiceForm from './FactoryServiceForm';

  export default {
    name: 'FactoryFrom',
    components: {
      FactoryServiceForm,
      FactoryCapacityForm,
      FactoryScaleForm,
      FactoryContactForm,
      FactoryBasicForm,
      FactoryCertificateForm
    },
    computed: {
      ...mapGetters({
        factoryFormVisible: 'factoryFormVisible'
      })
    },
    props: ['formData'],
    methods: {
      onSave () {
        this.$emit('onSave');
      }
    },
    data () {
      return {
      }
    },
    created () {
    }
  }
</script>

<style>
  .factory-edit .factory-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .factory-edit .factory-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .factory-edit .factory-info-title-row {
    margin-bottom: 20px;
  }

  .factory-edit .buttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }

  .factory-edit .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

</style>
