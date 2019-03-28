<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column type="expand" fixed>
        <template slot-scope="props">
          <requirement-order-request-form :read-only="true"
                                          :slot-data="props.row.requirementOrder.details">
          </requirement-order-request-form>
        </template>
      </el-table-column>
      <el-table-column label="报价单号" prop="code" width="250" fixed></el-table-column>
      <el-table-column label="状态" prop="state" fixed>
        <template slot-scope="scope">
          <span>{{getEnum('quoteStates', scope.row.state)}}</span>
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
      <el-table-column label="需求订单编号" prop="requirementOrder.code"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <slot name="operations" :item="scope.row"></slot>
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
  </div>
</template>

<script>
  import RequirementOrderRequestForm from '@/views/order/requirement/form/RequirementOrderRequestForm';

  export default {
    name: 'QuoteSearchResultList',
    props: ["page"],
    components: {RequirementOrderRequestForm},
    methods: {
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
      }
    },
    data() {
      return {
        isAdvancedSearch: this.$store.state.QuotesModule.isAdvancedSearch,
      }
    }
  }
</script>
