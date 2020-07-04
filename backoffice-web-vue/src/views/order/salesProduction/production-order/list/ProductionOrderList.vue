<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed" :row-key="'id'"
      :height="autoHeight" @selection-change="handleSelectionChange" @row-click="rowClick" :reserve-selection="true">
      <el-table-column type="selection" width="50px" :selectable="rowDisabled" v-if="!isOutProduction" fixed></el-table-column>
      <el-table-column label="生产订单号" min-width="115">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" v-if="!isAllocating && !isOutProduction">
            <el-tag type="info" effect="plain" :style="orderTypeTagMap[scope.row.type]">
              {{getEnum('ProductionTaskOrderType', scope.row.type)}}</el-tag>
          </el-row>
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="产品" min-width="180">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product!=null?scope.row.product.name:''}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
              <el-row>
                <!-- <span>数量:{{countTotalQuantity(scope.row.entries)}}</span> -->
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="品类" min-width="115">
        <template slot-scope="scope">
          <span>{{scope.row.product !=null ? 
            scope.row.product.category.parent.name + '-' + scope.row.product.category.name : ''}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="客户"></el-table-column> -->
      <el-table-column label="订单数量" prop="quantity" min-width="70"></el-table-column>
      <el-table-column label="负责人" prop="productionLeader.name" min-width="60"></el-table-column>
      <el-table-column label="跟单员" prop="merchandiser.name" min-width="60"></el-table-column>
      <el-table-column label="创建时间" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交货时间" min-width="90">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签" v-if="!isOutProduction && !isAllocating">
        <template slot-scope="scope" v-if="scope.row.type == 'FOUNDRY_PRODUCTION'">
          <el-tag :color="isOuted(scope.row) ? '#FFD60C':'#ffffff'" style="color: #303133">
            {{isOuted(scope.row) ? '已外发' : '未外发'}}
          </el-tag>
        </template>
        <template slot-scope="scope" v-if="scope.row.type == 'SELF_PRODUCED'">
          <el-tag color="#FFD60C" style="color: #303133">自产</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" min-width="60" v-if="!isAllocating">
        <template slot-scope="scope">
          <span>{{getEnum('ProductionTaskOrderState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="80">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">明细</el-button>
          </el-row>
        </template>
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
  } = createNamespacedHelpers('ProductionOrderModule');

  export default {
    name: 'ProductionOrderList',
    props: {
      page: {
        type: Object,
        required: true
      },
      vSelectRow: {
        type: Array
      },
      isOutProduction: {
        type: Boolean,
        default: false
      },
      isAllocating: {
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
      isOuted (row) {
        if (row.outboundOrderCode) {
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

        if (this.$store.state.ProductionOrderModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.ProductionOrderModule.isAdvancedSearch) {
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
        this.$router.push('/sales/productionOrder/' + row.id);
      },
      countTotalQuantity(entries) {
        let amount = 0;
        entries.forEach(element => {
          amount += element.quantity;
        });
        return amount;
      },
      rowDisabled (row, index) {
        if (row.outboundOrderCode || row.type == 'SELF_PRODUCED') {
          return false;
        }
        return true;
      },
      handleSelectionChange (val) {
        this.selectRow = val;
      },
      rowClick (row, column, event) {
        if (row.outboundOrderCode || row.type == 'SELF_PRODUCED') {
          return;
        }
        this.$refs.resultTable.toggleRowSelection(row);
      },
      // getPaymentStatusTag (row) {
      //   return row.payStatus === 'PAID' ? 'static/img/paid.png' : 'static/img/arrears.png';
      // },
      // getSignedTag (row) {
      //   if (row.userAgreementIsSigned == null) {
      //     return 'static/img/not_signed.png';
      //   } else {
      //     return row.userAgreementIsSigned ? 'static/img/signed.png' : 'static/img/not_signed.png';
      //   }
      // },
      // getOperator (row) {
      //   if (this.$store.getters.currentUser.type == 'BRAND' && row.brandOperator != null) {
      //     return row.brandOperator.name;
      //   } else if (this.$store.getters.currentUser.type == 'FACTORY' && row.factoryOperator != null) {
      //     return row.factoryOperator.name;
      //   } else {
      //     return '';
      //   }
      // },
      onUpdate(row) {
        // this.$emit('onUpdate', row);
      }
    },
    watch: {
      vSelectRow: function (newVal, oldVal) {
        this.selectRow = newVal;
      },
      selectRow: function (newVal, oldVal) {
        this.$emit('update:vSelectRow', newVal);
      }
    },
    data() {
      return {
        statuses: this.$store.state.ProductionOrderModule.statuses,
        selectRow: [],
        orderTypeTagMap: {
          'SELF_PRODUCED': {
            'color': '#ffd60c',
            'borderColor': '#ffd60c'
          },
          'FOUNDRY_PRODUCTION': {
            'color': '#67c23a',
            'borderColor': '#67c23a'
          },
        }
      }
    },
    created () {
      this.selectRow = this.vSelectRow;
    }
  }

</script>
<style>
  .purchase-list-button {
    color: #FFA403;
  }

</style>
