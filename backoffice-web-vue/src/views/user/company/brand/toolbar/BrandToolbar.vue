<template>
  <el-form :inline="true">
    <el-row type="flex">
      <el-form-item>
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
      <el-form-item label="优势品类">
        <el-select class="w-80"
                    placeholder="请选择"
                    v-model="queryFormData.adeptAtCategories"
                    value-key="code" multiple>
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
    </el-row>
    <el-popover placement="bottom" width="200" trigger="click" ref="addressPopover">
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
</template>

<script>
import {createNamespacedHelpers} from 'vuex';

const {mapMutations} = createNamespacedHelpers('BrandsModule');

export default {
  name: 'BrandToolbar',
  props: ['hideCreationButton'],
  components: {},
  computed: {},
  methods: {
    ...mapMutations({
      setKeyword: 'keyword',
      setQueryFormData: 'queryFormData'
    }),
    async getCategories () {
      const url = this.apis().getMinorCategories();
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.adeptAtCategories = result;
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
    onRegionChanged (current) {
      if (!current || current == '') {
        this.queryFormData.regions = [];
        this.queryFormData.cities = [];
        this.cities = [];
      }
      if (this.queryFormData.regions.length == 0) {
        this.queryFormData.regions.push(current);
      } else {
        this.queryFormData.regions[0] = current;
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
    async getCities (isocode) {
      const url = this.apis().getCities(isocode);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.cities = result;
    },
    onAdvancedSearch () {
      this.setQueryFormData(this.queryFormData);
      this.visible = false;
      this.$emit('onAdvancedSearch', 0);
    },
    onSearch () {
      this.setKeyword(this.keyword);
      this.$emit('onSearch', 0);
    },
    onNew () {
      let formData = {};
      Object.assign(formData, this.formData);

      this.$emit('onNew', formData);
    },
    onReset () {
      this.queryFormData.keyword = '';
      this.queryFormData.creationTimeFrom = '';
      this.queryFormData.creationTimeTo = '';
      this.queryFormData.adeptAtCategories = [];
      this.queryFormData.cities = [];
      this.region = '';
      this.addressText = '';
      this.queryFormData.regions = [];
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
    }
  },
  data () {
    return {
      visible: false,
      keyword: '',
      formData: this.$store.state.BrandsModule.formData,
      queryFormData: this.$store.state.BrandsModule.queryFormData,
      adeptAtCategories: [],
      regions: [],
      cities: [],
      region: '',
      addressText: '',
      citiesText: '',
      regionText: ''
    }
  },
  created () {
    this.getCategories();
    this.getRegions();
  }
}
</script>

<style scoped>
  /deep/ .el-form-item {
    margin-bottom: 0px;
  }
</style>