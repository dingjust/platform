<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入商品编码/货号/名称查询" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">创建商品</el-button>
        </el-button-group>
        <el-popover placement="bottom" width="800" trigger="click">
          <el-row :gutter="10">
            <el-col :span="8">
              <el-form-item label="商品货号">
                <el-input v-model="queryFormData.skuID"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="商品名称">
                <el-input v-model="queryFormData.name"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
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
          </el-row>
          <el-row :gutter="10">
            <el-col :span="6">
              <el-button type="primary" icon="el-icon-search" @click="onAdvancedSearch">查询</el-button>
            </el-col>
          </el-row>
          <el-button type="primary" slot="reference">高级查询</el-button>
        </el-popover>
      </el-form>
      <el-table ref="resultTable" stripe
                :data="page.content"
                @selection-change="handleSelectionChange"
                v-if="isHeightComputed" :height="autoHeight">
        <el-table-column type="selection" width="32" fixed></el-table-column>
        <el-table-column label="商品编码" prop="code" width="120" fixed></el-table-column>
        <el-table-column label="商品货号" prop="skuID" width="120" fixed></el-table-column>
        <el-table-column label="商品名称" prop="name" width="480"></el-table-column>
        <el-table-column label="供货价" prop="price" :formatter="numberFormatter"></el-table-column>
        <el-table-column label=" 操作" width="120">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                     @size-change="onPageSizeChanged"
                     @current-change="onCurrentPageChanged"
                     :current-page="page.number + 1"
                     :page-size="page.size"
                     :page-count="page.totalPages"
                     :total="page.totalElements">
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('FactoryApparelProductsModule');

  import autoHeight from 'mixins/autoHeight';

  import ApparelProductForm from './ApparelProductForm';
  import ApparelProductDetailsPage from './ApparelProductDetailsPage';

  export default {
    name: 'ApparelProductPage',
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: 'page'
      }),
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      numberFormatter(val) {
        if (val.price !== null && val.price !== '' && val.price !== 'undefined') {
          return parseFloat(val.price).toFixed(2);
        }
      },
      onSearch() {
        this.advancedSearch = false;
        this._onSearch(0);
      },
      _onSearchDelegated() {
        if (this.advancedSearch) {
          this.onSearch();
        } else {
          this.onAdvancedSearch();
        }
      },
      onAdvancedSearch() {
        this.advancedSearch = true;
        this._onAdvancedSearch(0)
      },
      onNew() {
        this.fn.openSlider('创建商品', ApparelProductForm, Object.assign({}, this.formData));
      },
      async onDetails(item) {
        const result = await this.$http.get('/b2b/products/apparel/' + item.code);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('产品明细', ApparelProductDetailsPage, result);
      },
      onPageSizeChanged(val) {
        this.reset();

        if (this.advancedSearch) {
          this._onAdvancedSearch(0, val);
        } else {
          this._onSearch(0, val);
        }
      },
      onCurrentPageChanged(val) {
        if (this.advancedSearch) {
          this._onAdvancedSearch(val - 1);
        } else {
          this._onSearch(val - 1);
        }
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      async getCategories() {
        const results = await this.$http.get('/b2b/categories/cascaded');
        if (!results['errors']) {
          this.categories = results;
        }
      },
      _onSearch(page, size) {
        const keyword = this.text;
        this.search({keyword, page, size});
      },
      _onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        this.searchAdvanced({query, page, size});
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      }
    },
    data() {
      return {
        text: this.$store.state.FactoryApparelProductsModule.keyword,
        formData: this.$store.state.FactoryApparelProductsModule.formData,
        queryFormData: this.$store.state.FactoryApparelProductsModule.queryFormData,
        approvalStatuses: this.$store.state.EnumsModule.approvalStatuses,
        advancedSearch: false,
        multipleSelection: [],
        categories: [],
      };
    },
    created() {
      this.search({keyword: '', page: 0});
      this.getCategories('');
    }
  };
</script>
