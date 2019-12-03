<template>
  <div class="animated fadeIn brand-detail">
    <el-row class="brand-info-title-row" type="flex" justify="space-between">
      <div class="brand-info-title">
        <h6 class="brand-info-title_text">公司信息</h6>
      </div>
      <i v-if="!readOnly" class="el-icon-edit" @click="onEdit" style="cursor:pointer;font-size: 20px"></i>
    </el-row>
    <el-row type="flex" :gutter="20">
      <el-col :span="5" class="brand-card-class">
        <brand-card-info-page :slotData="slotData"/>
      </el-col>
      <el-col :span="19">
        <el-row type="flex">
          <el-col :span="1">
            <i class="factory-info" style="position: relative;top: -25px;">&#xe690;</i>
          </el-col>
          <el-col :span="11">
            <brand-scale-info-page :slotData="slotData"/>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('BrandsModule');

  import BrandCardInfoPage from '../info/BrandCardInfoPage';
  import BrandScaleInfoPage from '../info/BrandScaleInfoPage';

  export default {
    name: 'BrandDetailsPage',
    props: {
      slotData: {
        type: Object
      },
      readOnly: {
        type: Boolean,
        default: true
      }
    },
    components: {BrandScaleInfoPage, BrandCardInfoPage},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      async onSubmit () {
        let formData = this.slotData;

        const url = this.apis().createBrand();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('品牌创建成功');
        this.$set(this.slotData, 'code', result);
        this.refresh();
        this.fn.closeSlider(true);
      },
      onCancel () {
        this.fn.closeSlider();
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data () {
      return {}
    }
  }
</script>

<style scoped>
  .brand-detail .brand-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .brand-detail .brand-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .brand-detail .brand-info-title-row {
    margin-bottom: 20px;
  }

  .brand-detail .el-divider--vertical{
    height: auto;
  }
  .brand-detail >>> .el-divider--horizontal{
    margin: 0px 0px 0px 0px;
  }

  .brand-detail .brand-card-class{
    border-style: solid;
    border-radius: 8px;
    border-width: 1px;
    margin-top: -12px;
  }

  .brand-detail .buttonClass{
    padding: 8px 35px 8px 35px;
    margin-bottom: 10px;
    background-color: #ffd60c;
    color: #0b0e0f;
  }
</style>
