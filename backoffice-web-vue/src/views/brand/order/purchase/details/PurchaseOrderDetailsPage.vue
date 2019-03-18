<template>
  <div class="animated fadeIn">
    <purchase-order-form :slot-data="slotData" :read-only="true"/>
  </div>
</template>

<script>
  import PurchaseOrderForm from '../form/PurchaseOrderForm';

  export default {
    name: 'PurchaseOrderDetailsPage',
    props: ['slotData'],
    components: {PurchaseOrderForm},
    mixins: [],
    computed: {},
    methods: {},
    data() {
      return {}
    },
    created() {
    }
  }
</script>
