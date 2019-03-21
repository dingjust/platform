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
      <el-col :span="12">
        <el-form-item label="详细地址" prop="line1">
          <el-input placeholder="请输入内容" v-model="slotData.line1"></el-input>
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
        const region = this.slotData.region;
        const city = this.slotData.city;
        const cityDistrict = this.slotData.cityDistrict;
        const line1 = this.slotData.line1.trim();
        if (!region.isocode || !city.code || !cityDistrict.code || !line1) {
          this.$message.error('省/市/区/详细地址 必填');
          return false;
        }

        return true;
      },
      async getRegions() {
        const result = await this.$http.get('/djwebservices/addresses/CN/regions');
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
      async _onRegionChanged(current) {
        this.cities = [];
        this.$set(this.slotData, 'city', {code: '', name: ''});
        this.$set(this.slotData, 'cityDistrict', {code: '', name: ''});

        const result = await this.$http.get('/djwebservices/addresses/' + current.isocode + '/cities');

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.cities = result;
        if (this.slotData.city && this.slotData.city.code) {
          this.onCityChanged(this.slotData.city.code);
        }
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
        const result = await this.$http.get('/djwebservices/addresses/' + current.code + '/districts');

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.cityDistricts = result;
      },
      refresh() {
        this.onRegionChanged(this.slotData.region);
        this.onCityChanged(this.slotData.city);
      }
    },
    data() {
      return {
        regions: [],
        cities: [],
        cityDistricts: [],
        rules: {
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
