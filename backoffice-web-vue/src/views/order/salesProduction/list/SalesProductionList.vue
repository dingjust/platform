<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed"
      :height="autoHeight">
      <el-table-column label="主订单号" prop="code" min-width="130" v-if="!isPending"/>
      <el-table-column label="订单号" min-width="130" v-if="isPending">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <el-tag type="info" effect="plain" :class="scope.row.originCompany == null ? 'business-tag' : 'pending-tag'">
              {{scope.row.originCompany == null ? '业务订单' : '线上接单'}}</el-tag>
          </el-row>
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="客户" v-if="isPending">
        <template slot-scope="scope">
          <span>{{cooperatorName(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建人" prop="creator.name">
      </el-table-column>
      <el-table-column label="生产负责人" prop="productionLeader.name" v-if="!isPending">
      </el-table-column>
      <el-table-column label="创建日期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="审批状态" v-if="isPending">
        <template slot-scope="scope">
          <span>{{scope.row.auditState!=null? getEnum('SalesProductionAuditStatus', scope.row.auditState):''}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="订单状态">
        <template slot-scope="scope">
          <span>{{getEnum('SalesProductionOrderState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签" min-width="100">
      </el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">详情</el-button>
            <!-- <el-divider direction="vertical"></el-divider>
            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">删除</el-button> -->
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
  } = createNamespacedHelpers('SalesProductionOrdersModule');

  export default {
    name: 'SalesProductionList',
    props: {
      page: {
        type: Object
      },
      isPending: {
        type: Boolean,
        default: false
      }
    },
    components: {},
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      cooperatorName (row) {
        if (row.originCompany != null) {
          return row.originCompany.name;
        } else {
          return row.originCooperator.type == 'ONLINE' ? row.originCooperator.partner.name : row.originCooperator.name;
        }
      },
      getCustName(row) {
        if (row.originCooperator != null) {
          if (row.originCooperator.type == 'ONLINE') {
            return row.originCooperator.partner.name;
          } else {
            return row.originCooperator.name;
          }
        }
        return '';
      },
      allowRemind(row) {
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

        if (this.$store.state.SalesProductionOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.SalesProductionOrdersModule.isAdvancedSearch) {
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
        this.$router.push((row.type == 'SALES_ORDER' ? '/sales/order/' : '/sales/plan/') + row.id);
      },
      countTotalQuantity(entries) {
        let amount = 0;
        entries.forEach(element => {
          amount += element.quantity;
        });
        return amount;
      },
      cannelOrder(row) {
        this.$confirm('是否确认取消订单?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this.$emit('cannelOrder', row);
        });
      },
      remindDelivery(row) {
        this.$confirm('是否要提醒商家发货?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this.$emit('remindDelivery', row);
        });
      },
      confirmDelivery(row) {
        this.$confirm('是否要确认收货?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this.$emit('confirmDelivery', row);
        });
      },
      onDeliverySubmit(row) {
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
        statuses: this.$store.state.SalesProductionOrdersModule.statuses,
        orderTypeTagMap: {
          'SALES_PLAN': {
            'color': '#ffd60c',
            'borderColor': '#ffd60c'
          },
          'SALES_ORDER': {
            'color': '#67c23a',
            'borderColor': '#67c23a'
          },
        }
      }
    }
  }

</script>
<style scoped>
  .purchase-list-button {
    color: #FFA403;
  }

  .ellipsis-name {
    width: 50px;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }

  .pending-tag {
    color: #67c23a;
    border-Color: #67c23a
  }

  .business-tag {
    color: #ffd60c;
    border-Color: #ffd60c
  }
</style>
