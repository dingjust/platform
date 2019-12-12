<template>
  <div class="animated fadeIn">
    <!-- <purchase-order-form-toolbar :slot-data="slotData" :read-only="!isNewlyCreated"
                                 @onSubmit="onSubmit"
                                 @onCancel="onCancel"/> -->
    <div class="pt-2"></div>
    <!-- <purchase-order-form :slot-data="slotData" :read-only="!isNewlyCreated"/> -->
    <purchase-order-info :slot-data="slotData" :contracts="contracts" @onSearch="onSearch"
                         @onDetails="onDetails" @closeDialogDetailVisible="closeDialogDetailVisible"/>
    <div class="pt-2"></div>
    <!-- <purchase-order-form-toolbar :slot-data="slotData" :read-only="!isNewlyCreated"
                                 @onSubmit="onSubmit"
                                 @onCancel="onCancel"/> -->
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('PurchaseOrdersModule');

  import PurchaseOrderFormToolbar from '../toolbar/PurchaseOrderFormToolbar';
  import PurchaseOrderForm from '../form/PurchaseOrderForm';
  import PurchaseOrderInfo from '../info/PurchaseOrderInfo';

  export default {
    name: 'PurchaseOrderDetailsPage',
    props: ['slotData', 'contracts', 'dialogDetailVisible'],
    components: {PurchaseOrderFormToolbar, PurchaseOrderForm, PurchaseOrderInfo},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onDetails (row) {
        this.$emit('onDetails', row);
      },
      async onSubmit () {
        // console.log("submitted data: " + JSON.stringify(this.slotData));

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
      onCancel () {
        this.fn.closeSlider();
      },
      confirmDelivering () {

      },
      onSearch () {
        this.$emit('onSearch')
      },
      closeDialogDetailVisible () {
        this.$emit('closeDialogDetailVisible');
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data () {
      return {}
    }
  }
</script>
<style>
  .info-finance-logistics_info-btn1 {
    /* width: 50px; */
    line-height: 8px;
    height: 20px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    text-align: center;
    border: 0px solid #FFD60C;
    padding-bottom: 15px;
  }

  .info-finance-logistics_info-btn3 {
    /* width: 60px; */
    line-height: 8px;
    height: 20px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    text-align: center;
    border: 0px solid #FFD60C;
    padding-bottom: 15px;
  }
</style>
