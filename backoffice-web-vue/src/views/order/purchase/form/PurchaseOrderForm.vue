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
    </template>
  </div>
</template>

<script>
  import PurchaseOrderBasicForm from "./PurchaseOrderBasicForm";
  import PurchaseOrderSellerForm from "./PurchaseOrderSellerForm";
  import PurchaseOrderDeliveryAddressForm from "./PurchaseOrderDeliveryAddressForm";
  import PurchaseOrderEntriesForm from "./PurchaseOrderEntriesForm";

  export default {
    name: 'PurchaseOrderForm',
    props: ['slotData', 'readOnly'],
    components: {
      PurchaseOrderBasicForm,
      PurchaseOrderSellerForm,
      PurchaseOrderEntriesForm,
      PurchaseOrderDeliveryAddressForm,
    },
    mixins: [],
    computed: {
      // 创建时，工厂不维护地址；由品牌维护
      hideOnNew: function () {
        return !this.readOnly && this.isFactory();
      }
    },
    methods: {},
    data() {
      return {}
    },
    created() {
    }
  }
</script>
