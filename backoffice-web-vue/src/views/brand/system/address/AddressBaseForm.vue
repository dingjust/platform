<template>
  <el-form ref="form"
           label-position="top"
           :model="slotData"
           :rules="rules"
           :disabled="readOnly"
           :is-newly-created="isNewlyCreated">
    <el-row :gutter="10">
      <el-col :span="8">
        <el-form-item label="姓名" prop="fullname">
          <el-input v-model="slotData.fullname"></el-input>
        </el-form-item>
      </el-col>
      <!--<el-col :span="8">
        <el-form-item label="称呼" prop="title">
          <el-select class="w-100" v-model="slotData.deliveryAddress.title.code">
            <el-option
              v-for="item in titles"
              :key="item.code"
              :label="item.name"
              :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>-->
      <el-col :span="8">
        <el-form-item label="手机号码" prop="cellphone">
          <el-input v-model="slotData.cellphone"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="8">
        <el-form-item label="省" prop="region">
          <el-select class="w-100" v-model="slotData.region.isocode"
                     @change="onRegionChanged">
            <el-option
              v-for="item in regions"
              :key="item.isocode"
              :label="item.name"
              :value="item.isocode">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="市" prop="city">
          <el-select class="w-100" v-model="slotData.city.code"
                     @change="onCityChanged">
            <el-option
              v-for="item in cities"
              :key="item.code"
              :label="item.name"
              :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="区" prop="cityDistrict">
          <el-select class="w-100" v-model="slotData.cityDistrict.code">
            <el-option
              v-for="item in cityDistricts"
              :key="item.code"
              :label="item.name"
              :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-form-item label="街道/小区/门牌" prop="line1">
          <el-input v-model="slotData.line1"></el-input>
        </el-form-item>
      </el-col>
      <!--<el-col :span="12">
        <el-form-item label="备注" prop="remarks">
          <el-input v-model="slotData.deliveryAddress.remarks"></el-input>
        </el-form-item>
      </el-col>-->
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'AddressBaseForm',
    props: ['slotData', 'isNewlyCreated', 'readOnly'],
    methods: {
      getValue() {
        return this.slotData;
      },
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      async getRegions() {
        const result = await this.$http.get('/djbackoffice/address/getRegionsForDefaultCountry');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.regions = result;
        if (this.deliveryAddress.region && this.deliveryAddress.region.isocode) {
          this.onRegionChanged(this.deliveryAddress.region.isocode);
        }
      },
      onRegionChanged(current) {
        if (!current) {
          return;
        }

        this._onRegionChanged(current);
      },
      async _onRegionChanged(current) {
        const result = await this.$http.get('/djbackoffice/address/getCitiesForRegion', {
          regionCode: current
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.cities = result;
        if (this.deliveryAddress.city && this.deliveryAddress.city.code) {
          this.onCityChanged(this.deliveryAddress.city.code);
        }
      },
      onCityChanged(current) {
        if (!current) {
          return;
        }

        this._onCityChanged(current);
      },
      async _onCityChanged(current) {
        const result = await this.$http.get('/djbackoffice/address/getDistrictsForCity', {
          cityCode: current
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.cityDistricts = result;
      },
      refresh() {
        this.onRegionChanged(this.slotData.deliveryAddress.region);
        this.onCityChanged(this.slotData.deliveryAddress.city);
      }
    },
    created() {
      this.deliveryAddress = this.slotData.deliveryAddress;
      this.getRegions();
    },
    computed: {},
    data() {
      return {
        regions: [],
        cities: [],
        cityDistricts: [],
        rules: {
          fullname: [
            {required: true, message: '必填', trigger: 'blur'}
          ],
          cellphone: [
            {required: true, message: '必填', trigger: 'blur'},
            {required: true, message: '手机号码不正确', trigger: 'blur', pattern: 11 && /^((13|14|15|17|18)[0-9]{1}\d{8})$/}
          ],
          region: [
            {required: true, message: '必填', trigger: 'blur'}
          ],
          city: [
            {required: true, message: '必填', trigger: 'blur'}
          ]
        }
      };
    }
  };
</script>
