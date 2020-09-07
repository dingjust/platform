<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="progress-list-title">
            <h6>进度工单详情</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :inline="true">
        <progress-order-receiving-form :formData="formData" :isRead="true"/>
        <progress-order-production-info-form :formData="formData" :isRead="false"/>
        <progress-order :slotData="formData" @callback="callback" :order="formData"/>
      </el-form>
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
    'ProgressOrdersModule'
  );

  import ProgressOrderReceivingForm from '../form/ProgressOrderReceivingForm';
  import ProgressOrderProductionInfoForm from '../form/ProgressOrderProductionInfoForm';
  import ProgressOrder from '../../components/progress-order';
  export default {
    name: 'ProgressOrderDetail',
    props: ['code'],
    components: {ProgressOrder, ProgressOrderProductionInfoForm, ProgressOrderReceivingForm},
    computed: {
      ...mapGetters({
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        getOrderDetail: 'getDetail'
      }),
      getDetail () {
        const code = this.code;
        this.getOrderDetail(code);
      },
      callback (productionOrder) {
        console.log(productionOrder);
        if (productionOrder == null) {
          this.getDetail();
        } else {
          this.$store.state.ProgressOrdersModule.formData = Object.assign({}, productionOrder.taskOrderEntries[0].progressWorkSheet);
        }
      }
    },
    data () {
      return {
      }
    },
    created() {
      this.getDetail();
    }
  }
</script>

<style scoped>
  .progress-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .progress-row {
    padding-left: 10px;
    margin-top: 20px;
  }
</style>
