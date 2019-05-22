<template>
  <div>
    <template v-if="viewMode === VIEW_MODE_TABS">
      <el-card class="box-card">
        <el-tabs value="basic">
          <el-tab-pane label="基本信息" name="basic">
            <purchase-order-basic-form :slot-data="slotData" :read-only="readOnly"/>
          </el-tab-pane>
          <el-tab-pane label="生产工厂" name="belongTo">
            <purchase-order-seller-form :slot-data="slotData" :read-only="readOnly"/>
          </el-tab-pane>
          <el-tab-pane label="待生产产品" name="entries">
            <purchase-order-entries-form :slot-data="slotData" :read-only="readOnly"/>
          </el-tab-pane>
          <el-tab-pane label="送货地址" name="deliveryAddress">
            <purchase-order-delivery-address-form :slot-data="slotData" :read-only="readOnly"/>
          </el-tab-pane>
          <el-tab-pane label="生产进度" name="progress">
            <el-timeline>
              <template v-for="progress in slotData.progresses">
                <el-card>
                  <purchase-order-progress-form :slot-data="progress" :read-only="readOnly"/>
                </el-card>
              </template>
            </el-timeline>
          </el-tab-pane>
        </el-tabs>
      </el-card>
    </template>
    <template v-else>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <span>基本信息</span>
        </div>
        <purchase-order-basic-form :slot-data="slotData" :read-only="readOnly"/>
      </el-card>
      <div class="pt-2"></div>
      <el-card class="box-card" v-if="!isFactory()">
        <div slot="header" class="clearfix">
          <span>生产工厂</span>
        </div>
        <purchase-order-seller-form :slot-data="slotData" :read-only="readOnly"/>
      </el-card>
      <div class="pt-2" v-if="!isFactory()"></div>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <span>待生产产品</span>
        </div>
        <purchase-order-entries-form :slot-data="slotData" :read-only="readOnly"/>
      </el-card>
      <div class="pt-2"></div>
      <el-card class="box-card" v-if="!hideOnNew">
        <div slot="header" class="clearfix">
          <span>送货地址</span>
        </div>
        <purchase-order-delivery-address-form :slot-data="slotData" :read-only="readOnly"/>
      </el-card>
      <div class="pt-2"></div>
      <el-card class="box-card" v-if="!hideOnNew">
        <div slot="header" class="clearfix">
          <span>物流信息</span>
        </div>
        <purchase-order-consignment-form :slot-data="slotData" :read-only="readOnly"/>
      </el-card>
      <div class="pt-2"></div>
      <el-card class="box-card" v-if="showProgress">
        <div slot="header" class="clearfix">
          <span>生产进度</span>
          <el-button v-if="isTenant()" style="float: right; padding: 3px 0" type="text" icon="el-icon-edit"
                     @click="synchronizeVisible = true">
            生产进度同步
          </el-button>
        </div>
        <el-timeline>
          <template v-for="progress in slotData.progresses">
            <el-timeline-item color="#0bbd87" size="large">
              <el-card>
                <purchase-order-progress-form :slot-data="progress" :read-only="readOnly" @onSubmit="progressSubmit"/>
              </el-card>
            </el-timeline-item>
          </template>
        </el-timeline>
      </el-card>
    </template>

    <el-dialog title="生产订单同步" width="600px" :visible.sync="this.synchronizeVisible" :before-close="handleClose"
               append-to-body>
      <el-form>
        <el-form-item label="目标生产单号：">
          <el-input v-model="slotData.targetPurchaseOrderCode" placeholder="请输入目标生产单号" clearable autosize></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="onSynchronizeProgress()">同步</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import PurchaseOrderBasicForm from "./PurchaseOrderBasicForm";
  import PurchaseOrderSellerForm from "./PurchaseOrderSellerForm";
  import PurchaseOrderEntriesForm from "./PurchaseOrderEntriesForm";
  import PurchaseOrderDeliveryAddressForm from "./PurchaseOrderDeliveryAddressForm";
  import PurchaseOrderConsignmentForm from "./PurchaseOrderConsignmentForm";
  import PurchaseOrderProgressForm from "./PurchaseOrderProgressForm";

  export default {
    name: 'PurchaseOrderForm',
    props: ['slotData', 'readOnly'],
    components: {
      PurchaseOrderBasicForm,
      PurchaseOrderSellerForm,
      PurchaseOrderEntriesForm,
      PurchaseOrderDeliveryAddressForm,
      PurchaseOrderConsignmentForm,
      PurchaseOrderProgressForm,
    },
    mixins: [],
    computed: {
      // 创建时，工厂不维护地址；由品牌维护
      hideOnNew: function () {
        return !this.readOnly && this.isFactory();
      },
      showProgress: function () {
        return this.slotData.status != 'PENDING_PAYMENT' && this.slotData.status != 'CANCELLED';
      }
    },
    methods: {
      handleClose(done) {
        this.synchronizeVisible = false;
      },
      submit() {
        this.$emit('onSubmit', this.slotData);
        this.synchronizeVisible = false;
      },
      async progressSubmit(data) {
        let formData = data;
        const estimatedDate = formData.estimatedDate;
        if (this.compareDate(new Date(), new Date(estimatedDate))) {
          this.$message.error('预计完成时间不能小于当前时间');
          return false;
        }
        const url = this.apis().updateProgressOfPurchaseOrder(this.slotData.code, formData.id);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('更新成功');

      },
      async onSynchronizeProgress() {
        const url = this.apis().synchronizeProgress(this.slotData.code, this.slotData.targetPurchaseOrderCode);
        const result = await this.$http.put(url, {});
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('同步成功');
        this.fn.closeSlider();
      }
    },
    data() {
      return {
        synchronizeVisible:false,
      }
    },
    created() {
    }
  }
</script>
