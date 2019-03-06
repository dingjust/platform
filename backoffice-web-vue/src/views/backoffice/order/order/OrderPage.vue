<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入订单编号" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
        <el-table-column label="订单编号" prop="code" width="250" fixed></el-table-column>
        <el-table-column label="订单状态" prop="status" fixed>
          <template slot-scope="scope">
            <span>{{scope.row.status | enumTranslate('OrderStatus')}}</span>
          </template>
        </el-table-column>
        <el-table-column label="创建用户" prop="user">
          <template slot-scope="scope">
            <span>{{scope.row.user.name}}</span>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createdTs">
          <template slot-scope="scope">
            <span>{{scope.row.createdTs | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="商家" prop="belongTo.name"></el-table-column>
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

  const {mapGetters, mapActions} = createNamespacedHelpers('SalesOrdersModule');

  import autoHeight from 'mixins/autoHeight'

  import {OrderForm, OrderDetailsPage} from './';

  export default {
    name: 'OrderPage',
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onSearch() {
        this._onSearch(0);
      },
      onNew() {
        this.fn.openSlider('创建订单', OrderForm, this.formData);
      },
      async onDetails(item) {
        const result = await this.$http.get('/djbackoffice/salesOrder/' + item.code);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('订单明细', OrderDetailsPage, result);
      },
      onPageSizeChanged(val) {
        this.reset();

        this.page.size = val;
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
        text: this.$store.state.SalesOrdersModule.keyword,
        formData: this.$store.state.SalesOrdersModule.formData,
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
