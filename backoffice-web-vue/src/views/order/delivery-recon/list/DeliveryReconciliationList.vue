<template>
  <div>
    <template v-if="orderType === 'DELIVERY'">
      <delivery-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
    </template>
    <template v-if="orderType === 'RECONCILIATION'">
      <reconciliation-orders-list-v2 :page="page" @onAdvancedSearch="onAdvancedSearch"/>
    </template>
  </div>  
</template>

<script>
import DeliveryOrdersList from '../delivery/list/DeliveryOrdersList'
import ReconciliationOrdersListV2 from '../reconciliation/list/ReconciliationOrdersListV2'

export default {
  name: 'DeliveryReconciliationList',
  props: ['page', 'orderType'],
  components: {
    ReconciliationOrdersListV2,
    DeliveryOrdersList
  },
  methods: {
    onAdvancedSearch (page, size) {
      this.$emit('onAdvancedSearch', page, size);
    }
  }
}
</script>

<style scoped>

</style>