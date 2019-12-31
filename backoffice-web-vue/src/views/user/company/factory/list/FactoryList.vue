<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="UID" prop="uid"></el-table-column>
      <el-table-column label="名称" prop="name"></el-table-column>
      <el-table-column label="联系电话" prop="contactPhone"></el-table-column>
      <el-table-column label="联系人" prop="contactPerson"></el-table-column>
      <el-table-column label="创建时间" prop="creationTime">
        <template slot-scope="scope">
          <span>{{scope.row.creationTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <slot name="operations" :item="scope.row"></slot>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right"
                   layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  export default {
    name: 'FactoryList',
    props: ["page"],
    computed: {},
    methods: {
      onPageSizeChanged(val) {
        this._reset();
        if (this.$store.state.FactoriesModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }
        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.FactoriesModule.isAdvancedSearch) {
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
      },
    },
    data() {
      return {
      }
    }
  }
</script>
