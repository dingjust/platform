<template>
  <div class="animated fadeIn content">
    <template v-if="isBrand()">
      <brand-details-page :slot-data="company"/>
    </template>
    <template v-else-if="isFactory()">
      <el-card>
        <factory-details-page :slot-data="company" :readOnly="false"/>
      </el-card>
    </template>
    <template v-else>
      系统异常，请重新登录
    </template>
  </div>
</template>

<script>
  import BrandDetailsPage from './brand/details/BrandDetailsPage';
  import FactoryDetailsPage from './factory/details/FactoryDetailsPage';

  export default {
    name: 'MyCompanyPage',
    components: {FactoryDetailsPage, BrandDetailsPage},
    methods: {
      async getFactory () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().getFactory(uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.company = result;
      }
    },
    data () {
      return {
        // TODO: GET COMPANY
        company: {}
      };
    },
    created () {
      if (this.isFactory()) {
        this.getFactory();
      }
    }
  };
</script>
