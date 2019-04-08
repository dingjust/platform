<template>
  <div class="animated fadeIn">
    <template v-if="slotData.deliveryAddress&& slotData.consignment.trackingID">
      <consignment-form :slot-data="slotData.consignment" :read-only="true"/>
    </template>
    <template v-else>
      物流信息未维护
    </template>
  </div>
</template>

<script>
  import ConsignmentForm from "@/views/shared/order/consignment/consignment-form";

  export default {
    name: 'PurchaseOrderConsignmentForm',
    components: {ConsignmentForm},
    props: ['slotData', 'readOnly'],
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
