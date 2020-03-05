<template>
  <div class="animated fadeIn brand-edit">
    <el-row class="brand-info-title-row">
      <div class="brand-info-title">
        <h6 class="brand-info-title_text">公司详情</h6>
      </div>
    </el-row>
    <div class="titleCardClass">
      <el-form  ref="brandForm" label-position="left" label-width="75px" hide-required-asterisk >
        <el-row>
          <brand-basic-info :formData="slotData" :readOnly="true"/>
        </el-row>
        <el-row>
          <brand-capacity :formData="slotData" :readOnly="true"/>
        </el-row>
      </el-form>
    </div>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations} = createNamespacedHelpers('BrandsModule');

  import BrandBasicInfo from '../info/BrandBasicInfo';
  import BrandCapacity from '../info/BrandCapacity';
  export default {
    name: 'BrandDetailsRead',
    components: {
      BrandCapacity,
      BrandBasicInfo
    },
    props: ['formData', 'slotData'],
    methods: {

    },
    computed: {
    },
    data () {
      return {
      }
    },
    created () {
    }
  }
</script>
<style scoped>
  .brand-edit .brand-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .brand-edit .brand-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .brand-edit .brand-info-title-row {
    margin-bottom: 20px;
  }

  .brand-edit .buttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }

  .brand-edit .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }
</style>
