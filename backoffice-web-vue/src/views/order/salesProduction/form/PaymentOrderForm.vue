<template>
  <div class="payment-form-body">
    <el-row class="payment-form-title-row">
      <div class="payment-form-title">
        <h6 class="payment-form-title_text">添加支付单</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="center" v-if="order">
      <el-button @click="onSure" class="submit-btn">确认导入</el-button>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: "PaymentOrderForm",
    components: {},
    mixins: [],
    computed: {

    },
    methods: {
    },
    data() {
      return {

      };
    },
    created() {},
    mounted() {}
  };

</script>
<style scoped>
  .payment-form-body {
    width: 100%;
  }

  .payment-form-title {
    width: 100%;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 14px;
  }

  .payment-form-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .payment-form-title-row {
    margin-bottom: 20px;
  }

  .payment-form-order {
    background-color: rgba(0, 0, 0, 0.02);
    padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
    margin-top: 20px;
  }

  .payment-form-text {
    font-size: 12px;
    color: rgba(51, 48, 48, 0.65);
  }

  .payment-form-btn {
    background: #ffd60c;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    margin-top: 20px;
  }

  .submit-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    width: 150px;
    margin-top: 20px;
  }

  .form-table {
    width: 100%;
    margin-top: 20px;
  }

</style>
