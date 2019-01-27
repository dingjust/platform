<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData.deliveryAddress"
             :rules="rules"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="姓名" prop="fullname">
            <el-input v-model="slotData.deliveryAddress.fullname"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
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
        </el-col>
        <el-col :span="8">
          <el-form-item label="手机号码" prop="cellphone">
            <el-input v-model="slotData.deliveryAddress.cellphone"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="省" prop="region">
            <el-select class="w-100" v-model="slotData.deliveryAddress.region.isocode"
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
            <el-select class="w-100" v-model="slotData.deliveryAddress.city.code" @change="onCityChanged">
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
            <el-select class="w-100" v-model="slotData.deliveryAddress.cityDistrict.code">
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
            <el-input v-model="slotData.deliveryAddress.line1"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="备注" prop="remarks">
            <el-input v-model="slotData.deliveryAddress.remarks"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    name: 'OrderDeliveryAddressForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      onRegionChanged(current) {
        if (!current) {
          return;
        }

        axios.get('/djbackoffice/address/getCitiesForRegion', {
          params: {
            regionCode: current
          }
        }).then(response => {
          this.cities = response.data;

          if (this.deliveryAddress.city && this.deliveryAddress.city.code) {
            this.onCityChanged(this.deliveryAddress.city.code);
          }
        }).catch(error => {
          console.log(JSON.stringify(error));
          this.$message.error(error.response.data);
        });
      },
      onCityChanged(current) {
        if (!current) {
          return;
        }

        axios.get('/djbackoffice/address/getDistrictsForCity', {
          params: {
            cityCode: current
          }
        }).then(response => {
          this.cityDistricts = response.data;
        }).catch(error => {
          this.$message.error(error.response.data.message);
        });
      },
      refresh() {
        this.onRegionChanged(this.slotData.deliveryAddress.region);
        this.onCityChanged(this.slotData.deliveryAddress.city);
      }
    },
    computed: {},
    data() {
      return {
        titles: [],
        regions: [],
        cities: [],
        cityDistricts: [],
        rules: {
          fullname: [{required: true, message: '必填', trigger: 'blur'}],
          cellphone: [
            {required: true, message: '必填', trigger: 'blur'},
            {required: true, message: '手机号码不正确', trigger: 'blur', pattern: 11 && /^((13|14|15|17|18)[0-9]{1}\d{8})$/}
          ],
          region: [{required: true, message: '必填', trigger: 'blur'}],
          city: [{required: true, message: '必填', trigger: 'blur'}]
        }
      }
    },
    created() {
      this.deliveryAddress = this.slotData.deliveryAddress;

      console.log(JSON.stringify(this.deliveryAddress));
      axios.get('/djbackoffice/address/getRegionsForDefaultCountry')
        .then(response => {
          this.regions = response.data;

          console.log(JSON.stringify(this.deliveryAddress.region));

          if (this.deliveryAddress.region && this.deliveryAddress.region.isocode) {
            this.onRegionChanged(this.deliveryAddress.region.isocode);
          }
        }).catch(error => {
          console.log(JSON.stringify(error));
          this.$message.error(error.response.data);
        }
      );
      axios.get('/djbackoffice/address/getTitles').then(response => {
        this.titles = response.data;
      }).catch(error => {
        console.log(JSON.stringify(error));
        this.$message.error(error.response.data);
      });
    }
  }
</script>
