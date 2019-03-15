<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <purchase-order-basic-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>生产工厂</span>
      </div>
      <purchase-order-seller-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>待生产商品</span>
      </div>
      <purchase-order-entries-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>送货地址</span>
      </div>
      <purchase-order-delivery-address-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit()">提交</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
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
    computed: {},
    methods: {
      async onSubmit() {
        console.log("submitted data: " + JSON.stringify(this.slotData));

        const deliveryAddress = this.slotData.deliveryAddress;
        // 地址信息未填时，清除deliveryAddress节点
        if (!deliveryAddress.region || !deliveryAddress.region.isocode) {
          delete this.slotData.deliveryAddress;
        }

        const result = await this.$http.post('/b2b/orders/purchase/create', this.slotData);
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('生产订单创建成功，订单号：' + result);
        this.fn.closeSlider();
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    data() {
      return {}
    },
    created() {
    }
  }
</script>
