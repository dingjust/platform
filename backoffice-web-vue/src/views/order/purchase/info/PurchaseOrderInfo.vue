<template>
  <div>
    <el-dialog :visible.sync="uniquecodeFormVisible" width="30%" class="purchase-dialog" append-to-body>
      <uniquecode-generate-form :slotData="slotData" />
    </el-dialog>
    <el-dialog :visible.sync="receiveFormVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-info-receive :slotData="slotData" @afterCreate="onAfterCreate" />
    </el-dialog>
    <el-dialog :visible.sync="deliverViewsVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-deliver-views :slotData="slotData" @createNewDeliver="onCreateNewDeliver" />
    </el-dialog>
    <el-dialog :visible.sync="deliverFormVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-info-deliver :slotData="slotData" @afterCreate="onAfterCreate" />
    </el-dialog>
    <el-dialog :visible.sync="reconciliatioFormVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-info-reconciliation :slotData="slotData" />
    </el-dialog>
    <el-dialog :visible.sync="addressModifyFormVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-info-address-modify :slotData="slotData"
        @closeAddressModifyFormVisible="closeAddressModifyFormVisible"
        @_updateDeliveryAddress="_updateDeliveryAddress" />
    </el-dialog>
    <el-row type="flex" justify="center">
      <span>订单号：{{slotData.code}}</span>
    </el-row>
    <el-row>
      <el-col :span="16">
        <purchase-order-info-main :slotData="slotData" @onAddressModifyFormVisible="onAddressModifyFormVisible" />
      </el-col>
      <el-col :span="8">
        <purchase-order-info-aside :slotData="slotData" :contracts="contracts" />
      </el-col>
    </el-row>
    <purchase-orders-button-group :slotData="slotData" @onUniqueCode="onUniqueCode" @onConfirm="onConfirm"
      @onUpdate="onUpdate" @onDeliverViewsOpen="onDeliverViewsOpen" @onCreateAgain="onCreateAgain"
      @onCreateReceive="onCreateReceive" @onReconciliation="onReconciliation" @onCancel="onCancel" />
  </div>
</template>

<script>
  import PurchaseOrderInfoMain from './PurchaseOrderInfoMain';
  import PurchaseOrderInfoAside from './PurchaseOrderInfoAside';
  import UniquecodeGenerateForm from '@/components/custom/UniquecodeGenerateForm';
  import PurchaseOrdersButtonGroup from '../components/PurchaseOrdersButtonGroup';
  import PurchaseOrderInfoReceive from './PurchaseOrderInfoReceive';
  import PurchaseOrderDeliverViews from './PurchaseOrderDeliverViews';
  import PurchaseOrderInfoReconciliation from './PurchaseOrderInfoReconciliation';
  import PurchaseOrderInfoDeliver from './PurchaseOrderInfoDeliver';
  import PurchaseOrderInfoAddressModify from './PurchaseOrderInfoAddressModify';
  import AddressSelect from '../../../../components/custom/AddressSelect';

  export default {
    name: 'PurchaseOrderInfo',
    props: ['slotData', 'contracts'],
    components: {
      AddressSelect,
      PurchaseOrderInfoAddressModify,
      PurchaseOrderInfoMain,
      PurchaseOrderInfoAside,
      UniquecodeGenerateForm,
      PurchaseOrdersButtonGroup,
      PurchaseOrderInfoReceive,
      PurchaseOrderDeliverViews,
      PurchaseOrderInfoReconciliation,
      PurchaseOrderInfoDeliver
    },
    mixins: [],
    computed: {

    },
    methods: {
      async _updateDeliveryAddress(formData) {
        const url = this.apis().updateDeliveryAddressOfPurchaseOrder(this.slotData.code);
        const result = await this.$http.put(url, {
          'deliveryAddress': formData
        });
        //
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        //
        // // 更新当前的地址，避免调后台
        // this.$set(this.slotData, 'deliveryAddress', formData);
        //
        this.$message.success('地址更新成功');
        let row = {
          'code': result
        };
        this.$emit('onDetails', row);
      },
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
        this.$set(this.slotData, 'status', 'IN_PRODUCTION');
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
        this.$router.push('order/purchase');
      },
      onCreateAgain() {
        this.$router.push({
          name: '下单',
          params: {
            isAgain: true,
            data: this.slotData
          }
        });
      },
      onUpdate() {
        this.$router.push({
          name: "下单",
          params: {
            isUpdate: true,
            data: this.slotData
          }
        });
      },
      onCreateReceive() {
        this.receiveFormVisible = true;
      },
      onAfterCreate() {
        this.receiveFormVisible = false;
        this.deliverFormVisible = false;
      },
      onDeliverViewsOpen() {
        this.deliverFormVisible = true;
      },
      onReconciliation() {
        this.reconciliatioFormVisible = true;
      },
      onCreateNewDeliver() {
        this.deliverViewsVisible = false;
        this.deliverFormVisible = true;
      },
      onAddressModifyFormVisible() {
        this.addressModifyFormVisible = true;
      },
      closeAddressModifyFormVisible() {
        this.addressModifyFormVisible = false;
      }
    },
    data() {
      return {
        uniquecodeFormVisible: false,
        receiveFormVisible: false,
        deliverViewsVisible: false,
        reconciliatioFormVisible: false,
        deliverFormVisible: false,
        addressModifyFormVisible: false,
        deliveryAddress: ''
      }
    },
    created() {

    }
  }

</script>
<style>
  .purchase-order-row {
    margin-top: 50px;
  }

</style>
