<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="打样订单号" prop="code"></el-table-column>
      <el-table-column label="产品" header-align="center" width="260">
        <template slot-scope="scope">
          <el-row type="flex" align="middle" :gutter="10">
            <el-col :span="8">
              <img width="70px" height="70px"
                   :src="scope.row.product.pictures != null && scope.row.product.pictures.length > 0 ?
                   scope.row.product.pictures[0].url : 'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <h6 style="font-size: 12px">品类：{{scope.row.product.category.parent.name}}-{{scope.row.product.category.name}}</h6>
              <h6 style="font-size: 12px">货号：{{scope.row.product.skuID}}</h6>
              <h6 style="font-size: 12px">数量：{{scope.row.totalQuantity}}</h6>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="品牌" prop="supplier.name" header-align="center" width="180"></el-table-column>
      <el-table-column label="打样订单状态" prop="status" align="center">
        <template slot-scope="scope">
          <h6 v-if="scope.row.status == 'PENDING_PAYMENT'" style="color: red;font-size: 12px">{{getEnum('proofingOrderStatuses', scope.row.status)}}</h6>
          <h6 v-if="scope.row.status == 'PENDING_DELIVERY'" style="color: red;font-size: 12px">{{getEnum('proofingOrderStatuses', scope.row.status)}}</h6>
          <h6 v-if="scope.row.status == 'SHIPPED'" style="color: green;font-size: 12px">{{getEnum('proofingOrderStatuses', scope.row.status)}}</h6>
          <h6 v-if="scope.row.status == 'COMPLETED'" style="color: green;font-size: 12px">{{getEnum('proofingOrderStatuses', scope.row.status)}}</h6>
          <h6 v-if="scope.row.status == 'CANCELLED'" style="color: #a9a9a9;font-size: 12px">{{getEnum('proofingOrderStatuses', scope.row.status)}}</h6>
        </template>
      </el-table-column>
      <el-table-column v-if="isFactory()" label="跟单员" prop="brandOperator.name" header-align="center" width="180"></el-table-column>
      <el-table-column v-if="isBrand()" label="跟单员" prop="factoryOperator.name" header-align="center" width="180"></el-table-column>
      <el-table-column label="创建日期" prop="creationtime">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" header-align="center">
        <template slot-scope="scope">
          <slot name="operations" :item="scope.row"></slot>
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

  const {mapActions} = createNamespacedHelpers('PurchaseOrdersModule');

  export default {
    name: 'ProofingSearchResultList',
    props: ["page"],
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
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
      },
      onShowRequirement(row) {
        this.$emit('onShowRequirement', row);
      },
    },
    data() {
      return {

      }
    },
    created() {
    }
  }
</script>
