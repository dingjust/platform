<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="报价单号" prop="code"></el-table-column>
      <el-table-column label="产品" header-align="center" width="260">
        <template slot-scope="scope">
          <el-row type="flex" align="middle" :gutter="10">
            <el-col :span="8">
              <img width="70px" height="70px"
                   :src="scope.row.requirementOrder.details.pictures != null && scope.row.requirementOrder.details.pictures.length > 0 ?
                   scope.row.requirementOrder.details.pictures[0].url : 'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <h6 style="font-size: 12px">品类：
                <span v-if="scope.row.requirementOrder.details.majorCategory">{{scope.row.requirementOrder.details.majorCategory.name}}</span>
                <span v-if="scope.row.requirementOrder.details.category">
                  -{{(scope.row.requirementOrder.details.category.parent ? scope.row.requirementOrder.details.category.parent.name + '-' : '') + scope.row.requirementOrder.details.category.name}}
                </span>
              </h6>
              <h6 style="font-size: 12px">货号：{{scope.row.requirementOrder.details.productSkuID}}</h6>
              <h6 style="font-size: 12px">数量：{{scope.row.requirementOrder.details.expectedMachiningQuantity}}</h6>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column v-if="isTenant()" label="发布公司" prop="belongTo.name" header-align="center" width="180"></el-table-column>
      <el-table-column v-else label="发布公司" prop="supplier.name" header-align="center" width="180"></el-table-column>
      <el-table-column label="报价" prop="user">
        <template slot-scope="scope">
          <span style="color: red">￥{{scope.row.unitPrice}}</span>
        </template>
      </el-table-column>
      <el-table-column label="报价日期" prop="createdTs" width="150">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="state" width="80">
        <template slot-scope="scope">
          <h6 v-if="scope.row.state == 'SELLER_SUBMITTED'" style="color: red;font-size: 12px">{{getEnum('quoteStates', scope.row.state)}}</h6>
          <h6 v-if="scope.row.state == 'BUYER_APPROVED'" style="color: green;font-size: 12px">{{getEnum('quoteStates', scope.row.state)}}</h6>
          <h6 v-if="scope.row.state == 'BUYER_REJECTED'" style="color: #a9a9a9;font-size: 12px">{{getEnum('quoteStates', scope.row.state)}}</h6>
        </template>
      </el-table-column>
      <!--<el-table-column label="需求订单编号" prop="requirementOrder.code"></el-table-column>-->
      <el-table-column label="操作" header-align="center" width="150" align="center">
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
    props: ['page'],
    components: {RequirementOrderRequestForm},
    methods: {
      onPageSizeChanged (val) {
        this._reset();

        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      _reset () {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      }
    },
    data () {
      return {
        isAdvancedSearch: this.$store.state.QuotesModule.isAdvancedSearch
      }
    }
  }
</script>
