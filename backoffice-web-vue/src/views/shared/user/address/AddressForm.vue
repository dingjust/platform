<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
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
            <el-select class="w-100" v-model="slotData.city.code" @change="onCityChanged">
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
          <el-form-item label="详细地址" prop="line1">
            <el-input type="textarea"
                      :rows="2"
                      placeholder="请输入内容"
                      v-model="slotData.line1">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'AddressForm',
    props: ['slotData', 'readOnly'],
    mixins: [],
    computed: {},
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      async getRegions() {
        const result = await this.$http.get('/djwebservices/addresses/CN/regions');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.regions = result;
        if (this.slotData.region && this.slotData.region.isocode) {
          this.onRegionChanged(this.slotData.region.isocode);
        }
      },
      onRegionChanged(current) {
        if (!current) {
          return;
        }

        this._onRegionChanged(current);
      },
      async _onRegionChanged(current) {
        const result = await this.$http.get('/djwebservices/addresses/' + current + '/cities');

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
        const result = await this.$http.get('/djwebservices/addresses/' + current + '/districts');

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
        cityDistricts: []
      }
    },
    created() {
      this.getRegions();
    }
  }
</script>
