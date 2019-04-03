<template>
  <el-form ref="form"
           label-position="top"
           :model="slotData"
           :disabled="readOnly"
           :rules="rules">
    <el-row :gutter="10">
      <el-col :span="8">
        <el-form-item label="省" prop="region">
          <el-select class="w-100" v-model="slotData.region"
                     value-key="isocode"
                     @change="onRegionChanged">
            <el-option
              v-for="item in regions"
              :key="item.isocode"
              :label="item.name"
              :value="item">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="市" prop="city">
          <el-select class="w-100" v-model="slotData.city" @change="onCityChanged"
                     value-key="code">
            <el-option
              v-for="item in cities"
              :key="item.code"
              :label="item.name"
              :value="item">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="区" prop="cityDistrict">
          <el-select class="w-100" v-model="slotData.cityDistrict"
                     value-key="code">
            <el-option
              v-for="item in cityDistricts"
              :key="item.code"
              :label="item.name"
              :value="item">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="8">
        <el-form-item label="详细地址" prop="line1">
          <el-input v-model="slotData.line1"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="联系人" prop="fullname">
          <el-input v-model="slotData.fullname"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="联系电话" prop="cellphone">
          <el-input v-model="slotData.cellphone"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'AddressForm',
    props: ['slotData', 'readOnly'],
    mixins: [],
    computed: {},
    methods: {
      validate() {
        const fullname = this.slotData.fullname.trim();
        const cellphone = this.slotData.cellphone.trim();
        const region = this.slotData.region;
        const city = this.slotData.city;
        const cityDistrict = this.slotData.cityDistrict;
        const line1 = this.slotData.line1.trim();
        if (!fullname || !cellphone || !region.isocode || !city.code || !cityDistrict.code || !line1) {
          this.$message.error('联系人/联系电话/省/市/区/详细地址 必填');
          return false;
        }

        return true;
      },
      async getRegions() {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.regions = result;
        if (this.slotData.region && this.slotData.region.isocode) {
          this.onRegionChanged(this.slotData.region);
        }
      },
      onRegionChanged(current) {
        if (!current) {
          return;
        }

        this._onRegionChanged(current);
      },
      _onRegionChanged(current) {
        this.cities = [];
        this.$set(this.slotData, 'city', {code: '', name: ''});
        this.$set(this.slotData, 'cityDistrict', {code: '', name: ''});

        this._getCities(current);
        if (this.slotData.city && this.slotData.city.code) {
          this.onCityChanged(this.slotData.city.code);
        }
      },
      async _getCities(region) {
        const result = await this.$http.get('/djwebservices/addresses/' + region.isocode + '/cities');

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.cities = result;
      },
      onCityChanged(current) {
        if (!current) {
          return;
        }

        this._onCityChanged(current);
      },
      async _onCityChanged(current) {
        this.cityDistricts = [];
        this.$set(this.slotData, 'cityDistrict', {code: '', name: ''});

        this._getDistricts(current);
      },
      async _getDistricts(city) {
        const result = await this.$http.get('/djwebservices/addresses/' + city.code + '/districts');

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.cityDistricts =  result;
      },
      refresh() {
        this.onRegionChanged(this.slotData.region);
        this.onCityChanged(this.slotData.city);
      },
      doUpdate() {
        // 直接显示已有的省、市、区
        if (this.slotData.region) {
          this._getCities(this.slotData.region);
        }
        if (this.slotData.city) {
          this._getDistricts(this.slotData.city);
        }
      }
    },
    data() {
      return {
        regions: [],
        cities: [],
        cityDistricts: [],
        rules: {
          fullname: [{required: true, message: '必填', trigger: 'blur'}],
          cellphone: [{required: true, message: '必填', trigger: 'blur'}],
          region: [{required: true, message: '必填', trigger: 'blur'}],
          city: [{required: true, message: '必填', trigger: 'blur'}],
          cityDistrict: [{required: true, message: '必填', trigger: 'blur'}],
          line1: [{required: true, message: '必填', trigger: 'blur'}],
        },
      }
    },
    created() {
      this.getRegions();
    }
  }
</script>
