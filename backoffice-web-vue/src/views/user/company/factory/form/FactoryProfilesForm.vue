<template>
  <div class="animated fadeIn factory-profiles">
    <el-row class="factory-info-title-row">
      <div class="factory-info-title">
        <h6 class="factory-info-title_text">图文详情</h6>
      </div>
    </el-row>
    <el-row type="flex">
      <h6 style="color: grey;font-size: 10px">建议上传图片的分辨率尺寸为16:9</h6>
    </el-row>
    <div class="titleCardClass">
      <el-row type="flex" v-for="item of profiles" style="margin-bottom: 20px">
        <el-col :span="8">
          <images-upload :limit="1" :picClass="true" :slot-data="item.medias" >
          </images-upload>
        </el-col>
        <el-col :span="16" :offset="2">
          <el-input type="textarea"
                    v-model="item.description"
                    maxlength="200"
                    placeholder="请输入文本"
                    :show-word-limit="true"
                    rows="6">

          </el-input>
        </el-col>
      </el-row>
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
  import ImagesUpload from '../../../../../components/custom/ImagesUpload';

  export default {
    name: 'FactoryProfilesFrom',
    components: {
      ImagesUpload,
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
    props: ['profiles'],
    methods: {
      onSave () {
        this.$emit('onSave');
      }
    },
    watch: {
      'profiles': function (n, o) {
        console.log(n);
      },
      deep: true
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
  .factory-profiles .factory-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .factory-profiles .factory-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .factory-profiles .factory-info-title-row {
    margin-bottom: 20px;
  }

  .factory-profiles .buttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }

  .factory-profiles .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

  .factory-profiles .el-textarea .el-input__count{
    bottom: 10px
  }
</style>
