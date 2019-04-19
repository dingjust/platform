<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入名称" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button v-if="isTenant()" type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click" v-model="visible">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="标签" prop="labels">
            <el-select class="w-100" v-model="queryFormData.labels" value-key="id" multiple filterable>
              <el-option v-for="item in labels"
                         :label="item.name"
                         :key="item.id"
                         :value="item.id">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="公司规模" prop="populationScales">
            <el-select v-model="queryFormData.populationScales" class="w-100" multiple filterable>
              <el-option v-for="item in populationScales"
                         :key="item.code"
                         :label="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="生产地区" prop="productiveOrientations">
            <el-select v-model="queryFormData.productiveOrientations" class="w-100" multiple filterable>
              <el-option v-for="item in regions"
                         :key="item.isocode"
                         :label="item.name"
                         :value="item.isocode">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="分类" prop="adeptAtCategories">
            <el-select class="w-100"
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
        </el-col>
        <el-col :span="8">
          <el-form-item label="大类" prop="categories">
            <el-select class="w-100" v-model="queryFormData.categories" value-key="id" multiple filterable>
              <el-option v-for="item in categories"
                         :label="item.name"
                         :key="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="评级" prop="startLevel">
            <el-select class="w-100" v-model="queryFormData.starLevel" clearable filterable>
              <el-option v-for="item in starLevels"
                         :label="item.name"
                         :key="item.code"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="产业集群" prop="labels">
            <el-select class="w-100" v-model="queryFormData.industrialClusters" value-key="id" multiple filterable>
              <el-option v-for="item in industrialClusters"
                         :label="item.name"
                         :key="item.id"
                         :value="item.code">
              </el-option>
            </el-select>
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

  const {mapMutations} = createNamespacedHelpers('FactoriesModule');

  export default {
    name: 'FactoryToolbar',
    props: ['hideCreationButton'],
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData',
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        if (this.queryFormData.starLevel == 0) {
          this.queryFormData.starLevel = null;
        }
        this.setQueryFormData(this.queryFormData);
        this.visible = false;
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
      async getLabels() {
        const url = this.apis().getGroupLabels('FACTORY');
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.labels = result;
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
      async getCategories() {
        const url = this.apis().getMajorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
      async getMinorCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.adeptAtCategories = result;
      },
      async getIndustrialClusters() {
        const url = this.apis().getIndustrialClustersAll();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        console.log(result);
        this.industrialClusters = result;
      },
    },
    data() {
      return {
        visible: false,
        keyword: '',
        labels: [],
        regions: [],
        categories: [],
        adeptAtCategories: [],
        industrialClusters:[],
        formData: this.$store.state.FactoriesModule.formData,
        queryFormData: this.$store.state.FactoriesModule.queryFormData,
        populationScales: this.$store.state.EnumsModule.populationScales,
        starLevels:this.$store.state.EnumsModule.starLevels,
      }
    },
    created() {
      this.getLabels();
      this.getRegions();
      this.getCategories();
      this.getMinorCategories();
      this.getIndustrialClusters();
    }
  }
</script>
