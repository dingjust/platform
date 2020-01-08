<template>
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
    <!--    <el-button-group>-->
    <!--      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>-->
    <!--      <el-button v-if="isTenant()" type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>-->
    <!--    </el-button-group>-->
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
    <!--          <el-form-item label="大类" prop="categories">-->
    <!--            <el-select class="w-100" v-model="queryFormData.categories" value-key="id" multiple filterable>-->
    <!--              <el-option v-for="item in categories"-->
    <!--                         :label="item.name"-->
    <!--                         :key="item.name"-->
    <!--                         :value="item.code">-->
    <!--              </el-option>-->
    <!--            </el-select>-->
    <!--          </el-form-item>-->
    <!--          <el-form-item label="评级" prop="startLevel">-->
    <!--            <el-select class="w-100" v-model="queryFormData.starLevel" clearable filterable>-->
    <!--              <el-option v-for="item in starLevels"-->
    <!--                         :label="item.name"-->
    <!--                         :key="item.code"-->
    <!--                         :value="item.code">-->
    <!--              </el-option>-->
    <!--            </el-select>-->
    <!--          </el-form-item>-->
    <!--          <el-form-item label="标签" prop="labels">-->
    <!--            <el-select class="w-100" v-model="queryFormData.labels" value-key="id" multiple filterable>-->
    <!--              <el-option v-for="item in labels"-->
    <!--                         :label="item.name"-->
    <!--                         :key="item.id"-->
    <!--                         :value="item.id">-->
    <!--              </el-option>-->
    <!--            </el-select>-->
    <!--          </el-form-item>-->
    <!--          <el-form-item label="公司规模" prop="populationScales">-->
    <!--            <el-select v-model="queryFormData.populationScales" class="w-100" multiple filterable>-->
    <!--              <el-option v-for="item in populationScales"-->
    <!--                         :key="item.code"-->
    <!--                         :label="item.name"-->
    <!--                         :value="item.code">-->
    <!--              </el-option>-->
    <!--            </el-select>-->
    <!--          </el-form-item>-->
    <!--          <el-form-item label="产业集群" prop="labels">-->
    <!--            <el-select class="w-100" v-model="queryFormData.industrialClusters" value-key="id" multiple filterable>-->
    <!--              <el-option v-for="item in industrialClusters"-->
    <!--                         :label="item.name"-->
    <!--                         :key="item.id"-->
    <!--                         :value="item.code">-->
    <!--              </el-option>-->
    <!--            </el-select>-->
    <!--          </el-form-item>-->
    <!--          <el-form-item label="省" prop="productiveOrientations">-->
    <!--            <el-select v-model="region" class="w-100" filterable @change="onRegionChanged">-->
    <!--              <el-option v-for="item in regions"-->
    <!--                         :key="item.isocode"-->
    <!--                         :label="item.name"-->
    <!--                         :value="item.isocode">-->
    <!--              </el-option>-->
    <!--            </el-select>-->
    <!--          </el-form-item>-->
    <!--          <el-form-item label="市" prop="cities">-->
    <!--            <el-select class="w-100" v-model="queryFormData.cities" multiple filterable>-->
    <!--              <el-option-->
    <!--                v-for="item in cities"-->
    <!--                :key="item.code"-->
    <!--                :label="item.name"-->
    <!--                :value="item.code">-->
    <!--              </el-option>-->
    <!--            </el-select>-->
    <!--          </el-form-item>-->
    <el-button-group>
      <el-button style="background-color: #FFD60C" @click="onAdvancedSearch">搜索</el-button>
      <el-button @click="onReset">重置</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click" ref="addressPopover" :width="200">
      <el-form-item label="省" prop="productiveOrientations">
        <el-select v-model="region" class="w-100" filterable @change="onRegionChanged">
          <el-option v-for="item in regions"
                     :key="item.isocode"
                     :label="item.name"
                     :value="item.isocode">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="市" prop="cities">
        <el-select class="w-100" v-model="queryFormData.cities" multiple filterable @change="recordCities">
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

    const {mapMutations} = createNamespacedHelpers('FactoriesModule');

    export default {
      name: 'FactoryToolbar',
      props: ['hideCreationButton'],
      components: {},
      computed: {},
      methods: {
        ...mapMutations({
          setKeyword: 'keyword',
          setQueryFormData: 'queryFormData'
        }),
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
          console.log(this.queryFormData.productiveOrientations);
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
        onSearch () {
          this.setKeyword(this.keyword);
          this.$emit('onSearch', 0);
        },
        onAdvancedSearch () {
          if (this.queryFormData.starLevel == 0) {
            this.queryFormData.starLevel = null;
          }
          this.setQueryFormData(this.queryFormData);
          this.visible = false;
          this.$emit('onAdvancedSearch', 0);
        },
        onNew () {
          let formData = {};
          Object.assign(formData, this.formData);

          this.$emit('onNew', formData);
        },
        async getLabels () {
          const url = this.apis().getGroupLabels('FACTORY');
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }

          this.labels = result;
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
        async getCategories () {
          const url = this.apis().getMajorCategories();
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }

          this.categories = result;
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
        async getIndustrialClusters () {
          const url = this.apis().getIndustrialClustersAll();
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          console.log(result);
          this.industrialClusters = result;
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
        onReset () {
          this.queryFormData.keyword = '';
          this.queryFormData.creationTimeFrom = '';
          this.queryFormData.creationTimeTo = '';
          this.queryFormData.adeptAtCategories = [];
          this.queryFormData.cities = [];
          this.region = '';
          this.addressText = '';
          this.queryFormData.productiveOrientations = [];
        }
      },
      data () {
        return {
          visible: false,
          keyword: '',
          labels: [],
          regions: [],
          cities: [],
          categories: [],
          adeptAtCategories: [],
          industrialClusters: [],
          addressText: '',
          citiesText: '',
          regionText: '',
          formData: this.$store.state.FactoriesModule.formData,
          queryFormData: this.$store.state.FactoriesModule.queryFormData,
          populationScales: this.$store.state.EnumsModule.populationScales,
          starLevels: this.$store.state.EnumsModule.starLevels,
          region: ''
          // region:this.$store.state.FactoriesModule.formData.
        }
      },
      created () {
        this.getLabels();
        this.getRegions();
        this.getCategories();
        this.getMinorCategories();
        this.getIndustrialClusters();
      }
    }
</script>
