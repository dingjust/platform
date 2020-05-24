<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="production-order-list-title">
            <h6>生产任务明细</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>任务单号：{{code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>订单状态：{{getEnum('purchaseOrderStatuses', formData.status)}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row class="production-order-basic-row">
        <production-order-top-info :slotData="formData"/>
        <production-progress-order-info :slotData="formData" @refreshData="getDetail"/>
        <production-order-relation-info :slotData="formData"/>
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
    'ProductionOrderModule'
  );

  import ProductionOrderTopInfo from '../info/ProductionOrderTopInfo';
  import ProductionProgressOrderInfo from '../info/ProductionProgressOrderInfo';
  import ProductionOrderRelationInfo from '../info/ProductionOrderRelationInfo';
  export default {
    name: 'ProductionOrderDetail',
    props: ['code'],
    components: {ProductionOrderRelationInfo, ProductionProgressOrderInfo, ProductionOrderTopInfo},
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
        this.getOrderDetail({code});
      }
    },
    data () {
      return {
      }
    },
    mounted () {
    },
    created () {
      this.getDetail();
    }
  }
</script>

<style scoped>
  .production-order-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .production-order-basic-row {
    padding-left: 10px;
  }
</style>
