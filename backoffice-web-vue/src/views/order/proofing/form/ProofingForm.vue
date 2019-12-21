<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <proofing-basic-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>待打样产品</span>
      </div>
      <proofing-entries-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card" v-if="!hideOnNew">
      <div slot="header" class="clearfix">
        <span>送货地址</span>
        <span v-if="canUpdateAddress()">
          <el-button class="float-right" type="text" @click="onUpdateAddress">编辑</el-button>
        </span>
      </div>
      <proofing-delivery-address-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <el-dialog title="地址" :modal="false" :visible.sync="addressDialogVisible"
               :show-close="false" append-to-body width="50%" :close-on-click-modal="false">
      <address-form ref="addressForm" :slot-data="addressFormData"/>
      <span slot="footer" class="dialog-footer">
        <el-button @click="onAddressInputCanceled">取 消</el-button>
        <el-button type="primary" @click="onAddressInputConfirmed">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import AddressForm from "@/views/shared/user/address/AddressForm";

  import ProofingBasicForm from "./ProofingBasicForm";
  import ProofingBelongToForm from "./ProofingBelongToForm";
  import ProofingDeliveryAddressForm from "./ProofingDeliveryAddressForm";
  import ProofingEntriesForm from "./ProofingEntriesForm";

  export default {
    name: 'ProofingForm',
    props: ['slotData', 'readOnly'],
    components: {
      AddressForm,
      ProofingBasicForm,
      ProofingBelongToForm,
      ProofingDeliveryAddressForm,
      ProofingEntriesForm,
    },
    computed: {
      // 创建时，工厂不维护地址；由品牌维护
      hideOnNew: function () {
        return !this.readOnly && this.isFactory();
      }
    },
    methods: {
      onUpdateAddress() {
        if (this.slotData.deliveryAddress != null) {
          this.addressFormData = Object.assign({}, this.slotData.deliveryAddress);
        }

        this.addressDialogVisible = true;
      },
      canUpdateAddress() {
        return this.isBrand() && this.slotData.status === 'PENDING_PAYMENT';
      },
      onAddressInputCanceled() {
        this.addressDialogVisible = false;
      },
      onAddressInputConfirmed() {
        if (this.$refs['addressForm'].validate()) {
          this._updateDeliveryAddress();

          this.addressDialogVisible = false;
        }
      },
      async _updateDeliveryAddress() {
        const url = this.apis().updateDeliveryAddressOfProofing(this.slotData.code);
        const result = await this.$http.put(url, {
          deliveryAddress: this.addressFormData
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$set(this.slotData, 'deliveryAddress', this.addressFormData);
        this.$message.success('地址更新成功');
        this.refresh();
      }
    },
    data() {
      return {
        addressDialogVisible: false,
        addressFormData: this.$store.state.ProofingsModule.addressFormData,
      }
    },
    created() {
    }
  }
</script>
