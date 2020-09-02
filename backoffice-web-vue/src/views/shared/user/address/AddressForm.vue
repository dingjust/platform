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
          <el-autocomplete
            v-if="isCompany"
            v-model="slotData.line1"
            :fetch-suggestions="querySearchAsync"
            placeholder="请输入详细地址"
            @select="handleSelect"
          >
            <template slot-scope="{ item }">
              <div class="addr">{{ item.name }}</div>
            </template>
          </el-autocomplete>
          <el-input v-if="!isCompany" v-model="slotData.line1"></el-input>
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
    props: ['slotData', 'readOnly','isCompany'],
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
      async querySearchAsync(queryString, cb) {
        const url = this.apis().getAmapTips('16019b7f1babc4b2d81010730bad2504',this.slotData.line1,this.slotData.city.name);
        const result = await this.$http.get(url);
        clearTimeout(this.timeout);
        this.timeout = setTimeout(() => {
          cb(result.tips);
        }, 500 * Math.random());
      },
      handleSelect(item) {
        this.slotData.line1 = item.name;
        let locals = item.location.split(',');
        this.slotData.longitude =locals[0];
        this.slotData.latitude =locals[1];
      },
      async getRegions() {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.regions = result;
      },
      onRegionChanged(current) {
        if (!current||current.isocode=='') {
          return;
        }

        this._onRegionChanged(current);
      },
      _onRegionChanged(current) {
        this.cities = [];
        this.$set(this.slotData, 'city', {code: '', name: ''});
        this.$set(this.slotData, 'cityDistrict', {code: '', name: ''});

        this.getCities(current);
        if (this.slotData.city && this.slotData.city.code) {
          this.onCityChanged(this.slotData.city.code);
        }
      },
      async getCities(region) {
        const url = this.apis().getCities(region.isocode);
        const result = await this.$http.get(url);

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
        this.getDistricts(current);
      },
      async getDistricts(city) {
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

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
        if (this.slotData.region&&this.slotData.region.isocode) {
          this.getCities(this.slotData.region);
        }

        if (this.slotData.city&&this.slotData.city.code) {
          this.getDistricts(this.slotData.city);
        }
      }
    },
    data() {
      var validateAddress = (rule, value, callback) => {
        if (!value.name || value.name === '') {
          callback(new Error('请选择'));
        } else {
          callback();
        }
      };
      var validatePhone = async (rule, value, callback) => {
        const reg = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
        if (value === '') {
          callback(new Error('请输入手机号码'));
        } else if (!reg.test(value)) {
          callback(new Error('请输入合法手机号码'));
        } else {
          callback();
        }
      };
      return {
        regions: [],
        cities: [],
        cityDistricts: [],
        rules: {
          fullname: [{required: true, message: '必填', trigger: 'change'}],
          cellphone: [{required: true,validator: validatePhone, trigger: 'change'}],
          region: [{required: true, validator: validateAddress, trigger: 'change'}],
          city: [{required: true, validator: validateAddress, trigger: 'change'}],
          cityDistrict: [{required: true, validator: validateAddress, trigger: 'change'}],
          line1: [{required: true, message: '必填', trigger: 'change'}],
        },
      }
    },
    created() {
      this.getRegions();

      this.doUpdate();
    }
  }
</script>
