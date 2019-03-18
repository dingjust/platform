<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange"
              v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="订单编号" prop="code" width="250">
        <template slot-scope="scope">
          <span>{{scope.row.code}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态" prop="status" :column-key="'status'"
                       :filters="statuses">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.status === 'COMPLETED' ? 'success' : ''"
            disable-transitions>{{getEnum('requirementOrderStatuses', scope.row.status)}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建用户" prop="user">
        <template slot-scope="scope">
          <span>{{scope.row.user.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="createdTs">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
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
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandRequirementOrdersModule');

  export default {
    name: 'RequirementOrderSearchResultList',
    props: ["page"],
    computed: {},
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      handleFilterChange(val) {
        this.statuses = val.status;
        this._onSearch(0);
      },
      //如只需当前页面筛选不需调后台查询的使用该方法！
      filterTag(value, row) {
        //   return row.status === value;
      },
      onAdvancedSearch() {
        this.advancedSearch = true;
        this._onAdvancedSearch(0)
      },
      _onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        this.searchAdvanced({query, page, size});
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
      _onSearch(page, size) {
        const keyword = this.keyword;
        this.search({keyword, page, size});
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      }
    },
    data() {
      return {
        statuses: this.$store.state.BrandRequirementOrdersModule.statuses,
      }
    },
    created() {
    }
  }
</script>
