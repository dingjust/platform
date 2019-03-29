<template>
  <div class="animated fadeIn content">
    <template v-if="isTenant()">
      <tenant-dashboard-page/>
    </template>
    <template v-if="isFactory()">
      <factory-dashboard-page/>
    </template>
    <template v-if="isBrand()">
      <brand-dashboard-page/>
    </template>
  </div>
</template>

<script>
  import TenantDashboardPage from './tenant/TenantDashboardPage';
  import FactoryDashboardPage from './factory/FactoryDashboardPage';
  import BrandDashboardPage from './brand/BrandDashboardPage';

  export default {
    name: 'Dashboard',
    components: {TenantDashboardPage, FactoryDashboardPage,BrandDashboardPage},
    data() {
      return {}
    }
  }
</script>
