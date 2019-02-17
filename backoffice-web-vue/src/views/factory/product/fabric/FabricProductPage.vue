<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入面辅料编码" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">创建</el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content"
                v-if="isHeightComputed" :height="autoHeight">
        <el-table-column label="编码" prop="code"></el-table-column>
        <el-table-column label="名称" prop="name"></el-table-column>
        <el-table-column label="价格" prop="price" :formatter="numberFormatter"></el-table-column>
        <el-table-column label="操作" width="120">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pt-2"></div>
      <div class="float-right">
        <el-pagination layout="total, sizes, prev, pager, next, jumper"
                       @size-change="onPageSizeChanged"
                       @current-change="onCurrentPageChanged"
                       :current-page="page.number + 1"
                       :page-size="page.size"
                       :page-count="page.totalPages"
                       :total="page.totalElements">
        </el-pagination>
      </div>
      <div class="clearfix"></div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('FactoryFabricProductsModule');

  import autoHeight from 'mixins/autoHeight';
  import {FabricProductForm, FabricProductDetailsPage} from "./";

  export default {
    name: "FabricProductPage",
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: "page"
      })
    },
    methods: {
      ...mapActions({
        search: "search"
      }),
      numberFormatter(val) {
        if (val.price !== null && val.price !== '' && val.price !== 'undefined') {
          return parseFloat(val.price).toFixed(2);
        }
      },
      onSearch() {
        this._onSearch(0);
      },
      onNew() {
        this.fn.openSlider("创建面辅料", FabricProductForm, this.formData);
      },
      onDetails(item) {
        this.fn.openSlider("面辅料明细", FabricProductDetailsPage, item);
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
      }
    },
    data() {
      return {
        text: this.$store.state.FactoryFabricProductsModule.keyword,
        formData: this.$store.state.FactoryFabricProductsModule.formData
      };
    },
    created() {
      this.search({keyword: "", page: 0});
    }
  };
</script>
