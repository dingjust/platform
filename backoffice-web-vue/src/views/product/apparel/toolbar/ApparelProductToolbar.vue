<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入产品货号/名称查询" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button v-if="!isTenant()" type="primary" icon="el-icon-plus" @click="onNew">创建产品</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="产品货号">
            <el-input v-model="queryFormData.skuID"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品名称">
            <el-input v-model="queryFormData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品分类">
            <el-select v-model="queryFormData.categories" placeholder="请选择" class="w-100"
                       filterable reserve-keyword clearable
                       multiple>
              <el-option-group
                v-for="level1 in categories"
                :key="level1.code"
                :label="level1.name">
                <el-option
                  v-for="level2 in level1.children"
                  :key="level2.code"
                  :label="level2.name"
                  :value="level2.code">
                </el-option>
              </el-option-group>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="上/下架状态">
            <el-select v-model="queryFormData.approvalStatuses" placeholder="请选择" class="w-100" multiple>
              <el-option v-for="item in approvalStatuses"
                         :key="item.code"
                         :label="item.name"
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

  const {mapMutations} = createNamespacedHelpers('ApparelProductsModule');

  export default {
    name: 'ApparelProductToolbar',
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData'
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const results = await this.$http.get(url);
        if (!results['errors']) {
          this.categories = results;
        }
      },
    },
    data() {
      return {
        keyword: '',
        formData: this.$store.state.ApparelProductsModule.formData,
        queryFormData: this.$store.state.ApparelProductsModule.queryFormData,
        approvalStatuses: this.$store.state.EnumsModule.approvalStatuses,
        categories: [],
      }
    },
    created() {
      this.getCategories();
    }
  }
</script>
