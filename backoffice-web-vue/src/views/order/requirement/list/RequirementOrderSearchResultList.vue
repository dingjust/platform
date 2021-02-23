<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" :row-style="{fontSize:'12px'}"
              v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="需求订单号" prop="code">
      </el-table-column>
      <el-table-column label="标题" prop="details.productName" width="200" header-align="center">
      </el-table-column>
      <el-table-column label="产品" width="260" header-align="center">
        <template slot-scope="scope">
          <el-row type="flex" align="middle" :gutter="10">
            <el-col :span="8">
              <img width="70px" height="70px"
                   :src="scope.row.details.pictures != null && scope.row.details.pictures.length > 0 ?
                   scope.row.details.pictures[0].url : 'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <h6 style="font-size: 12px">品类：{{scope.row.details.category.parent.name}}-{{scope.row.details.category.name}}</h6>
              <h6 style="font-size: 12px">货号：{{scope.row.details.productSkuID}}</h6>
              <h6 style="font-size: 12px">数量：{{scope.row.details.expectedMachiningQuantity}}</h6>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="发布人" prop="user">
        <template slot-scope="scope">
          <span>
            {{scope.row.user.name}}
            <span v-if="scope.row.publishType === 'PUBLISH_BY_OTHERS'" style="color: #F56C6C">(代发)</span>
          </span>
        </template>
      </el-table-column>
      <el-table-column label="发布日期" prop="createdTs">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态" prop="status" width="150">
        <template slot-scope="scope">
          <h6 v-if="scope.row.status == 'PENDING_QUOTE'" style="color: red">{{getEnum('requirementOrderStatuses', scope.row.status)}}（已报价{{scope.row.totalQuotesCount}}）</h6>
          <h6 v-if="scope.row.status == 'COMPLETED'" style="color: green">{{getEnum('requirementOrderStatuses', scope.row.status)}}</h6>
          <h6 v-if="scope.row.status == 'CANCELLED'" style="color: #a9a9a9">{{getEnum('requirementOrderStatuses', scope.row.status)}}</h6>
        </template>
      </el-table-column>
      <el-table-column label="操作"  header-align="center" align="center" width="150">
        <template slot-scope="scope">
          <slot name="operations" :item="scope.row"></slot>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
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
  export default {
    name: 'RequirementOrderSearchResultList',
    props: ['page'],
    computed: {},
    methods: {
      handleFilterChange (val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged (val) {
        this._reset();

        if (this.$store.state.RequirementOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        if (this.$store.state.RequirementOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          this.$nextTick(() => {
            this.$refs.resultTable.bodyWrapper.scrollTop = 0
          });
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
        statuses: this.$store.state.RequirementOrdersModule.statuses
      }
    }
  }
</script>
