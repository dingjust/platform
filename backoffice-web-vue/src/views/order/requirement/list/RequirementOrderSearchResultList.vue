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
          <el-tag disable-transitions>{{getEnum('requirementOrderStatuses', scope.row.status)}}</el-tag>
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
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderSearchResultList',
    props: ["page"],
    computed: {},
    methods: {
      handleFilterChange(val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged(val) {
        this._reset();

        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      }
    },
    data() {
      return {
        statuses: this.$store.state.RequirementOrdersModule.statuses,
        isAdvancedSearch: this.$store.state.RequirementOrdersModule.isAdvancedSearch,
      }
    }
  }
</script>
