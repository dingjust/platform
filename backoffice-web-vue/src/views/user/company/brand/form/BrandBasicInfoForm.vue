<template>
  <div class="animated fadeIn factory-basic">
    <el-row>
        <div class="titleClass">
          <h6>基本信息</h6>
        </div>
      </el-row>
      <div style="margin: 20px 20px 40px 40px">
        <el-row type="flex" justify="start" align="middle">
            <el-col :span="2">
              <h6 style="font-size: 12px">
                上传企业
              </h6>
              <h6 style="font-size: 12px">
                &nbsp;&nbsp;LOGO<span style="color: red">*</span>
              </h6>
            </el-col>
            <el-col :span="18">
              <el-form-item prop="profilePicture">
                <images-upload :limit="1" :slot-data="this.profilePictures"/>
                <h6 style="margin-left: 9px;font-size: 10px;color: grey" v-if="!readOnly">只支持.jpg格式</h6>
              </el-form-item>
            </el-col>
<!--            <el-col :span="4">-->
<!--              <el-button size="medium" type="primary" class="toolbar-search_input"-->
<!--                         @click="openProfiles">手机头像设置</el-button>-->
<!--            </el-col>-->
        </el-row>
        <el-row type="flex" justify="start" align="middle">
          <el-col :span="12">
            <el-form-item prop="name">
              <template slot="label">
                <h6 class="titleTextClass">公司名称<span style="color: red">*</span></h6>
              </template>
              <el-row type="flex">
                <el-input placeholder="请填写公司名称" v-model="formData.name" size="mini"
                          :disabled="formData.approvalStatus === 'approved' && !isTenant()"></el-input>
                <el-button type="text" class="authentication-button" @click="$router.push('/account/Authentication')">
                  {{formData.approvalStatus == 'approved' ? '已认证' : '未认证'}}
                </el-button>
              </el-row>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" align="middle" :gutter="20">
          <el-col :span="6">
            <el-form-item prop="duties">
              <template slot="label">
                <h6 class="titleTextClass">职务<span style="color: red">*</span></h6>
              </template>
              <el-input placeholder="职务" v-model="formData.duties" size="mini"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item prop="contactPerson">
              <template slot="label">
                <h6 class="titleTextClass">联系人<span style="color: red">*</span></h6>
              </template>
              <el-input placeholder="联系人" v-model="formData.contactPerson" size="mini"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item prop="contactPhone">
              <template slot="label">
                <h6 class="titleTextClass">手机号码<span style="color: red">*</span></h6>
              </template>
              <el-input placeholder="手机号码" v-model="formData.contactPhone" size="mini"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item prop="phone">
              <template slot="label">
                <h6 class="titleTextClass">座机号码</h6>
              </template>
              <el-input placeholder="座机号码" v-model="formData.phone" size="mini"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item prop="contactAddress" v-if="formData.contactAddress">
          <template slot="label">
            <h6 class="titleTextClass">地址<span style="color: red">*</span></h6>
          </template>
          <el-row  type="flex" align="middle" :gutter="10">
            <el-col :span="3">
              <el-form-item prop="contactAddress.region">
                <el-select class="w-100" v-model="formData.contactAddress.region" size="mini" value-key="isocode"
                           @change="onRegionChanged">
                  <el-option v-for="item in regions" :key="item.isocode" :label="item.name" :value="item">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="3">
            <el-form-item prop="contactAddress.city">
              <el-select class="w-100" size="mini" v-model="formData.contactAddress.city"
                         @change="onCityChanged" value-key="code">
                <el-option v-for="item in (readOnly? readOnlyCities : cities )" :key="item.code" :label="item.name" :value="item">
                </el-option>
              </el-select>
            </el-form-item>
            </el-col>
            <el-col :span="3">
            <el-form-item prop="contactAddress.cityDistrict">
              <el-select class="w-100" size="mini" v-model="formData.contactAddress.cityDistrict"
                         value-key="code" @change="onCityDistrictChanged">
                <el-option v-for="item in (readOnly? readOnlyCityDistricts : cityDistricts )" :key="item.code" :label="item.name"
                           :value="item">
                </el-option>
              </el-select>
            </el-form-item>
            </el-col>
            <el-col :span="6">
            <el-form-item prop="contactAddress.line1">
              <el-input placeholder="填写详细门牌号" v-model="formData.contactAddress.line1" @change="onCityDistrictChanged" size="mini">
              </el-input>
            </el-form-item>
            </el-col>
