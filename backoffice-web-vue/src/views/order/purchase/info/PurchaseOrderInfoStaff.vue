<template>
  <div class="info-detail-staff-body">
    <el-row class="info-detail-title-row">
      <div class="info-detail-title">
        <h6 class="info-title_text">人员设置</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="space-between" align="center" class="info-row">
      <orders-info-item :slotData="'品牌跟单员'">{{slotData.brandOperator!=null?slotData.brandOperator.name:'未指定'}}
      </orders-info-item>
      <orders-info-item :slotData="'联系电话'">{{slotData.brandOperator!=null?slotData.brandOperator.mobileNumber:'未指定'}}
      </orders-info-item>
    </el-row>
    <el-row type="flex" justify="space-between" align="center" class="info-row">
      <orders-info-item :slotData="'工厂跟单员'">{{slotData.factoryOperator!=null?slotData.factoryOperator.name:'未指定'}}
      </orders-info-item>
      <orders-info-item :slotData="'联系电话'">
        {{slotData.factoryOperator!=null?slotData.factoryOperator.mobileNumber:'未指定'}}</orders-info-item>
    </el-row>
  </div>
</template>

<script>
  import OrdersInfoItem from '@/components/custom/OrdersInfoItem';

  export default {
    name: 'PurchaseOrderInfoStaff',
    props: ['slotData'],
    components: {
      OrdersInfoItem,
    },
    mixins: [],
    computed: {

    },
    methods: {},
    data() {
      return {}
    },
    created() {}
  }

</script>
<style>
  .info-detail-staff-body {
    width: 100%;
    margin-top: 20px;
  }

  .info-detail-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.85;
  }

  .info-row {
    margin-top: 5px;
  }

</style>
