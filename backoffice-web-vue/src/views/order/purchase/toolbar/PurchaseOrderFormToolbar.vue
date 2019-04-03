<template>
  <div class="animated fadeIn">
    <el-button-group v-if="!readOnly">
      <el-button size="mini" type="primary" @click="onSubmit()">提交</el-button>
      <el-button size="mini" @click="onCancel">取消</el-button>
    </el-button-group>
    <el-button-group>
      <el-button v-if="canConfirmDelivering" size="mini" type="primary"
                 @click="onConfirmDelivering">
        确认发货
      </el-button>
    </el-button-group>

    <el-dialog title="确认发货" :modal="false" :visible.sync="confirmDeliveringDialogVisible"
               :show-close="false" append-to-body>
      <consignment-form ref="consignmentForm" :slot-data="consignmentFormData" :read-only="false"/>
      <span slot="footer" class="dialog-footer">
        <el-button @click="confirmDeliveringDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitConfirmDelivering">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import ConsignmentForm from "@/views/shared/order/consignment/consignment-form";

  export default {
    name: 'PurchaseOrderFormToolbar',
    props: ['slotData', 'readOnly'],
    mixins: [],
    components: {ConsignmentForm},
    computed: {
      canConfirmDelivering: function () {
        return this.slotData.status === 'WAIT_FOR_OUT_OF_STORE' && this.isFactory();
      }
    },
    methods: {
      onSubmit() {
        this.$emit('onSubmit');
      },
      onCancel() {
        this.$emit('onCancel');
      },
      onConfirmDelivering() {
        this._copyConsignment();

        this.confirmDeliveringDialogVisible = true;
      },
      onSubmitConfirmDelivering() {
        this.$refs['consignmentForm'].validate((valid) => {
          if (valid) {
            const url = this.apis().confirmDeliveringOfProductionOrder(this.slotData.code);
            this.$http.put(url, {
              consignment: this.consignmentFormData
            });

            return true;
          }

          return false;
        });
      },
      _copyConsignment() {
        if (this.slotData.consignment) {
          this.consignmentFormData = Object.assign({}, this.slotData.consignment);
        }
      }
    },
    data() {
      return {
        confirmDeliveringDialogVisible: false,
        consignmentFormData: this.$store.state.PurchaseOrdersModule.consignmentFormData,
      }
    },
    created() {
      this._copyConsignment();
    }
  }
</script>
