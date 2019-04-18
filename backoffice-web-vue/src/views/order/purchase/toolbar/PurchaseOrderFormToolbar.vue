<template>
  <div class="animated fadeIn">
    <el-button-group v-if="!readOnly">
      <el-button size="mini" type="primary" @click="onSubmit()">提交</el-button>
      <el-button size="mini" @click="onCancel">取消</el-button>
    </el-button-group>
    <el-button-group>
      <el-button v-if="canUpdateAddress" size="mini" type="primary" @click="onUpdateAddress">
        更新地址
      </el-button>
      <el-button v-if="canPay" size="mini" type="primary" @click="onPaying">
        支付
      </el-button>
      <el-button v-if="cancelling" size="mini" type="primary" @click="onCancelling">
        取消
      </el-button>
      <el-button v-if="canConfirmDelivery" size="mini" type="primary" @click="onConfirmDelivering">
        确认发货
      </el-button>
      <el-button v-if="canConfirmCompleted" size="mini" type="primary" @click="onConfirmCompleted">
        确认收货
      </el-button>
    </el-button-group>

    <el-dialog title="地址" :modal="false" :visible.sync="addressDialogVisible"
               :show-close="false" append-to-body width="50%">
      <address-form ref="addressForm" :slot-data="addressFormData"/>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addressDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onAddressInputConfirmed">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog title="确认发货" :modal="false" :visible.sync="confirmDeliveryDialogVisible"
               :show-close="false" append-to-body>
      <consignment-form ref="consignmentForm" :slot-data="consignmentFormData" :read-only="false"/>
      <span slot="footer" class="dialog-footer">
        <el-button @click="confirmDeliveryDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitConfirmDelivering">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import AddressForm from "@/views/shared/user/address/AddressForm";
  import ConsignmentForm from "@/views/shared/order/consignment/consignment-form";

  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('PurchaseOrdersModule');

  export default {
    name: 'PurchaseOrderFormToolbar',
    props: ['slotData', 'readOnly'],
    mixins: [],
    components: {AddressForm, ConsignmentForm},
    computed: {
      canUpdateAddress: function () {
        return this.slotData.status === 'PENDING_PAYMENT' && this.isBrand();
      },
      canPay: function () {
        return this.slotData.status === 'PENDING_PAYMENT' && this.isBrand();
      },
      canConfirmDelivery: function () {
        return this.slotData.status === 'WAIT_FOR_OUT_OF_STORE' && this.isFactory();
      },
      canConfirmCompleted: function () {
        return this.slotData.status === 'OUT_OF_STORE' && this.isBrand();
      },
      cancelling: function () {
        return this.slotData.status === 'PENDING_PAYMENT' && this.isFactory();
      }
    },
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit() {
        this.$emit('onSubmit');
      },
      onCancel() {
        this.$emit('onCancel');
      },
      onUpdateAddress() {
        if (this.slotData.deliveryAddress != null) {
          this.addressFormData = Object.assign({}, this.slotData.deliveryAddress);

          let _this = this;
          this.$nextTick(() => {
            _this.$refs['addressForm'].doUpdate();
          });
        }

        this.addressDialogVisible = true;
      },
      onAddressInputConfirmed() {
        if (this.$refs['addressForm'].validate()) {
          this._updateDeliveryAddress();
          this.refresh();

          this.addressDialogVisible = false;
        }
      },
      async _updateDeliveryAddress() {
        const url = this.apis().updateDeliveryAddressOfPurchaseOrder(this.slotData.code);
        const result = await this.$http.put(url, {
          deliveryAddress: this.addressFormData
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        // 更新当前的地址，避免调后台
        this.$set(this.slotData, 'deliveryAddress', this.addressFormData);

        this.$message.success('地址更新成功');
      },
      async onCancelling() {
        const url = this.apis().cancellingOfPurchaseOrder(this.slotData.code);
        const result = await this.$http.put(url, this.slotData);

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('取消生产单成功');
        this.fn.closeSlider();
      },

      async onConfirmCompleted() {
        const url = this.apis().completedOfPurchaseOrder(this.slotData.code);
        const result = await this.$http.put(url, {});

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('确认收货成功');
        this.fn.closeSlider();
      },
      onConfirmDelivering() {
        this._copyConsignment();

        this.confirmDeliveryDialogVisible = true;
      },
      onSubmitConfirmDelivering() {
        this.$refs['consignmentForm'].validate((valid) => {
          if (valid) {
            this._updateConsignment();
            this.refresh();
            return true;
          }

          return false;
        });
      },
      async _updateConsignment() {
        const url = this.apis().confirmDeliveringOfProductionOrder(this.slotData.code);
        const result = await this.$http.put(url, {
          consignment: this.consignmentFormData
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('地址更新成功');
      },
      onPaying() {
        // check the delivery address is maintain
        if (!this.slotData.deliveryAddress) {
          this.$confirm('地址未维护，支付前请先维护收货地址?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this.onUpdateAddress();
          }).catch(() => {
            console.log("cancel");
          });
        } else {
          // TODO: 生成支付二维码
          this.payDialogVisible = true;
        }
      },
      _copyConsignment() {
        if (this.slotData.consignment) {
          this.consignmentFormData = Object.assign({}, this.slotData.consignment);
        }
      }
    },
    data() {
      return {
        addressDialogVisible: false,
        addressFormData: this.$store.state.PurchaseOrdersModule.addressFormData,
        confirmDeliveryDialogVisible: false,
        consignmentFormData: this.$store.state.PurchaseOrdersModule.consignmentFormData,
        payDialogVisible: false,
      }
    },
    created() {
      this._copyConsignment();
    }
  }
</script>
