<template>
  <!-- 订单表单组件:地址选择 -->
  <div>
    <el-dialog :visible.sync="addressSelectVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <address-select @onSelect="onAddressSelect" />
    </el-dialog>
    <el-form ref="address" :model="address" label-position="left">
      <el-row type="flex" align="middle" :gutter="10" justify="space-between">
        <el-col :span="7">
          <el-form-item label="送货地址" style="padding-top:8px" :rules="[
                { required: true, message: '请选择省', trigger: 'blur'}]" :prop="'region'">
            <el-select v-model="address.region" value-key="isocode" @change="(val)=>onRegionChanged(val)"
              placeholder="选择省份">
              <el-option v-for="item in regions" :key="item.isocode" :label="item.name" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item :rules="[
                { required: true, message: '请选择市', trigger: 'blur'}]" prop="city">
            <el-select v-model="address.city" @change="(val)=>onCityChanged(val)" value-key="code" placeholder="选择城市">
              <el-option v-for="item in cities" :key="item.code" :label="item.name" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item :rules="[
                { required: true, message: '请选择区', trigger: 'blur'}]" prop="cityDistrict">
            <el-select v-model="address.cityDistrict" value-key="code" placeholder="选择县区">
              <el-option v-for="item in cityDistricts" :key="item.code" :label="item.name" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item :rules="[
                { required: true, message: '请详细地址', trigger: 'blur'}]" prop="line1">
            <el-input placeholder="详细地址" v-model="address.line1" size="mini">
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="3">
          <el-form-item>
            <el-button size="mini" @click="addressSelect">选择</el-button>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" align="middle" :gutter="10">
        <el-col :span="6">
          <el-form-item label="联系人" label-width="80px" :rules="[
                { required: true, message: '请填写收货人', trigger: 'blur'}]" prop="fullname">
            <el-input placeholder="名称" v-model="address.fullname" size="mini">
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系方式" label-width="80px" :rules="[
                { required: true, message: '请填写联系方式', trigger: 'blur'}]" prop="cellphone">
            <el-input placeholder="电话" v-model="address.cellphone" size="mini">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import AddressSelect from '@/components/custom/AddressSelect';

  export default {
    name: 'MyAddressForm',
    components: {
      AddressSelect
    },
    props: {
      vAddress: {
        type: Object,
        default: {
          region: '',
          city: '',
          cityDistrict: '',
          line1: ''
        }
      },
    },
    methods: {
      addressSelect() {
        this.addressSelectVisible = !this.addressSelectVisible;
      },
      async onAddressSelect(val) {
        this.addressSelectVisible = false;
        this.address = val;
        this.getCities(val.region);
        const url = this.apis().getDistricts(val.city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.cityDistricts = result;
      },
      async getRegions() {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.regions = result;
      },
      onRegionChanged(current) {
        if (!current || current.isocode == '') {
          return;
        }

        this._onRegionChanged(current);
      },
      _onRegionChanged(current) {
        this.cities = [];
        this.$set(this.address, 'city', {
          code: '',
          name: ''
        });
        this.$set(this.address, 'cityDistrict', {
          code: '',
          name: ''
        });
        this.getCities(current);
        if (this.address.city && this.address.city.code) {
          this.onCityChanged(this.address.city.code);
        }
      },
      async getCities(region) {
        const url = this.apis().getCities(region.isocode);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
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
      async _onCityChanged(city) {
        this.cityDistricts.clear;
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.cityDistricts = result;
      },
    },
    data() {
      return {
        address: {
          region: '',
          city: '',
          cityDistrict: '',
          line1: ''
        },
        regions: [],
        cities: [],
        cityDistricts: [],
        addressSelectVisible: false
      };
    },
    watch: {
      vAddress: function (newVal, oldVal) {
        this.address = newVal;
      },
      address: function (newVal, oldVal) {
        this.$emit("update:vAddress", newVal);
      },
    },
    created() {
      this.getRegions();

    }
  }

</script>

<style>

</style>
