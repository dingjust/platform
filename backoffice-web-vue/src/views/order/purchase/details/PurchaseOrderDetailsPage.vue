<template>
  <div class="animated fadeIn">
    <purchase-order-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <purchase-order-form :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <purchase-order-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('PurchaseOrdersModule');

  import PurchaseOrderFormToolbar from "../toolbar/PurchaseOrderFormToolbar";
  import PurchaseOrderForm from '../form/PurchaseOrderForm';

  export default {
    name: 'PurchaseOrderDetailsPage',
    props: ['slotData'],
    components: {PurchaseOrderFormToolbar, PurchaseOrderForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      async onSubmit() {
        // console.log("submitted data: " + JSON.stringify(this.slotData));

        const deliveryAddress = this.slotData.deliveryAddress;
        // 地址信息未填时，清除deliveryAddress节点
        if (!deliveryAddress.region || !deliveryAddress.region.isocode) {
          delete this.slotData.deliveryAddress;
        }
        const expectedDeliveryDate = this.slotData.expectedDeliveryDate;
        if (this.compareDate(new Date(), new Date(expectedDeliveryDate))) {
          this.$message.error('交货日期不能小于当前时间');
          return false;
        }
        let url = this.apis().createPurchaseOrder();
        const quoteRef = this.slotData.quoteRef;
        // 根据报价单创建生产订单
        if (quoteRef) {
          url = this.apis().createPurchaseOrderOfQuote(quoteRef);
        }
        const result = await this.$http.post(url, this.slotData);
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('生产订单创建成功，订单号：' + result);

        this.refresh();

        this.fn.closeSlider();
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {}
    }
  }
</script>
