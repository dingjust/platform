<template>
  <div class="animated fadeIn">
    <el-row class="payPlan-info-title-row">
      <div class="payPlan-info-title">
        <h6 class="payPlan-info-title_text">账务详情</h6>
      </div>
    </el-row>
    <pay-plan-info-page :itemData="itemData"></pay-plan-info-page>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import PayPlanInfoPage from "../info/PayPlanInfoPage";

  const {mapGetters} = createNamespacedHelpers('PayPlanModule');


  export default {
    name: 'PayPlanDetailsPage',
    props: ['itemData'],
    components: {PayPlanInfoPage},
    computed: {
      ...mapGetters({
      })
    },
    methods: {
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
  .payPlan-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .payPlan-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .payPlan-info-title-row {
    margin-bottom: 20px;
  }
</style>
