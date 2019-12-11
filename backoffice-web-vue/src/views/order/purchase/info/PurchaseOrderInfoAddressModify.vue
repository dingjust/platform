<template>
  <div>
    <el-dialog :visible.sync="addressSelectVisible" width="60%" class="purchase-dialog" append-to-body>
      <address-select v-if="addressSelectVisible" @onSelect="onAddressSelect" />
    </el-dialog>
    <el-form :model="form" ref="form">
      <el-row class="info-order-row" type="flex">
        <h6 class="info-input-prepend">送货地址</h6>
      </el-row>
      <el-row :gutter="10" class="info-order-row" type="flex">
        <el-col :span="4">
          <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择省', trigger: 'change'}]" :prop="'address.region'">
            <el-row type="flex" align="middle">
              <el-select class="w-100" v-model="form.address.region" value-key="isocode"
                         @change="(val)=>onRegionChanged(val)">
                <el-option v-for="item in regions" :key="item.isocode" :label="item.name" :value="item">
                </el-option>
              </el-select>
            </el-row>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择市', trigger: 'change'}]" prop="address.city">
            <el-select class="w-100" v-model="form.address.city" @change="(val)=>onCityChanged(val)"
                       value-key="code">
              <el-option v-for="item in form.cities" :key="item.code" :label="item.name" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择区', trigger: 'change'}]" prop="address.cityDistrict">
            <el-select class="w-100" v-model="form.address.cityDistrict" value-key="code">
              <el-option v-for="item in form.cityDistricts" :key="item.code" :label="item.name" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请详细地址', trigger: 'change'}]" prop="address.line1">
            <el-row type="flex" align="middle">
              <el-input placeholder="详细地址" v-model="form.address.line1" size="mini">
              </el-input>
            </el-row>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-button style="margin-top: 2px" size="mini" @click="addressSelect">选择</el-button>
        </el-col>
      </el-row>
      <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="20">
        <el-col :span="6">
          <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请填写收货人', trigger: 'blur'}]" prop="address.fullname">
            <el-row>
              <h6 class="info-input-prepend">收货人</h6>
            </el-row>
            <el-row type="flex" align="middle">
              <el-input placeholder="名称" v-model="form.address.fullname" size="mini">
              </el-input>
            </el-row>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请填写联系方式', trigger: 'blur'}]" prop="address.cellphone">
            <el-row>
              <h6 class="info-input-prepend">联系方式</h6>
            </el-row>
            <el-row type="flex" align="middle">
              <el-input placeholder="电话" v-model="form.address.cellphone" size="mini">
              </el-input>
            </el-row>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row class="categoryt-form" type="flex" justify="center" align="middle" :gutter="100">
        <el-col :span="6">
          <el-button class="btn-block" size="mini" @click="onCancel">
            取消
          </el-button>
        </el-col>
        <el-col :span="6">
          <el-button class="btn-block" size="mini" type="primary" @click="onUpdateAddress">
            提交
          </el-button>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
    import AddressSelect from '../../../../components/custom/AddressSelect';
    export default {
      name: 'PurchaseOrderInfoAddressModify',
      components: {AddressSelect},
      props: ['slotData'],
      computed: {

      },
      methods: {
        onCancel () {
          this.$emit('closeAddressModifyFormVisible');
        },
        onUpdateAddress () {
          this.$refs['form'].validate((valid) => {
            if (valid) {
              this.$confirm('是否确认更改地址', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
              }).then(() => {
                this._updateDeliveryAddress();
              });
            } else {
              this.$message.error('请完善需求信息');
              return false;
            }
          });
        },
        _updateDeliveryAddress () {
          let data = {
            'id': this.slotData.deliveryAddress.id,
            'region': this.form.address.region,
            'city': this.form.address.city,
            'cityDistrict': this.form.address.cityDistrict,
            'line1': this.form.address.line1,
            'fullname': this.form.address.fullname,
            'cellphone': this.form.address.cellphone
          };
          let formData = Object.assign({}, data);
          this.$emit('_updateDeliveryAddress', formData);
          this.$emit('closeAddressModifyFormVisible');
        },
        addressSelect () {
          this.addressSelectVisible = !this.addressSelectVisible;
        },
        async onAddressSelect (val) {
          this.addressSelectVisible = false;
          this.form.address = val;
          this.getCities(val.region);
          const url = this.apis().getDistricts(val.city.code);
          const result = await this.$http.get(url);

          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }

          this.form.cityDistricts = result;
        },
        onRegionChanged (current) {
          if (!current || current.isocode == '') {
            return;
          }

          this._onRegionChanged(current);
        },
        _onRegionChanged (current) {
          this.form.cities = [];
          this.$delete(this.form.address, 'city');
          this.$delete(this.form.address, 'cityDistrict');
          // this.$set(this.form.address, 'city', {
          //   code: '',
          //   name: ''
          // });
          // this.$set(this.form.address, 'cityDistrict', {
          //   code: '',
          //   name: ''
          // });
          this.getCities(current);
          if (this.form.address.city && this.form.address.city.code) {
            this.onCityChanged(this.form.address.city.code);
          }
        },
        async getCities (region) {
          const url = this.apis().getCities(region.isocode);
          const result = await this.$http.get(url);

          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }

          this.form.cities = result;
        },
        onCityChanged (current) {
          if (!current) {
            return;
          }
          this._onCityChanged(current);
        },
        async _onCityChanged (city) {
          this.form.cityDistricts.clear;
          const url = this.apis().getDistricts(city.code);
          const result = await this.$http.get(url);

          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.form.cityDistricts = result;
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
        async initialDisplay (val) {
          this.getCities(val.region);
          const url = this.apis().getDistricts(val.city.code);
          const result = await this.$http.get(url);

          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }

          this.form.cityDistricts = result;
        }
      },
      data () {
        return {
          addressSelectVisible: false,
          regions: [],
          form: {
            cities: [],
            cityDistricts: [],
            address: {
              city: '',
              cityDistrict: '',
              region: '',
              line1: '',
              fullname: '',
              cellphone: ''
            }
          }
        }
      },
      created () {
        this.form.address = Object.assign({}, this.slotData.deliveryAddress);
        this.initialDisplay(this.form.address);
        this.getRegions();
      }
    }
</script>

<style scoped>
  .info-order-row {
    margin-bottom: 20px;
  }
  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 60px;
    font-weight: bold;
    font-size: 10px;
  }
  .categoryt-form {
    margin-left: 20px;
    margin-top: 20px;
  }
</style>
