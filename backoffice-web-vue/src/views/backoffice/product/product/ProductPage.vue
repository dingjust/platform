<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入产品编码" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">创建产品</el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onBatchLaunch">批量上架</el-button>
          <el-button type="primary" icon="el-icon-minus" @click="onBatchWithdraw">批量下架</el-button>
        </el-button-group>
        <el-popover placement="bottom" width="800" trigger="click">
          <el-row :gutter="10">
            <el-col :span="8">
              <el-form-item label="供应商商品编号">
                <el-input v-model="queryFormData.skuID"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="商品名称">
                <el-input v-model="queryFormData.name"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="商品状态（上下架）">
                <el-select v-model="queryFormData.approvalStatuses" placeholder="请选择"
                           multiple class="w-100">
                  <el-option
                    v-for="item in approvalStatuses"
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
            <el-col :span="12">
              <el-form-item label="商家">
                <el-select class="w-100" filterable remote reserve-keyword clearable
                           placeholder="请输入商家名称查询"
                           v-model="queryFormData.belongTos"
                           :remote-method="onFilterCompanies"
                           multiple>
                  <el-option v-for="item in companies"
                             :key="item.uid"
                             :label="item.name"
                             :value="item.uid">
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
          <el-button type="primary" slot="reference">高级查询</el-button>
        </el-popover>
      </el-form>
      <el-table v-if="isHeightComputed" ref="resultTable" stripe
                :data="page.content"
                @selection-change="handleSelectionChange"
                :height="autoHeight">
        <el-table-column type="selection" width="32" fixed></el-table-column>
        <el-table-column label="编码" prop="code" width="120" fixed></el-table-column>
        <el-table-column label="供应商产品编码" prop="skuID" width="120" fixed></el-table-column>
        <el-table-column label="名称" prop="name" width="480"></el-table-column>
        <el-table-column label="价格" prop="price" :formatter="numberFormatter"></el-table-column>
        <el-table-column label="商家" prop="belongTo.name"></el-table-column>
        <el-table-column label="上下架">
          <template slot-scope="scope">
            <el-switch active-color="#13ce66" inactive-color="#ff4949"
                       v-model="scope.row.approvalStatus === 'approved'"
                       @change="changeShelfStatus(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label="店铺首页推荐">
          <template slot-scope="scope">
            <el-switch active-color="#13ce66" inactive-color="#ff4949"
                       v-model="scope.row.recommended"
                       @change="changeRecommendedStatus(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label=" 操作" width="120">
          <template slot-scope="scope">
            <!--<el-button type="text" icon="el-icon-edit" @click="onReview(scope.row)">
              评价
            </el-button>-->
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">
              明细
            </el-button>
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

  const {mapGetters, mapActions} = createNamespacedHelpers('ApparelProductsModule');

  import autoHeight from 'mixins/autoHeight';

  import {ProductForm, ProductDetailsPage} from "./";

  export default {
    name: "ProductPage",
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: "page"
      }),
      // 批量上下架code数组
      codes: function () {
        return this.multipleSelection.map((item, number, any) => {
          return item.code;
        });
      }
    },
    methods: {
      ...mapActions({
        search: "search",
        searchAdvanced: "searchAdvanced"
      }),
      numberFormatter(val) {
        if (val.price !== null && val.price !== '' && val.price !== 'undefined') {
          return parseFloat(val.price).toFixed(2);
        }
      },
      onSearch() {
        this.advancedSearch = false;
        this._onSearch(0, this.page.size);
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
        this._onAdvancedSearch(0, this.page.size)
      },
      onNew() {
        this.fn.openSlider("创建产品", ProductForm, this.formData);
      },
      onBatchLaunch() {
        if (this.multipleSelection.length < 1) {
          this.$message.info("请选择产品");

          return;
        }

        this._onBatchLaunch();
      },
      async _onBatchLaunch() {
        const result = await this.$http.put("/djbackoffice/product/shelf/list", this.codes);
        if (result["errors"]) {
          this.$message.error("批量上架失败，原因：" + result["errors"][0].message);
          return;
        }

        this.$message.success("批量上架成功");
        this._onSearchDelegated();
      },
      onBatchWithdraw() {
        if (this.multipleSelection.length < 1) {
          this.$message.info("请选择产品");

          return;
        }

        this._onBatchWithdraw();
      },
      async _onBatchWithdraw() {
        const result = await this.$http.post("/djbackoffice/product/shelf/list", this.codes);
        if (result["errors"]) {
          this.$message.error("批量下架失败，原因：" + result["errors"][0].message);
          return;
        }

        this.$message.success("批量下架成功");

        this._onSearchDelegated();
      },
      async onDetails(item) {
        const result = await this.$http.get("/djbackoffice/product/details/" + item.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.fn.openSlider("产品明细", ProductDetailsPage, result);
      },
      onPageSizeChanged(val) {
        this.reset();

        this.page.size = val;
        if (this.advancedSearch) {
          this._onAdvancedSearch(0, val);
        } else {
          this._onSearch(0, val);
        }
      },
      onCurrentPageChanged(val) {
        if (this.advancedSearch) {
          this._onAdvancedSearch(val - 1, this.page.size);
        } else {
          this._onSearch(val - 1, this.page.size);
        }
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onFilterCompanies(query) {
        this.companies = [];
        if (query && query !== "") {
          setTimeout(() => {
            this.getCompanies(query);
          }, 200);
        }
      },
      async getCompanies(query) {
        const results = await this.$http.get("/djbrand/brand", {
          text: query.trim()
        });
        if (!results["errors"]) {
          this.companies = results["content"];
        }
      },
      async getCategories() {
        const results = await this.$http.get("/djbackoffice/product/category/cascaded");
        if (!results["errors"]) {
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
      async changeShelfStatus(row) {
        let request = this.$http.put;
        if (row.approvalStatus === "approved") {
          request = this.$http.post;
        }
        let message = "上架";
        if (row.approvalStatus === "approved") {
          request = this.$http.post;
          message = "下架";
        }

        const result = await request("/djbackoffice/product/shelf/" + row.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        if (row.approvalStatus === "approved") {
          this.$set(row, "approvalStatus", "unapproved")
        } else {
          this.$set(row, "approvalStatus", "approved")
        }
        this.$message.success(message + "成功");
      },
      async changeRecommendedStatus(row) {
        let request = this.$http.put;
        let message = "推荐";
        if (!row.recommended) {
          request = this.$http.post;
          message = "取消推荐";
        }

        const result = await request("/djbackoffice/product/recommended/" + row.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$set(row, "recommended", row.recommended);
        this.$message.success(message + "成功");
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      }
    },
    data() {
      return {
        text: "",
        approvalStatuses: this.$store.state.EnumsModule.approvalStatuses,
        formData: this.$store.state.ApparelProductsModule.formData,
        queryFormData: this.$store.state.ApparelProductsModule.queryFormData,
        advancedSearch: false,
        multipleSelection: [],
        categories: [],
        companies: [],
      };
    },
    created() {
      this.search({keyword: "", page: 0});
      this.getCategories("");
      this.getCompanies("");
    }
  };
</script>
