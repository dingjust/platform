<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" :stripe="true" :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="订单号">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column prop="name" label="产品名">
      </el-table-column>
      <el-table-column prop="name" label="货号">
      </el-table-column>
      <el-table-column prop="name" label="跟单员">
      </el-table-column>
      <el-table-column prop="name" label="工厂/客户">
      </el-table-column>
      <el-table-column prop="name" label="价格">
      </el-table-column>
      <el-table-column prop="name" label="数量">
      </el-table-column>
      <el-table-column label="交期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>      
      <el-table-column label="状态" prop="status" :column-key="'status'" :filters="statuses">
        <template slot-scope="scope">
          <span>{{getEnum('purchaseOrderStatuses', scope.row.status)}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="跟单员">
        <template slot-scope="scope">
          <span>{{getOperator(scope.row)}}</span>
        </template>
      </el-table-column> -->
      <el-table-column prop="name" label="实发数量">
      </el-table-column>
      <el-table-column prop="name" label="正负数">
      </el-table-column>
      <el-table-column prop="name" label="备注">
      </el-table-column>      
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers('ReceiptReportModule');

 export default {
    name: 'ReceiptReportResultList',
    props: ['page'],
    components: {},
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      handleFilterChange (val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged (val) {
        this._reset();

        if (this.$store.state.PurchaseOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        if (this.$store.state.PurchaseOrdersModule.isAdvancedSearch) {
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
      },
      onDetails (row) {
        this.$emit('onDetails', row);
      },
      countTotalQuantity (entries) {
        let amount = 0;
        entries.forEach(element => {
          amount += element.quantity;
        });
        return amount;
      },
      getPaymentStatusTag (row) {
        return row.payStatus === 'PAID' ? 'static/img/paid.png' : 'static/img/arrears.png';
      },
      getSignedTag (row) {
        if (row.userAgreementIsSigned == null) {
          return 'static/img/not_signed.png';
        } else {
          return row.userAgreementIsSigned ? 'static/img/signed.png' : 'static/img/not_signed.png';
        }
      },
      getOperator (row) {
        if (this.$store.getters.currentUser.type == 'BRAND' && row.brandOperator != null) {
          return row.brandOperator.name;
        } else if (this.$store.getters.currentUser.type == 'FACTORY' && row.factoryOperator != null) {
          return row.factoryOperator.name;
        } else {
          return '';
        }
      }
    },
    data () {
      return {
        statuses: this.$store.state.PurchaseOrdersModule.statuses
      }
    }
  }
</script>
<style>
  .purchase-list-button {
    color: #FFA403;
  }

</style>
