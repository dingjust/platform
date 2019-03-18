<template>
  <address-form :slot-data="slotData.deliveryAddress" :read-only="readOnly"/>
</template>

<script>
  import {AddressForm} from "@/views/shared/";

  export default {
    name: 'ProofingDeliveryAddressForm',
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
