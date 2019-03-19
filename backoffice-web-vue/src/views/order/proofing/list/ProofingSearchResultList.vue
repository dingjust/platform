<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="打样订单号" prop="code"></el-table-column>
      <el-table-column label="打样订单状态" prop="status">
        <template slot-scope="scope">
          <el-tag disable-transitions>{{getEnum('proofingOrderStatuses', scope.row.status)}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="订单生成时间" prop="creationtime">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="需求订单号" prop="requirementOrderRef"></el-table-column>
      <el-table-column label="报价订单号" prop="quoteRef"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">修改地址</el-button>
          <el-button type="text" icon="el-icon-edit" @click="onShowQuote(scope.row)">查看报价单</el-button>
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
    name: 'ProofingSearchResultList',
    props: ["page"],
    computed: {},
    methods: {
      onPageSizeChanged(val) {
        this._reset();

        if (this.advancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.advancedSearch) {
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
      onShowQuote(row) {
        this.$emit('onShowQuote', row);
      }
    },
    data() {
      return {}
    },
    created() {
    }
  }
</script>