<!--            <el-form-item>-->
<!--              <el-button style="margin-left: 30px" size="mini" type="primary" class="toolbar-search_input">选择定位</el-button>-->
<!--            </el-form-item>-->
          </el-row>
        </el-form-item>
      </div>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations} = createNamespacedHelpers('BrandsModule');

  import ImagesUpload from '../../../../../components/custom/ImagesUpload';

  export default {
    name: 'BrandBasicInfoForm',
    props: ['formData', 'readOnly'],
    components: {ImagesUpload},
    computed: {
      ...mapGetters({
        labels: 'labels',
        isCitiesChanged: 'isCitiesChanged',
        isDistrictsChanged: 'isDistrictsChanged'
      }),
      cities: {
        get () {
          return this.$store.state.BrandsModule.cities
        },
        set (newValue) {
          this.$store.state.BrandsModule.cities = newValue
        }
      },
      cityDistricts: {
        get () {
          return this.$store.state.BrandsModule.cityDistricts
        },
        set (newValue) {
          this.$store.state.BrandsModule.cityDistricts = newValue
        }
      }
    },
    methods: {
      ...mapMutations({
        setLabels: 'setLabels',
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

        if (result == null || result == undefined) {
          return;
        }
        this.regions = result;
      },
      onRegionChanged (current) {
        console.log(current)
        if (!current) {
          return
        }
        this.formData.contactAddress.id = null;
        this.formData.contactAddress.city = null;
        this.formData.contactAddress.cityDistrict = null;
        this.getCities(current);
        this.cityDistricts = [];
        this.setIsCitiesChanged(true);
        this.setIsDistrictsChanged(true);
      },
      async getCities (region) {
        if (!region) {
          return
        }
        const url = this.apis().getCities(region.isocode);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$store.state.BrandsModule.cities = result
        this.readOnlyCities = result;
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
        if (!city) {
          return;
        }
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$store.state.BrandsModule.cityDistricts = result;
        this.readOnlyCityDistricts = result;
      },
      onCityDistrictChanged () {
        this.formData.contactAddress.id = null;
      }
    },
    data () {
      return {
        profilePictures: [],
        region: '',
        city: '',
        readOnlyCities: [],
        readOnlyCityDistricts: [],
        regions: []
      };
    },
    watch: {
      'profilePictures': function (n, o) {
        if (n != null && n.length > 0) {
          this.formData.profilePicture = n[0];
        } else {
          this.formData.profilePicture = null;
        }
      },
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
    mounted () {
      this.$nextTick(() => {
        this.getRegions();
        if (this.formData.contactAddress.id) {
          this.getCities(this.formData.contactAddress.region);
          this.getCityDistricts(this.formData.contactAddress.city);
        }
      })
    },
    created () {
      if (this.formData.profilePicture != null) {
        this.profilePictures = [this.formData.profilePicture];
      }
      if (this.formData.duties == '') {
        this.formData.duties = '经理';
      }
    }
  };
</script>

<style scoped>
  .factory-basic .rowClass{
    margin-top:20px;
  }

  .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

 .el-col-24 {
   width: auto;
  }

  /deep/ .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 70px;
    font-weight: bold;
    font-size: 10px;
  }

  .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 12px;
    /*font-weight: bold;*/
  }

  .el-input--mini .el-input__inner{
    width: 100%;
  }
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    width:100px;
    height: 100px;
  }
</style>

