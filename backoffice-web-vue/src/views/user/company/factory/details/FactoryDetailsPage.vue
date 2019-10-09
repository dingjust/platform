<template>
  <div class="animated fadeIn factory-detail">
    <el-card>
      <el-row class="factory-info-title-row" type="flex" justify="space-between">
        <div class="factory-info-title">
          <h6 class="factory-info-title_text">公司信息</h6>
        </div>
        <i class="el-icon-edit" @click="onEdit" style="cursor:pointer;font-size: 20px"></i>
      </el-row>
      <el-row type="flex" :gutter="20">
        <el-col :span="5" class="factory-card-class">
          <factory-card-info-page :slotData="slotData" />
        </el-col>
        <el-col :span="19">
          <el-row type="flex">
            <el-col :span="1">
              <i class="factory-info">&#xe690;</i>
            </el-col>
            <el-col :span="11">
                  <factory-scale-info-page :slotData="slotData"/>
            </el-col>
            <el-divider direction="vertical"></el-divider>
            <el-col :span="1">
              <i class="factory-info">&#xe691;</i>
            </el-col>
            <el-col :span="11" >
              <factory-capacity-info-page :slotData="slotData"/>
            </el-col>
          </el-row>
          <el-divider ></el-divider>
          <!--<el-row type="flex">-->
            <!--<el-col :span="1">-->
              <!--<i class="factory-info">&#xe693;</i>-->
            <!--</el-col>-->
            <!--<el-col :span="11">-->
                  <!--<factory-service-info-page :slotData="slotData"/>-->
            <!--</el-col>-->
            <!--<el-col :span="1">-->

            <!--</el-col>-->
            <!--<el-col :span="11">-->
              <!--&lt;!&ndash;<factory-scale-info-page :slotData="slotData"/>&ndash;&gt;-->
            <!--</el-col>-->
          <!--</el-row>-->
          <!--<el-divider ></el-divider>-->
          <el-row type="flex" style="margin-top: 20px">
            <el-col :span="1">
              <i class="factory-info">&#xe68f;</i>
            </el-col>
            <el-col :span="23">
                  <factory-certificate-info-page :slotData="slotData"/>
            </el-col>
          </el-row>
          <el-divider ></el-divider>
          <el-row type="flex" justify="end"  style="margin-top: 10px">
            <el-button class="buttonClass" @click="onEditProfiles">编辑</el-button>
          </el-row>
          <el-row type="flex">
              <factory-profiles-info-page :slotData="slotData"/>
          </el-row>
        </el-col>
      </el-row>
    </el-card>

    <el-dialog width="80%"
               :visible="factoryFormVisible"
               class="purchase-dialog"
               append-to-body
               @close="onClose">
      <factory-from :formData = "formData" @onSave="onSave" ></factory-from>
    </el-dialog>

    <el-dialog width="80%"
               v-if="factoryProfilesFormVisible"
               :visible.sync="factoryProfilesFormVisible"
               class="purchase-dialog"
               append-to-body>
      <factory-profiles-from :profiles = "formData.profiles" @onSave="onSaveProfiles" ></factory-profiles-from>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('FactoriesModule');

  import FactoryCardInfoPage from '../info/factoryCardInfoPage';
  import FactoryScaleInfoPage from '../info/FactoryScaleInfoPage';
  import FactoryCapacityInfoPage from '../info/FactoryCapacityInfoPage';
  import FactoryServiceInfoPage from '../info/FactoryServiceInfoPage';
  import FactoryCertificateForm from '../form/FactoryCertificateForm';
  import FactoryCertificateInfoPage from '../info/FactoryCertificateInfoPage';
  import FactoryFrom from '../form/FactoryForm';
  import FactoryProfilesInfoPage from "../info/FactoryProfilesInfoPage";
  import FactoryProfilesFrom from "../form/FactoryProfilesForm";

  export default {
    name: 'FactoryDetailsPage',
    props: [],
    components: {
      FactoryProfilesFrom,
      FactoryProfilesInfoPage,
      FactoryFrom,
      FactoryCertificateInfoPage,
      FactoryCertificateForm,
      FactoryServiceInfoPage,
      FactoryCapacityInfoPage,
      FactoryScaleInfoPage,
      FactoryCardInfoPage},
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
        this.slotData = result
      },
      async onEdit () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().getFactory(uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setFormData(Object.assign({}, result));

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
      async onEditProfiles(){
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
        let url = this.apis().updateFactory(uid);
        const result = await this.$http.put(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.getFactory();
        this.factoryProfilesFormVisible = false;
        this.$message.success('编辑图文详情信息成功');
      },
    },
    data () {
      return {
        slotData: '',
        factoryProfilesFormVisible: false
      }
    },
    created () {
      this.getFactory();
    }
  }
</script>

<style scoped>
  .factory-detail .factory-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .factory-detail .factory-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .factory-detail .factory-info-title-row {
    margin-bottom: 20px;
  }

  .factory-detail .el-divider--vertical{
    height: auto;
  }
  .factory-detail .el-divider--horizontal{
    margin: 0px 0px 0px 0px;
  }

  .factory-detail .factory-card-class{
    border-style: solid;
    border-radius: 8px;
    border-width: 1px;
    margin-top: -12px;
    height: fit-content;
  }

  .factory-detail .buttonClass{
    padding: 8px 35px 8px 35px;
    margin-bottom: 10px;
    background-color: #ffd60c;
    color: #0b0e0f;
  }
</style>
