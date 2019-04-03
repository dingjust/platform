<template>
  <div class="animated fadeIn">
    <consignment-form :slot-data="slotData.consignment" :read-only="true"/>
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
