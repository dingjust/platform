<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入发料单编号" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">创建发料单</el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content"
                v-if="isHeightComputed" :height="autoHeight">
        <el-table-column label="编号" prop="code"></el-table-column>
        <el-table-column label="状态" prop="status">
          <template slot-scope="scope">
            <span>{{scope.row.status | enumTranslate('PickOrderStatus')}}</span>
          </template>
        </el-table-column>
        <el-table-column label="创建用户" prop="user.name"></el-table-column>
        <el-table-column label="创建时间" prop="createdTs">
          <template slot-scope="scope">
            <span>{{scope.row.createdTs | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
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

  const {mapGetters, mapActions} = createNamespacedHelpers('PickOrdersModule');

  import autoHeight from 'mixins/autoHeight';

  import PickOrderForm from './PickOrderForm';
  import PickOrderDetailsPage from "./PickOrderDetailsPage";

  export default {
    name: "PickOrderPage",
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
      onSearch() {
        this._onSearch(0);
      },
      onNew() {
        this.fn.openSlider("创建发料单", PickOrderForm, this.formData);
      },
      onDetails(item) {
        this.fn.openSlider("订单明细", PickOrderDetailsPage, item);
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
        text: this.$store.state.PickOrdersModule.keyword,
        formData: this.$store.state.PickOrdersModule.formData,
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
