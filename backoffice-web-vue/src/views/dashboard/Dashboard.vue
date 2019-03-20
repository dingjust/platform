<template>
  <div class="animated fadeIn content">
    <template v-if="isTenant()">
      <tenant-dashboard-page/>
    </template>
    <template v-if="isFactory()">
      <factory-dashboard-page/>
    </template>
  </div>
</template>

<script>
  import TenantDashboardPage from './tenant/TenantDashboardPage';
  import FactoryDashboardPage from './factory/FactoryDashboardPage';

  export default {
    name: 'Dashboard',
    components: {TenantDashboardPage, FactoryDashboardPage},
    data() {
      return {}
    }
  }
</script>
