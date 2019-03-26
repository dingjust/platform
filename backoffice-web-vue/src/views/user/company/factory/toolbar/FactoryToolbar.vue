<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入名称" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button v-if="!hideCreationButton"  type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="标签" prop="labels">
            <el-select class="w-100" v-model="queryFormData.labels" value-key="id" multiple>
              <el-option v-for="item in labels"
                         :label="item.name"
                         :key="item.id"
                         :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="公司规模" prop="populationScales">
            <el-select v-model="queryFormData.populationScales" class="w-100" multiple>
              <el-option v-for="item in populationScales"
                         :key="item.code"
                         :label="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="生产地区" prop="regions">
            <el-select v-model="queryFormData.regions" class="w-100" multiple>
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
        setKeyword: 'keyword'
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
      async getLabels() {
        const url = this.apis().getAllLabels();
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
    },
    data() {
      return {
        keyword: '',
        labels: [],
        regions: [],
        formData: this.$store.state.FactoriesModule.formData,
        queryFormData: this.$store.state.FactoriesModule.queryFormData,
        populationScales: this.$store.state.EnumsModule.populationScales,
      }
    },
    created() {
      this.getLabels();
      this.getRegions();
    }
  }
</script>
