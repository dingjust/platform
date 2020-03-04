<template>
  <div class="animated fadeIn factory-edit">
    <el-row class="factory-info-title-row">
      <div class="factory-info-title">
        <h6 class="factory-info-title_text">{{'公司详情'}}</h6>
      </div>
    </el-row>
    <div class="titleCardClass">
      <el-form :model="tranData" ref="factoryForm" label-position="left" label-width="75px" hide-required-asterisk :disabled="true">
        <el-row>
          <factory-basic v-if="factoryFormVisible" :form-data="tranData":readOnly="true"></factory-basic>
        </el-row>
        <el-row>
          <factory-scale :form-data="tranData"></factory-scale>
        </el-row>
        <el-row>
          <factory-capacity v-if="factoryFormVisible" :form-data="tranData" :readOnly="true"></factory-capacity>
        </el-row>
      </el-form>
    </div>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations} = createNamespacedHelpers('FactoriesModule');
  import FactoryBasic from '../info/FactoryBasic';
  import FactoryCertificateForm from '../form/FactoryCertificateForm';
  import FactoryContactForm from '../form/FactoryContactForm';
  import FactoryScale from '../info/FactoryScale';
  import FactoryCapacity from '../info/FactoryCapacity';
  import FactoryServiceForm from '../form/FactoryServiceForm';

  export default {
    name: 'FactoryDetailsRead',
    props: ['slotData'],
    components: {
      FactoryServiceForm,
      FactoryCapacity,
      FactoryScale,
      FactoryContactForm,
      FactoryBasic,
      FactoryCertificateForm
    },
    computed: {
      ...mapGetters({
        factoryFormVisible: 'factoryFormVisible'
      }),
      tranData: function () {
          this.setFactoryFormVisible(true);
          return this.slotData;
      }
    },
    methods: {
      ...mapMutations({
        setFactoryFormVisible: 'setFactoryFormVisible',
      }),
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
