<template>
  <div>
    <el-dialog :visible.sync="uniquecodeFormVisible" width="30%" class="purchase-dialog" append-to-body>
      <uniquecode-generate-form :slotData="slotData" />
    </el-dialog>
    <el-row>
      <el-col :span="16">
        <purchase-order-info-main :slotData="slotData" />
      </el-col>
      <el-col :span="8">
        <purchase-order-info-aside :slotData="slotData" />
      </el-col>
    </el-row>
    <purchase-orders-button-group :slotData="slotData" @onUniqueCode="onUniqueCode" @onConfirm="onConfirm" @onCreateAgain="onCreateAgain"
      @onCancel="onCancel" />
  </div>
</template>

<script>
  import PurchaseOrderInfoMain from './PurchaseOrderInfoMain';
  import PurchaseOrderInfoAside from './PurchaseOrderInfoAside';
  import UniquecodeGenerateForm from '@/components/custom/UniquecodeGenerateForm';
  import PurchaseOrdersButtonGroup from '../components/PurchaseOrdersButtonGroup';

  export default {
    name: 'PurchaseOrderInfo',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoMain,
      PurchaseOrderInfoAside,
      UniquecodeGenerateForm,
      PurchaseOrdersButtonGroup
    },
    mixins: [],
    computed: {

    },
    methods: {
      onUniqueCode() {
        this.uniquecodeFormVisible = !this.uniquecodeFormVisible;
      },
      onConfirm() {
        this.$confirm('是否确认接单?', '接单', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.confirm();
        });
      },
      async confirm() {
        const url = this.apis().confirmProductionByOffline(this.slotData.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('接单成功');
        this.$set(this.slotData, 'status', 'PENDING_CONFIRM');
      },
      onCancel() {
        this.$confirm('是否确认取消订单?', '取消订单', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.cancel();
        });
      },
      async cancel() {
        const url = this.apis().cancellingOfPurchaseOrder(this.slotData.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('取消成功');
        this.$router.push("order/purchase");
      },
      onCreateAgain(){
        this.$router.push({name:"下单",params:{
          isAgain:true,
          data:this.slotData
        }});
      }
    },
    data() {
      return {
        uniquecodeFormVisible: false,
      }
    },
    created() {}
  }

</script>
<style>
  .purchase-order-row {
    margin-top: 50px;
  }

</style>
