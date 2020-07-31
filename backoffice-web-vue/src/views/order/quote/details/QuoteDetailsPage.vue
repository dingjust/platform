<template>
  <div class="animated fadeIn ">
    <!--<div class="box" v-if="!readOnly">-->
      <!--<div class="boxButton">-->
        <!--<el-row type="flex" justify="center">-->
          <!--<div class="buttonIconClass">-->
            <!--<svg t="1570870292198" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4641" width="100%" height="100%">-->
              <!--<path d="M306.16 170.54c-48.52 0-87.84 38.26-87.84 85.46v513c0 47.2 39.32 85.46 87.84 85.46h410c48.52 0 87.84-38.26 87.84-85.46V541c0-15.67 13.14-28.46 29.25-28.46S862.5 525.23 862.5 541v228c0 78.63-65.51 142.46-146.43 142.46h-410c-80.82 0-146.43-63.83-146.43-142.46V256c0-78.63 65.61-142.46 146.43-142.37h175.76c16.11 0 29.25 12.69 29.25 28.46s-13 28.45-29.25 28.45z m58.49 569.86c-16.21 0-29.25-12.79-29.25-28.45s13-28.45 29.25-28.45h292.86c16.1 0 29.25 12.79 29.25 28.45s-13 28.45-29.25 28.45z m0-170.92c-16.21 0-29.25-12.88-29.25-28.55s13-28.45 29.25-28.45H476.2c16.2 0 29.25 12.88 29.25 28.55s-13 28.45-29.25 28.45z m0-171" fill="#505766" p-id="4642"></path><path d="M856.39 170.53a14 14 0 0 0-5.3-9.48l-56.38-44.28a14.8 14.8 0 0 0-10.71-3.06 14.61 14.61 0 0 0-9.76 5.18l-237 284.88a14.32 14.32 0 0 0-2.55 4.71l-0.07 0.25-22.9 72.27a13.88 13.88 0 0 0 4.75 15.11l11.27 8.89a14.85 14.85 0 0 0 16.21 1.32l67.87-36.93 0.24-0.14a14.72 14.72 0 0 0 4.21-3.41l237-284.88a13.82 13.82 0 0 0 3.12-10.43z" fill="#FFD60C" p-id="4643"></path>-->
            <!--</svg>-->
          <!--</div>-->
        <!--</el-row>-->
        <!--<el-row type="flex" justify="center">-->
          <!--<h6 class="buttonTextClass">创建打样订单</h6>-->
        <!--</el-row>-->
      <!--</div>-->
      <!--<div class="boxButton">-->
        <!--<el-row type="flex" justify="center">-->
          <!--<div class="buttonIconClass">-->
            <!--<svg t="1570870292198" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4641" width="100%" height="100%">-->
              <!--<path d="M306.16 170.54c-48.52 0-87.84 38.26-87.84 85.46v513c0 47.2 39.32 85.46 87.84 85.46h410c48.52 0 87.84-38.26 87.84-85.46V541c0-15.67 13.14-28.46 29.25-28.46S862.5 525.23 862.5 541v228c0 78.63-65.51 142.46-146.43 142.46h-410c-80.82 0-146.43-63.83-146.43-142.46V256c0-78.63 65.61-142.46 146.43-142.37h175.76c16.11 0 29.25 12.69 29.25 28.46s-13 28.45-29.25 28.45z m58.49 569.86c-16.21 0-29.25-12.79-29.25-28.45s13-28.45 29.25-28.45h292.86c16.1 0 29.25 12.79 29.25 28.45s-13 28.45-29.25 28.45z m0-170.92c-16.21 0-29.25-12.88-29.25-28.55s13-28.45 29.25-28.45H476.2c16.2 0 29.25 12.88 29.25 28.55s-13 28.45-29.25 28.45z m0-171" fill="#505766" p-id="4642"></path><path d="M856.39 170.53a14 14 0 0 0-5.3-9.48l-56.38-44.28a14.8 14.8 0 0 0-10.71-3.06 14.61 14.61 0 0 0-9.76 5.18l-237 284.88a14.32 14.32 0 0 0-2.55 4.71l-0.07 0.25-22.9 72.27a13.88 13.88 0 0 0 4.75 15.11l11.27 8.89a14.85 14.85 0 0 0 16.21 1.32l67.87-36.93 0.24-0.14a14.72 14.72 0 0 0 4.21-3.41l237-284.88a13.82 13.82 0 0 0 3.12-10.43z" fill="#FFD60C" p-id="4643"></path>-->
            <!--</svg>-->
          <!--</div>-->
        <!--</el-row>-->
        <!--<el-row type="flex" justify="center">-->
          <!--<h6 class="buttonTextClass">创建生产订单</h6>-->
        <!--</el-row>-->
      <!--</div>-->
    <!--</div>-->
    <el-row class="info-title-row" type="flex" justify="space-between">
      <div class="info-title">
        <h6 class="info-title-text">报价单详情</h6>
      </div>
      <!--<i class="el-icon-edit" @click="onEdit" style="cursor:pointer;font-size: 20px"></i>-->
    </el-row>
    <el-row type="flex" align="middle" style="margin-bottom: 20px">
      <el-col :span="8">
        <span>报价单号：{{slotData.code}}</span>
      </el-col>
      <el-col :span="8">
        <span>当前状态：<span :style="{color: statusColor}">{{getEnum('quoteStates',slotData.state)}}</span></span>
      </el-col>
      <el-col :span="8">
        <el-row type="flex" justify="end">
          <span>发布日期：{{slotData.creationtime | formatDate}}</span>
        </el-row>
      </el-col>
    </el-row>

    <div class="titleCardClass">
      <el-row>
        <div class="titleClass">
          <h6>报价详情</h6>
        </div>
      </el-row>
      <quote-basic-info-page :slotData="slotData" style="margin: 20px 20px"/>
      <el-row type="flex">
        <el-col :span="18">
          <el-row>
            <div class="titleClass">
              <el-row type="flex" justify="space-between">
                <h6>需求信息</h6>
                <h6>需求单号&nbsp;&nbsp;<span style="color:#a9a9a9;">{{slotData.requirementOrder.code}}</span></h6>
              </el-row>
            </div>
          </el-row>
          <requirement-order-basic-info-page :slotData="slotData.requirementOrder" style="padding:10px"/>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="6">
          <el-row>
            <div class="titleClass">
              <h6>发布需求者</h6>
            </div>
          </el-row>
          <requirement-order-belong-to-info-page :slotData="slotData.requirementOrder" style="margin: 20px 0px 10px 10px;"/>
        </el-col>
      </el-row>
    </div>
    <el-row type="flex" justify="space-around" style="margin-top: 30px" v-if="slotData.state === 'BUYER_APPROVED' && !isTenant()">
      <el-button class="btn-class" style="width: 200px" @click="onCreatedProofingOrder" :disabled="true">创建打样订单</el-button>
      <el-button class="btn-class" style="width: 200px" @click="onCreatedPurchaseOrder">创建生产订单</el-button>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import QuoteBasicInfoPage from '../info/QuoteBasicInfoPage';
  import RequirementOrderBasicInfoPage from '../../requirement/info/RequirementOrderBasicInfoPage';
  import RequirementOrderBelongToInfoPage from '../../requirement/info/RequirementOrderBelongToInfoPage';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'QuoteDetailsPage',
    props: {
      slotData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: true
      }
    },
    components: {
      RequirementOrderBelongToInfoPage,
      RequirementOrderBasicInfoPage,
      QuoteBasicInfoPage
    },
    computed: {
      ...mapGetters({

      }),
      statusColor: function () {
        var color = '';
        switch (this.slotData.state) {
          case 'SELLER_SUBMITTED':
            color = 'red';
            break;
          case 'BUYER_APPROVED':
            color = 'green';
            break;
          case 'BUYER_REJECTED':
            color = 'grey';
            break;
        }
        return color;
      }
    },
    methods: {
      ...mapMutations({
      }),
      ...mapActions({
      }),
      async onEdit () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().getFactory(uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setFormData(Object.assign({}, result));

        if ((this.formData.contactAddress.region != null && this.isCitiesChanged) || this.cities.length <= 0) {
          this.getCities(this.formData.contactAddress.region);
          this.setIsCitiesChanged(false);
        }
        if ((this.formData.contactAddress.city != null && this.isDistrictsChanged) || this.cities.length <= 0) {
          this.getCityDistricts(this.formData.contactAddress.city);
          this.setIsDistrictsChanged(false);
        }

        this.setFactoryFormVisible(true);
      },
      async onSave () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().updateFactory(uid);
        const result = await this.$http.put(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setFactoryFormVisible(false);
        this.$message.success('编辑工厂信息成功');
      },
      async getRegions () {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.regions = result;
      },
      async getCities (region, index) {
        const url = this.apis().getCities(region.isocode);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$store.state.FactoriesModule.cities = result;
      },
      async getCityDistricts (city) {
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$store.state.FactoriesModule.cityDistricts = result;
      },
      onClose () {
        this.setFactoryFormVisible(false);
      },
      onCreatedPurchaseOrder () {
        this.$router.push('/orderPurchase');
      },
      onCreatedProofingOrder () {
        // this.$router.push('/orderPurchase');
      },
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
   .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

   .info-title-text {
    font-size: 12px;
    font-weight: bold;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

   .info-title-row {
    margin-bottom: 20px;
  }

   .el-divider--horizontal{
    margin: 0px 0px -1px 0px;
  }

   .buttonClass{
    padding: 8px 35px 8px 35px;
    margin-bottom: 10px;
    background-color: #ffd60c;
    color: #0b0e0f;
  }

   .box{
    width: 50px;
    position: fixed;
    right: 152px;
    top: 300px;
    z-index:1;
  }
   .boxButton{
    width: 50px;
    height: 50px;
    font-size: 10px;
    cursor: pointer;
    border: 1px solid #DCDFE6;
  }

   .buttonIconClass{
    width: 30px;
    height: 30px;
    margin-bottom: -8px;
  }

   .buttonTextClass{
    font-size: 12px;
    transform:scale(0.7);
  }

  .v-modal{
    display: none;
  }

   .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #F0F0F0;
  }

   .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

   .el-divider--vertical{
    height: auto;
    margin: 0px;
  }
</style>
