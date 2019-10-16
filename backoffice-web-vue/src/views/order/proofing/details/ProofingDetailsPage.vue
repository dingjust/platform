<template>
  <div class="animated fadeIn proofing-detail">
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
    <el-row class="factory-info-title-row" type="flex" justify="space-between">
      <div class="factory-info-title">
        <h6 class="info-title-text">打样单详情</h6>
      </div>
      <!--<i class="el-icon-edit" @click="onEdit" style="cursor:pointer;font-size: 20px"></i>-->
    </el-row>
    <el-row type="flex" justify="space-between" align="middle">
      <h6 class="info-title-text">打样详情</h6>
      <div>
        <span style="color: #C0C0C0">打样订单号：{{slotData.code}}</span>&nbsp;&nbsp;&nbsp;
        <span style="color: #C0C0C0">当前状态：<span :style="{color: statusColor}">{{getEnum('proofingOrderStatuses',slotData.status)}}</span></span>&nbsp;&nbsp;&nbsp;
        <span style="color: #C0C0C0">发布日期：{{slotData.creationtime | formatDate}}</span>
      </div>
    </el-row>
    <el-divider></el-divider>
    <el-row type="flex">
      <el-col :span="16">
        <proofing-basic-info-page :slotData="slotData" style="margin: 20px 20px 20px 0px">

        </proofing-basic-info-page>
      </el-col>
      <el-divider direction="vertical"></el-divider>
      <el-col :span="8">
        <proofing-supplier-info-page :slotData="slotData" style="margin: 20px 0px 20px 20px"></proofing-supplier-info-page>
        <el-divider></el-divider>
        <proofing-q-c-info-page :slotData="slotData" style="margin: 20px 0px 20px 20px"></proofing-q-c-info-page>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import ProofingBasicInfoPage from "../info/ProofingBasicInfoPage";
  import ProofingSupplierInfoPage from "../info/ProofingSupplierInfoPage";
  import ProofingQCInfoPage from "../info/ProofingQCInfoPage";

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('ProofingsModule');

  export default {
    name: 'ProofingDetailsPage',
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
      ProofingQCInfoPage,
      ProofingSupplierInfoPage,
      ProofingBasicInfoPage
    },
    computed: {
      ...mapGetters({

      }),
      statusColor: function () {
        var color = '';
        switch (this.slotData.status) {
          case 'PENDING_PAYMENT':
            color = 'red';
            break;
          case 'PENDING_DELIVERY':
            color = 'red';
            break;
          case 'SHIPPED':
            color = 'red';
            break;
          case 'COMPLETED':
            color = 'green';
            break;
          case 'CANCELLED':
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
  .proofing-detail .factory-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .proofing-detail .info-title-text {
    font-size: 12px;
    font-weight: bold;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .proofing-detail .factory-info-title-row {
    margin-bottom: 20px;
  }

  .proofing-detail .el-divider--vertical{
    height: auto;
    margin: 0px;
  }

  .proofing-detail .el-divider--horizontal{
    margin: 0px 0px -1px 0px;
  }

  .proofing-detail .buttonClass{
    padding: 8px 35px 8px 35px;
    margin-bottom: 10px;
    background-color: #ffd60c;
    color: #0b0e0f;
  }

  .proofing-detail .box{
    width: 50px;
    position: fixed;
    right: 152px;
    top: 300px;
    z-index:1;
  }
  .proofing-detail .boxButton{
    width: 50px;
    height: 50px;
    font-size: 10px;
    cursor: pointer;
    border: 1px solid #DCDFE6;
  }

  .proofing-detail .buttonIconClass{
    width: 30px;
    height: 30px;
    margin-bottom: -8px;
  }

  .proofing-detail .buttonTextClass{
    font-size: 12px;
    transform:scale(0.7);
  }

</style>
