<template>
  <div class="animated fadeIn content">
    <template v-if="isBrand()">
      <brand-details-page :slot-data="company"/>
    </template>
    <template v-else-if="isFactory()">
      <factory-details-page :slot-data="company"/>
    </template>
    <template v-else>
      系统异常，请重新登录
    </template>
  </div>
</template>

<script>
  import BrandDetailsPage from "./brand/details/BrandDetailsPage";
  import FactoryDetailsPage from "./factory/details/FactoryDetailsPage";

  export default {
    name: 'MyCompanyPage',
    components: {FactoryDetailsPage, BrandDetailsPage},
    methods: {},
    data() {
      return {
        // TODO: GET COMPANY
        company: {}
      };
    },
    created() {
    }
  };
</script>
