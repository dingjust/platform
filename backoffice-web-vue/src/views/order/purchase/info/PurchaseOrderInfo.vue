<template>
  <div>
    <el-dialog :visible.sync="uniquecodeFormVisible" width="30%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <uniquecode-generate-form :slotData="slotData" />
    </el-dialog>
    <el-dialog :visible.sync="receiveFormVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-info-receive :slotData="slotData" @afterCreate="onAfterCreate" />
    </el-dialog>
    <el-dialog :visible.sync="deliverViewsVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-deliver-views :slotData="slotData" @createNewDeliver="onCreateNewDeliver" />
    </el-dialog>
    <el-dialog :visible.sync="deliverFormVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-info-deliver :slotData="slotData" @afterCreate="onAfterCreate" />
    </el-dialog>
    <el-dialog :visible.sync="reconciliatioFormVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-info-reconciliation :slotData="slotData" />
    </el-dialog>
    <el-dialog :visible.sync="addressModifyFormVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-info-address-modify v-if="addressModifyFormVisible" :slotData="slotData"
        @closeAddressModifyFormVisible="closeAddressModifyFormVisible"
        @_updateDeliveryAddress="_updateDeliveryAddress" />
    </el-dialog>
    <el-dialog :visible.sync="purchaseOrderCancelVisible" width="50%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-cancel-dialog v-if="purchaseOrderCancelVisible"
        @closePurchaseOrderCancelVisible="closePurchaseOrderCancelVisible" @_cancel="_cancel" />
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
    <purchase-orders-button-group :slotData="slotData" :contracts="contracts" @onUniqueCode="onUniqueCode"
      @onDeliverViewsOpen="onDeliverViewsOpen" @onCreateAgain="onCreateAgain" @onCreateReceive="onCreateReceive"
      @onUpdate="onUpdate" @onReconciliation="onReconciliation" @onCancel="onCancel" @onRefuse="onRefuse"
      @onConfirm="onConfirm" />
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
  import PurchaseOrderCancelDialog from './PurchaseOrderCancelDialog';

  export default {
    name: 'PurchaseOrderInfo',
    props: ['slotData', 'contracts', 'dialogDetailVisible'],
    components: {
      PurchaseOrderCancelDialog,
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
        this.purchaseOrderCancelVisible = true;
      },
      _cancel(msg) {
        this.$confirm('是否申请取消订单?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.changeCannelStatus(msg);
        });
      },
      async changeCannelStatus(msg) {
        if (this.slotData.cannelStatus == 'APPLYING') {
          this.$message.error('此订单已申请取消');
          return;
        }
        let formData = {
          'cannelStatus': 'APPLYING',
          'cannelMsg': msg
        };
        const url = this.apis().changeCannelStatus(this.slotData.code);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('已申请取消');
        this.purchaseOrderCancelVisible = false;
        this.$emit('closeDialogDetailVisible');
        this.$emit('onSearch')
      },
      onRefuse() {
        this.$confirm('是否确认拒绝订单?', '取消订单', {
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
        this.$emit('closeDialogDetailVisible');
        this.$emit('onSearch')
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
      },
      closePurchaseOrderCancelVisible() {
        this.purchaseOrderCancelVisible = false;
      }
    },
    data() {
      return {
        purchaseOrderCancelVisible: false,
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
