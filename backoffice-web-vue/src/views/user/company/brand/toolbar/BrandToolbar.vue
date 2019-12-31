<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入名称" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button v-if="!hideCreationButton" type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click" v-model="visible">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="关键字">
            <el-input placeholder="请输入关键字" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="联系方式">
            <el-input placeholder="请输入联系方式" v-model="queryFormData.contactPhone"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="合作品牌">
            <el-input placeholder="请输入合作品牌" v-model="queryFormData.cooperativeBrand"></el-input>
          </el-form-item>
        </el-col>

      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="优势品类">
            <el-select class="w-100"
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
        </el-col>
        <el-col :span="8">
          <el-form-item label="省" prop="productiveOrientations">
            <el-select v-model="region" class="w-100" filterable @change="onRegionChanged">
              <el-option v-for="item in regions"
                         :key="item.isocode"
                         :label="item.name"
                         :value="item.isocode">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="市" prop="cities">
            <el-select class="w-100" v-model="queryFormData.cities" multiple filterable>
              <el-option
                v-for="item in cities"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
        <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="创建时间从">
            <el-date-picker
              v-model="queryFormData.creationTimeFrom"
              value-format="timestamp"
              type="date"
              placeholder="请选择工厂创建时间">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="创建时间到">
            <el-date-picker
              v-model="queryFormData.creationTimeTo"
              value-format="timestamp"
              type="date"
              placeholder="请选择工厂创建时间">
            </el-date-picker>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-button type="primary" icon="el-icon-search" @click="onAdvancedSearch">查询</el-button>
        </el-col>
      </el-row>
      <el-button-group slot="reference">
        <el-button type="primary">高级查询</el-button>
      </el-button-group>
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
        setQueryFormData: 'queryFormData',
      }),
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.adeptAtCategories = result;
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
        if (!current||current=='') {
          this.queryFormData.regions = [];
          this.queryFormData.cities = [];
          this.cities = [];
        }
        if(this.queryFormData.regions.length==0){
          this.queryFormData.regions.push(current);
        }else {
          this.queryFormData.regions[0]=current;
        }
        console.log(this.queryFormData.regions);
        this.cities = [];
        this.getCities(current);
      },
      async getCities(isocode) {
        const url = this.apis().getCities(isocode);
        const result = await this.$http.get(url);

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.cities = result;
      },
      onAdvancedSearch() {
        this.setQueryFormData(this.queryFormData);
        console.log(this.queryFormData);
        this.visible = false;
        this.$emit('onAdvancedSearch', 0);
      },
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
    },
    data() {
      return {
        visible: false,
        keyword: '',
        formData: this.$store.state.BrandsModule.formData,
        queryFormData: this.$store.state.BrandsModule.queryFormData,
        adeptAtCategories: [],
        regions: [],
        cities:[],
        region:''

      }
    },
    created() {
      this.getCategories();
      this.getRegions();
    }
  }
</script>
