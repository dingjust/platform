<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入产品编码" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe
                :data="page.content"
                @selection-change="handleSelectionChange"
                v-if="isHeightComputed" :height="autoHeight">
        <el-table-column type="selection" width="32"></el-table-column>
        <el-table-column label="编码" prop="code" width="160"></el-table-column>
        <el-table-column label="名称" prop="name" width="480"></el-table-column>
        <el-table-column label="价格" prop="price" :formatter="numberFormatter"></el-table-column>
        <el-table-column label=" 操作" width="120">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">
              明细
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pt-2 "></div>
      <div class="float-right ">
        <el-pagination layout="total, sizes, prev, pager, next, jumper"
                       @size-change="onPageSizeChanged"
                       @current-change="onCurrentPageChanged"
                       :current-page="page.number + 1"
                       :page-size="page.size"
                       :page-count="page.totalPages"
                       :total="page.totalElements">
        </el-pagination>
      </div>
      <div class="clearfix "></div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandDeletedApparelProductsModule');

  import autoHeight from 'mixins/autoHeight';

  import {ProductDetailsPage} from "./";

  export default {
    name: "ProductDeletedPage",
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: "page"
      }),
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
        this._onSearch(0);
      },
      async onDetails(item) {
        const result = await this.$http.get("/djbrand/product/details/" + item.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.fn.openSlider("产品明细", ProductDetailsPage, result);
      },
      onPageSizeChanged(val) {
        this.reset();

        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      _onSearch(page, size) {
        const keyword = this.text;
        this.search({keyword, page, size});
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      }
    },
    data() {
      return {
        text: this.$store.state.BrandDeletedApparelProductsModule.keyword,
        formData: this.$store.state.BrandDeletedApparelProductsModule.formData,
      };
    }
  };
</script>
