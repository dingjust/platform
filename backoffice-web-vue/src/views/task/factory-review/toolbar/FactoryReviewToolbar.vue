<template>
  <div class="review-toolbar">
    <el-form :inline="true">
      <el-form-item label="">
        <el-input placeholder="商家编号/商家名称/登录账号" v-model="queryFormData.keyword" style="width: 180px"></el-input>
      </el-form-item>
      <el-form-item label="注册日期">
        <el-date-picker
          v-model="queryFormData.creationTimeFrom"
          type="date"
          style="width: 130px"
          value-format="timestamp"
          placeholder="开始日期">
        </el-date-picker>
        <el-date-picker
          v-model="queryFormData.creationTimeTo"
          type="date"
          style="width: 130px"
          value-format="timestamp"
          placeholder="截止日期">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="地址">
        <el-input type="text" placeholder="请选择地址" v-popover:addressPopover style="width: 120px" :value="addressText" :title="addressText">
          <template slot="suffix">
            <i class="el-icon-arrow-down"/>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item label="品类" prop="adeptAtCategories">
        <el-select class="w-80"
                  placeholder="请选择"
                  v-model="queryFormData.adeptAtCategories"
                  value-key="code" multiple filterable>
          <el-option-group
            v-for="group in adeptAtCategories"
            :key="group.code"
            :label="group.name">
            <el-option
              v-for="item in group.children"
              :key="item.code"
              :label="item.name"
              :value="item.code">
            </el-option>
          </el-option-group>
        </el-select>
      </el-form-item>
      <el-button-group>
        <el-button style="background-color: #FFD60C" @click="onAdvancedSearch">搜索</el-button>
        <el-button @click="onReset">重置</el-button>
      </el-button-group>
      <el-popover placement="bottom" width="200" trigger="click" ref="addressPopover" >
        <el-form-item label="省" prop="productiveOrientations">
          <el-select v-model="region" style="width: 145px" filterable @change="onRegionChanged">
            <el-option v-for="item in regions"
                      :key="item.isocode"
                      :label="item.name"
                      :value="item.isocode">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="市" prop="cities">
          <el-select style="width: 145px" v-model="queryFormData.cities" multiple filterable @change="recordCities">
            <el-option
              v-for="item in cities"
              :key="item.code"
              :label="item.name"
              :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
      </el-popover>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'FactoryReviewToolbar',
  props: ['queryFormData'],
  data () {
    return {
      addressText: '',
      adeptAtCategories: [],
      regions: [],
      cities: [],
      region: ''
    }
  },
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset () {
      this.queryFormData.keyword = '';
      this.queryFormData.creationTimeFrom = '';
      this.queryFormData.creationTimeTo = '';
      this.queryFormData.adeptAtCategories = [];
      this.queryFormData.cities = [];
      this.region = '';
      this.addressText = '';
      this.queryFormData.productiveOrientations = [];
    },
    async getMinorCategories () {
      const url = this.apis().getMinorCategories();
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.adeptAtCategories = result;
    },
    onRegionChanged (current) {
      if (!current || current == '') {
        this.queryFormData.productiveOrientations = [];
        this.queryFormData.cities = [];
        this.cities = [];
      }
      if (this.queryFormData.productiveOrientations.length == 0) {
        this.queryFormData.productiveOrientations.push(current);
      } else {
        this.queryFormData.productiveOrientations[0] = current;
      }
      this.cities = [];
      this.getCities(current);

      for (let i = 0; i < this.regions.length; i++) {
        if (this.regions[i].isocode == this.region) {
          this.regionText = this.regions[i].name + ':';
        }
      }
      this.addressText = this.regionText;
    },
    recordCities (val) {
      this.citiesText = '';
      this.addressText = this.regionText;
      for (let i = 0; i < this.cities.length; i++) {
        for (let j = 0; j < val.length; j++) {
          if (this.cities[i].code == val[j]) {
            this.citiesText = this.citiesText + '/' + this.cities[i].name;
          }
        }
      }
      this.addressText = this.addressText + this.citiesText.substr(1);
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
    async getCities (isocode) {
      const url = this.apis().getCities(isocode);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.cities = result;
    },
  },
  created () {
    this.getRegions();
    this.getMinorCategories();
  }
}
</script>

<style scoped>

</style>