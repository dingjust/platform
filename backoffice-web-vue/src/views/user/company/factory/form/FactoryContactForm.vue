<template>
  <div class="animated fadeIn factory-contact">
        <el-row>
          <div class="titleClass">
            <h6>联系方式</h6>
          </div>
        </el-row>
        <div style="margin: 20px 20px 40px 40px">
          <el-row type="flex" align="middle" :gutter="20">
            <el-col :span="8">
              <el-form-item prop="contactPerson">
                <template slot="label">
                  <h6 class="titleTextClass">联系人<span style="color: red">*</span></h6>
                </template>
                <el-input placeholder="联系人" v-model="formData.contactPerson" size="mini"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item prop="contactPhone">
                <template slot="label">
                  <h6 class="titleTextClass">手机号码<span style="color: red">*</span></h6>
                </template>
                <el-input placeholder="手机号码" v-model="formData.contactPhone" size="mini"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item prop="phone">
                <template slot="label">
                  <h6 class="titleTextClass">座机号码</h6>
                </template>
                <el-input placeholder="座机号码" v-model="formData.phone" size="mini"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" align="middle"  :gutter="20">
            <el-col :span="8">
              <el-form-item prop="qq">
                <template slot="label">
                  <h6 class="titleTextClass">QQ号</h6>
                </template>
                <el-input placeholder="请填写QQ号" v-model="formData.qq" size="mini"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item prop="wechat">
                <template slot="label">
                  <h6 class="titleTextClass">微信号</h6>
                </template>
                <el-input placeholder="请填写微信号码" v-model="formData.wechat" size="mini"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item prop="contactAddress">
            <template slot="label">
              <h6 class="titleTextClass">地址<span style="color: red">*</span></h6>
            </template>
            <el-row  type="flex" align="middle">
              <el-form-item prop="contactAddress.region">
                <el-select class="w-100" v-model="formData.contactAddress.region" size="mini" value-key="isocode"
                           @change="onRegionChanged">
                  <el-option v-for="item in regions" :key="item.isocode" :label="item.name" :value="item">
                  </el-option>
                </el-select>
              </el-form-item>
              <el-form-item prop="contactAddress.city">
                <el-select class="w-100" size="mini" v-model="formData.contactAddress.city"
                           @change="onCityChanged" value-key="code">
                  <el-option v-for="item in cities" :key="item.code" :label="item.name" :value="item">
                  </el-option>
                </el-select>
              </el-form-item>
              <el-form-item prop="contactAddress.cityDistrict">
                <el-select class="w-100" size="mini" v-model="formData.contactAddress.cityDistrict"
                           value-key="code" @change="onCityDistrictChanged">
                  <el-option v-for="item in cityDistricts" :key="item.code" :label="item.name"
                             :value="item">
                  </el-option>
                </el-select>
              </el-form-item>
              <el-form-item prop="contactAddress.line1">
                <el-input placeholder="详细地址" v-model="formData.contactAddress.line1" @change="onCityDistrictChanged" size="mini">
                </el-input>
              </el-form-item>
              <el-form-item>
                <el-button size="mini" @click="addressSelectVisible = !addressSelectVisible">选择</el-button>
              </el-form-item>
            </el-row>
          </el-form-item>
        </div>
      <el-dialog :visible.sync="addressSelectVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
        <address-select @onSelect="onAddressSelect" />
      </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import AddressSelect from '../../../../../components/custom/AddressSelect';

  const {mapGetters,mapMutations} = createNamespacedHelpers('FactoriesModule');

  export default {
    name: 'FactoryContactForm',
    props: ['formData'],
    components: {AddressSelect},
    computed: {
      ...mapGetters({
        isCitiesChanged: 'isCitiesChanged',
        isDistrictsChanged: 'isDistrictsChanged',
      }),
      cities: {
        get () {
          return this.$store.state.FactoriesModule.cities
        },
        set (newValue) {
          this.$store.state.FactoriesModule.cities = newValue
        }
      },
      cityDistricts: {
        get () {
          return this.$store.state.FactoriesModule.cityDistricts
        },
        set (newValue) {
          this.$store.state.FactoriesModule.cityDistricts = newValue
        }
      }
    },
    methods: {
      ...mapMutations({
        setIsCitiesChanged: 'setIsCitiesChanged',
        setIsDistrictsChanged: 'setIsDistrictsChanged'
      }),
      async getRegions () {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.regions = result;
      },
      onRegionChanged (current) {
        this.formData.contactAddress.id = null;
        this.formData.contactAddress.city = null;
        this.formData.contactAddress.cityDistrict = null;
        this.getCities(current);
        this.cityDistricts = [];
        this.setIsCitiesChanged(true);
        this.setIsDistrictsChanged(true);
      },
      async getCities (region) {
        const url = this.apis().getCities(region.isocode);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.cities = result;
      },
      onCityChanged (current) {
        if (!current) {
          return;
        }
        this.formData.contactAddress.id = null;
        this.getCityDistricts(current);
        this.setIsDistrictsChanged(true);
      },
      async getCityDistricts (city) {
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.cityDistricts = result;
      },
      onCityDistrictChanged () {
        this.formData.contactAddress.id = null;
      },
      async onAddressSelect (val) {
        console.log(val);
        this.addressSelectVisible = false;
        this.formData.contactAddress = val;
        this.region = val.region;
        this.city = val.city;
      }
    },
    watch: {
      'region': function (n, o) {
        if (n !== '') {
          this.getCities(n);
        }
      },
      'city': function (n, o) {
        if (n !== '') {
          this.getCityDistricts(n);
        }
      }
    },
    data () {
      return {
        region: '',
        city: '',
        regions: [],
        addressSelectVisible: false
      };
    },
    created () {
      this.getRegions();
    }
  };
</script>

<style>
  .factory-contact .rowClass{
    margin-top:20px;
  }

  .factory-contact .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

 .factory-contact .factory-upload {
    margin-left: 80px;
  }

  .factory-contact .factory-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .factory-contact .factory-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .factory-contact .info-input-prepend {
    display: inline-block;
    width: 70px;
    font-weight: bold;
    font-size: 10px;
  }

  .factory-contact .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 10px;
    font-weight: bold;
  }

  .factory-contact .el-input--mini .el-input__inner{
    width: 100%;
  }

</style>
