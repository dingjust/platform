<template>
  <div class="animated fadeIn">
    <el-card>
        <brand-from1 :formData = "formData" @onSave="onSave"></brand-from1>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import BrandFrom1 from '../form/BrandForm1';

  const {mapGetters, mapMutations} = createNamespacedHelpers('BrandsModule');

  export default {
    name: 'BrandDetailsPage',
    props: {
      slotData: {
        type: Object
      },
      readOnly: {
        type: Boolean,
        default: true
      },
      count: {
        type: Number,
        default: 0
      }
    },
    components: {BrandFrom1},
    computed: {
      ...mapGetters({
        formData: 'formData',
        isCitiesChanged: 'isCitiesChanged',
        isDistrictsChanged: 'isDistrictsChanged',
        cities: 'cities',
        cityDistricts: 'cityDistricts',
        brandFormVisible: 'brandFormVisible'
      })
    },
    methods: {
      ...mapMutations({
        setFormData: 'setFormData',
        setIsCitiesChanged: 'setIsCitiesChanged',
        setIsDistrictsChanged: 'setIsDistrictsChanged',
        setBrandFormVisible: 'setBrandFormVisible'
      }),
      async getBrand () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().getBrand(uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setFormData(Object.assign({}, Object.assign(this.formData, result)));

        if ((this.formData.contactAddress.region != null && this.isCitiesChanged) || this.cities.length <= 0) {
          if (this.formData.contactAddress.region.isocode != '') {
            this.getCities(this.formData.contactAddress.region);
            this.setIsCitiesChanged(false);
          }
        }
        if ((this.formData.contactAddress.city != null && this.isDistrictsChanged) || this.cities.length <= 0) {
          if (this.formData.contactAddress.city != null && this.formData.contactAddress.city.code != '') {
            this.getCityDistricts(this.formData.contactAddress.city);
            this.setIsDistrictsChanged(false);
          }
        }

        this.setBrandFormVisible(true);
      },
      async onSave () {
        let data = Object.assign({}, this.formData);
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().updateBrand(uid);
        const result = await this.$http.put(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.getBrand();
        this.setBrandFormVisible(false);
        this.$message.success('编辑品牌信息成功');
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

        this.$store.state.BrandsModule.cities = result;
      },
      async getCityDistricts (city) {
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$store.state.BrandsModule.cityDistricts = result;
      }
    },
    watch: {
      formData: {
        handler (val) {
          if (val) {
            this.$emit('brandLeaveCount');
          }
        },
        deep: true
      }
    },
    data () {
      return {

      }
    },
    created () {
      this.getBrand();
    }
  }
</script>

<style scoped>
  .brand-detail .brand-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .brand-detail .brand-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .brand-detail .brand-info-title-row {
    margin-bottom: 20px;
  }

  .brand-detail .el-divider--vertical{
    height: auto;
  }
  .brand-detail >>> .el-divider--horizontal{
    margin: 0px 0px 0px 0px;
  }

  .brand-detail .brand-card-class{
    border-style: solid;
    border-radius: 8px;
    border-width: 1px;
    margin-top: -12px;
  }

  .brand-detail .buttonClass{
    padding: 8px 35px 8px 35px;
    margin-bottom: 10px;
    background-color: #ffd60c;
    color: #0b0e0f;
  }
</style>
