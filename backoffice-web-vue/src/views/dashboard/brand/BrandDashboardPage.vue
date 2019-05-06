<template>
  <div class="animated fadeIn content">
    <purchase-order-page></purchase-order-page>
  </div>
</template>

<script>

  import PurchaseOrderPage from '@/views/order/purchase/PurchaseOrderPage';


  export default {
    name: 'BrandDashboardPage',
    components: {
      PurchaseOrderPage,
    },
    computed: {
    },
    methods: {

    },
    data() {
      return {
      };
    },
    created() {
    }
  };
</script>
