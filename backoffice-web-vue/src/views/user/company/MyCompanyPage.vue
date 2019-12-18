<template>
  <div class="animated fadeIn content">
    <template v-if="isBrand()">
      <brand-details-page/>
    </template>
    <template v-else-if="isFactory()">
      <el-card>
        <factory-from :formData = "formData" @onSave="onSave" @onSaveProfiles="onSaveProfiles"></factory-from>
      </el-card>
    </template>
    <template v-else>
      系统异常，请重新登录
    </template>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('FactoriesModule');

  import BrandDetailsPage from './brand/details/BrandDetailsPage';
  import FactoryDetailsPage from './factory/details/FactoryDetailsPage';
  import FactoryFrom from './factory/form/FactoryForm';

  export default {
    name: 'MyCompanyPage',
    components: {FactoryFrom, FactoryDetailsPage, BrandDetailsPage},
    computed: {
      ...mapGetters({
        formData: 'formData',
        factoryFormVisible: 'factoryFormVisible',
        isCitiesChanged: 'isCitiesChanged',
        isDistrictsChanged: 'isDistrictsChanged',
        cities: 'cities',
        cityDistricts: 'cityDistricts'
      })
    },
    methods: {
      ...mapMutations({
        setFormData: 'setFormData',
        setFactoryFormVisible: 'setFactoryFormVisible',
        setIsCitiesChanged: 'setIsCitiesChanged',
        setIsDistrictsChanged: 'setIsDistrictsChanged'
      }),
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
      async getFactory () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().getFactory(uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setFormData(Object.assign({}, Object.assign(this.formData, result)));

        if ((this.formData.contactAddress.region != null && this.isCitiesChanged) || this.cities.length <= 0) {
          this.getCities(this.formData.contactAddress.region);
          this.setIsCitiesChanged(false);
        }
        if ((this.formData.contactAddress.city != null && this.isDistrictsChanged) || this.cities.length <= 0) {
          this.getCityDistricts(this.formData.contactAddress.city);
          this.setIsDistrictsChanged(false);
        }

        this.setFactoryFormVisible(true);
      },
      async onSave () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().updateFactory(uid);
        const result = await this.$http.put(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.getFactory();
        this.setFactoryFormVisible(false);
        this.$message.success('编辑工厂信息成功');
      },
      async getRegions () {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.regions = result;
      },
      async getCities (region, index) {
        const url = this.apis().getCities(region.isocode);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$store.state.FactoriesModule.cities = result;
      },
      async getCityDistricts (city) {
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$store.state.FactoriesModule.cityDistricts = result;
      },
      onClose () {
        this.setFactoryFormVisible(false);
      },
      async onEditProfiles () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().getFactory(uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.setFormData(Object.assign({}, result));
        this.factoryProfilesFormVisible = !this.factoryProfilesFormVisible;
      },
      async onSaveProfiles () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().updateFactoryProfiles(uid);
        const result = await this.$http.put(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.getFactory();
        this.factoryProfilesFormVisible = false;
        this.$message.success('编辑图文详情信息成功');
      }
    },
    data () {
      return {

      };
    },
    created () {
      if (this.isFactory()) {
        this.getFactory();
      }
    }
  };
</script>
