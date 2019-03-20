<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="需求订单号" prop="requirementOrderCode" width="160" fixed></el-table-column>
      <el-table-column label="生产订单号" prop="productionOrderCode" width="160" fixed></el-table-column>
      <el-table-column label="客户" prop="brand" width="120" fixed></el-table-column>
      <el-table-column label="工厂" prop="factory" width="160" fixed></el-table-column>
      <el-table-column label="产品货号" prop="productSkuID" width="120"></el-table-column>
      <el-table-column label="生产订单状态" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.status === 'DELIVERY_COMPLETED' ? 'success' : ''"
            disable-transitions>{{scope.row.status|enumTranslate('ConsignmentStatus')}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="是否延期" prop="isDelay">
        <template slot-scope="scope">
          <el-tag :type="scope.row.isDelay === 'true' ? 'success' : 'danger'" disable-transitions>
            {{scope.row.isDelay|enumTranslate('DelayStatus')}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="生产订单创建时间" prop="productOrderCreationTime" width="120">
        <template slot-scope="scope">
          <span>{{scope.row.productOrderCreationTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="品类" prop="productCategories"></el-table-column>
      <el-table-column label="品名" prop="productName" width="160"></el-table-column>
      <el-table-column label="产品明细" prop="items" width="160">
        <template slot-scope="scope" v-if="scope.row.items">
          <span v-for="item in scope.row.items">{{item.color}}/{{item.size}}/{{item.amount}}<br></span>
        </template>
      </el-table-column>
      <el-table-column label="合计" prop="productSum" width="80"></el-table-column>
      <el-table-column label="客户交期" prop="expectedDeliveryDate" width="120">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | formatDate}}</span>
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
  export default {
    name: 'ProductionProgressReportList',
    props: ["page"],
    computed: {},
    methods: {
      onPageSizeChanged(val) {
        this._reset();

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
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
      return {}
    }
  }
</script>
