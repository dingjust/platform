<template>
  <div class="animated fadeIn">
    <template v-if="slotData.deliveryAddress != null && slotData.deliveryAddress.id != null">
      <address-form v-if="" :slot-data="slotData.deliveryAddress" :read-only="readOnly"/>
    </template>
    <template v-else>
      地址信息未维护
    </template>
  </div>
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
