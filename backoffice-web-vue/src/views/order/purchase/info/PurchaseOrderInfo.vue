<template>
  <div>
    <el-dialog :visible.sync="uniquecodeFormVisible" width="30%" class="purchase-dialog" append-to-body>
      <uniquecode-generate-form :slotData="slotData"/>
    </el-dialog>
    <el-row>
      <el-col :span="16">
        <purchase-order-info-main :slotData="slotData" />
      </el-col>
      <el-col :span="8">
        <purchase-order-info-aside :slotData="slotData" />
      </el-col>
    </el-row>
    <el-row class="purchase-order-row" type="flex" justify="center" align="middle">
      <el-button class="purchase-order-btn" @click="uniquecodeFormVisible=!uniquecodeFormVisible">唯一码</el-button>
    </el-row>
  </div>
</template>

<script>
  import PurchaseOrderInfoMain from './PurchaseOrderInfoMain';
  import PurchaseOrderInfoAside from './PurchaseOrderInfoAside';
  import UniquecodeGenerateForm from './UniquecodeGenerateForm';

  export default {
    name: 'PurchaseOrderInfo',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoMain,
      PurchaseOrderInfoAside,
      UniquecodeGenerateForm
    },
    mixins: [],
    computed: {

    },
    methods: {},
    data() {
      return {
        uniquecodeFormVisible:false,
      }
    },
    created() {}
  }

</script>
<style>
  .purchase-order-row {
    margin-top: 50px;
  }

  .purchase-order-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
  }

</style>
