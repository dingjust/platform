<template>
  <div class="info-remarks-body">
    <el-row type="flex" justify="space-between" align="middle" class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">生产进度</h6>
      </div>
      <el-button size="mini" class="info-detail-logistics_info-btn1">部分发货</el-button>
    </el-row>
    <el-row>
      <purchase-order-progress :slotData="slotData"/>
    </el-row>
  </div>
</template>

<script>
  import PurchaseOrderProgress from '@/components/custom/PurchaseOrderProgress';

  export default {
    name: 'PurchaseOrderInfoProgress',
    props: ['slotData'],
    components: {
      PurchaseOrderProgress
    },
    mixins: [],
    computed: {

    },
    methods: {

    },
    data() {
      return {

      }
    },
    created() {}
  }

</script>
<style>
  .info-remarks-body {
    width: 100%;
    margin-top: 20px;
  }

  .info-remarks-img {
    width: 50px;
    height: 50px;
    border-radius: 10px;
    margin-right: 10px;
  }

  .info-remarks-row {
    margin-top: 20px;
  }

  .info-remarks-textarea {
    width: 100%;
    border: 0.5px solid rgba(0, 0, 0, 0.15);
    padding: 5px 10px;
    border-radius: 3px;
  }

  .info-remarks-textarea_text {
    font-size: 10px;
    color: rgba(0, 0, 0, 0.45);
  }

  .info-detail-logistics_info-btn1 {
    width: 70px;
    height: 25px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
  }

</style>
