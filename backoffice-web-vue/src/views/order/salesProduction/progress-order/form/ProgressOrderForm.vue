<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="progress-list-title">
            <h6>编辑进度工单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :inline="true">
        <progress-order-receiving-form :formData="formData" :isRead="false"/>
        <progress-order-production-info-form :formData="formData" :isRead="false"/>
        <progress-order-node-form :formData="formData"/>
      </el-form>
      <el-row type="flex" justify="center" align="middle">
        <el-button class="material-btn">保存</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'ProgressOrderModule'
  );

  import ProgressOrderReceivingForm from '../form/ProgressOrderReceivingForm';
  import ProgressOrderProductionInfoForm from '../form/ProgressOrderProductionInfoForm';
  import ProductionProgressOrderInfo from '../../production-order/info/ProductionProgressOrderInfo';
  import ProgressOrderNodeForm from './ProgressOrderNodeForm';
  export default {
    name: 'ProgressOrderDetail',
    props: ['code'],
    components: {
      ProgressOrderNodeForm,
      ProductionProgressOrderInfo,
      ProgressOrderProductionInfoForm,
      ProgressOrderReceivingForm
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        getOrderDetail: 'getDetail'
      }),
      async getDetail () {
        const code = this.code;
        await this.getOrderDetail({code});
        this.formData.progresses.forEach(val => {
          this.$set(val, 'originPhase', true);
        })
      }
    },
    data () {
      return {
      }
    },
    created () {
      this.getDetail();
    }
  }
</script>

<style scoped>
  .progress-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    /* border-color: #000000; */
    color: #000;
    width: 100px;
    /* height: 35px; */
    margin-top: 20px;
  }
</style>
