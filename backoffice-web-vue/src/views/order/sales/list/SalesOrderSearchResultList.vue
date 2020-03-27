<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed"
      :height="autoHeight">
      <el-table-column label="销售订单号" min-width="130">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="产品" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" align="middle" justify="start">
            <el-col>
              <img width="54px" v-if="scope.row.entries !=null" height="54px"
                :src="scope.row.entries[0].product.baseProductDetail.images != null && scope.row.entries[0].product.baseProductDetail.images.length != 0 ?
                      scope.row.entries[0].product.baseProductDetail.images[0].url : 'static/img/nopicture.png'" />
            </el-col>
            <el-col>
              <el-row>
                <span class="ellipsis-name" :title="scope.row.entries[0].product.baseProductDetail.name">
                  {{scope.row.entries[0].product.baseProductDetail.name}}
                </span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.entries != null ? scope.row.entries[0].product.baseProductDetail.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="数量">
        <template slot-scope="scope">
          <span>{{scope.row.quality}}</span>
        </template>
      </el-table-column>
      <el-table-column label="产品品类">
        <template slot-scope="scope">
          <span>{{scope.row.entries[0].product.baseProductDetail.category.parent.name}}-{{scope.row.entries[0].product.baseProductDetail.category.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="产品类型">
        <template slot-scope="scope">
          <span>现货</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态" prop="status" :column-key="'status'" :filters="statuses">
        <template slot-scope="scope">
          <!-- <el-tag disable-transitions>{{getEnum('purchaseOrderStatuses', scope.row.status)}}</el-tag> -->
          <span>{{judgeState(scope.row)}}</span>
<!--          <span>{{getEnum('salesOrderStatuses', scope.row.status)}}</span>-->
        </template>
      </el-table-column>
      <el-table-column label="订单生成时间" min-width="100">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">明细</el-button>
<!--            <el-divider v-if="scope.row.status === 'PENDING_PAYMENT'" direction="vertical"></el-divider>-->
<!--            <el-button v-if="scope.row.status === 'PENDING_PAYMENT'" type="text" @click="onDetails(scope.row)" class="purchase-list-button">去支付</el-button>-->
            <el-divider v-if="isBrand() && scope.row.status === 'PENDING_PAYMENT'" direction="vertical"></el-divider>
            <el-button v-if="isBrand() && scope.row.status === 'PENDING_PAYMENT'"
                       type="text" @click="cannelOrder(scope.row)" class="purchase-list-button">取消订单</el-button>
            <el-divider v-if="isBrand() && scope.row.status === 'PENDING_DELIVERY' && !scope.row.refunding" direction="vertical"></el-divider>
            <el-button v-if="isBrand() && scope.row.status === 'PENDING_DELIVERY' && !scope.row.refunding" :disabled="!allowRemind(scope.row)"
                       type="text" @click="remindDelivery(scope.row)" class="purchase-list-button">提醒发货</el-button>
            <el-divider v-if="isBrand() && scope.row.status === 'PENDING_CONFIRM' && !scope.row.refunding" direction="vertical"></el-divider>
            <el-button v-if="isBrand() && scope.row.status === 'PENDING_CONFIRM' && !scope.row.refunding"
                       type="text" @click="confirmDelivery(scope.row)" class="purchase-list-button">确认收货</el-button>
            <el-divider v-if="isFactory() && scope.row.status === 'PENDING_DELIVERY' && !scope.row.refunding" direction="vertical"></el-divider>
            <el-button v-if="isFactory() && scope.row.status === 'PENDING_DELIVERY' && !scope.row.refunding"
                       type="text" @click="onDeliverySubmit(scope.row)" class="purchase-list-button">去发货</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers('SalesOrdersModule');

  export default {
    name: 'SalesOrderSearchResultList',
    props: ['page'],
    components: {},
    computed: {
    },
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      judgeState (row) {
        if (row.refunding) {
          return '退款/售后';
        }
        return this.getEnum('salesOrderStatuses', row.status);
      },
      allowRemind (row) {
        if (!row.hasOwnProperty('nextReminderDeliveryTime')) {
          return true;
        }
        const nextTime = row.nextReminderDeliveryTime;
        const now = new Date().getTime();
        if (now - nextTime > 0) {
          return true;
        }
        return false;
      },
      handleFilterChange(val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged(val) {
        this._reset();

        if (this.$store.state.SalesOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.SalesOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        // this.$router.push({name:'销售订单详情',params:{}});
        this.$router.push('/order/sales/' + row.code);
      },
      countTotalQuantity(entries) {
        let amount = 0;
        entries.forEach(element => {
          amount += element.quantity;
        });
        return amount;
      },
      cannelOrder (row) {
        this.$confirm('是否确认取消订单?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this.$emit('cannelOrder', row);
        });
      },
      remindDelivery (row) {
        this.$confirm('是否要提醒商家发货?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this.$emit('remindDelivery', row);
        });
      },
      confirmDelivery (row) {
        this.$confirm('是否要确认收货?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this.$emit('confirmDelivery', row);
        });
      },
      onDeliverySubmit (row) {
        this.$emit('onDeliveryForm', row);
      }
      // getPaymentStatusTag(row) {
      //   return row.payStatus === 'PAID' ? 'static/img/paid.png' : 'static/img/arrears.png';
      // },
      // getSignedTag(row) {
      //   if (row.userAgreementIsSigned == null) {
      //     return 'static/img/not_signed.png';
      //   } else {
      //     return row.userAgreementIsSigned ? 'static/img/signed.png' : 'static/img/not_signed.png';
      //   }
      // },
      // getOperator(row) {
      //   if (this.$store.getters.currentUser.type == 'BRAND' && row.brandOperator != null) {
      //     return row.brandOperator.name;
      //   } else if (this.$store.getters.currentUser.type == 'FACTORY' && row.factoryOperator != null) {
      //     return row.factoryOperator.name;
      //   } else {
      //     return '';
      //   }
      // }
    },
    data() {
      return {
        statuses: this.$store.state.SalesOrdersModule.statuses
      }
    }
  }
</script>
<style>
  .purchase-list-button {
    color: #FFA403;
  }

  .ellipsis-name {
    width: 50px;
    white-space:nowrap;
    text-overflow:ellipsis;
    overflow:hidden;
  }
</style>
