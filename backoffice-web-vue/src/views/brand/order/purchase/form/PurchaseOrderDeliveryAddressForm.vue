<template>
  <address-form :slot-data="slotData.shippingAddress" :read-only="readOnly"/>
</template>

<script>
  import {AddressForm} from "@/views/shared/";

  export default {
    name: 'PurchaseOrderDeliveryAddressForm',
    props: ['slotData', 'readOnly'],
    components: {AddressForm},
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
