<template>
  <div>
    <template v-if="orderType === 'DELIVERY'">
      <delivery-orders-list :page="page"/>
    </template>
    <template v-if="orderType === 'RECONCILIATION'">
      <reconciliation-orders-list-v2 :page="page"/>
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
  }
}
</script>

<style scoped>

</style>