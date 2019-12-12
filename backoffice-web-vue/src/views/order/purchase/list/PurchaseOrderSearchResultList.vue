<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed"
      :height="autoHeight">
      <el-table-column label="生产订单号" min-width="130">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
            <img width="50px" height="15px"
              :src="scope.row.salesApplication=='ONLINE'?'static/img/online.png':'static/img/offline.png'" />
            <!-- <el-tag>{{getEnum('salesApplication', scope.row.salesApplication)}}</el-tag> -->
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="产品" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'">
              </img>
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
              <el-row>
                <span>数量:{{countTotalQuantity(scope.row.entries)}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="品牌" v-if="!isBrand()" prop="belongTo.name">
        <template slot-scope="scope">
          <span v-if="scope.row.purchaser">{{scope.row.purchaser.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="工厂" v-if="!isFactory()" prop="belongTo.name">
        <template slot-scope="scope">
          <span v-if="scope.row.belongTo">{{scope.row.belongTo.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="生产订单状态" prop="status" :column-key="'status'" :filters="statuses">
        <template slot-scope="scope">
          <!-- <el-tag disable-transitions>{{getEnum('purchaseOrderStatuses', scope.row.status)}}</el-tag> -->
          <span>{{getEnum('purchaseOrderStatuses', scope.row.status)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="跟单员">
        <template slot-scope="scope">
          <span>{{getOperator(scope.row)}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="预计交货时间" prop="expectedDeliveryDate">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | formatDate}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="订单生成时间" min-width="100">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签">
        <template slot-scope="scope">
          <el-row v-if="scope.row.payStatus != null && scope.row.payStatus != 'UNPAID'">
            <img width="40px" height="15px" :src="getPaymentStatusTag(scope.row)" />
          </el-row>
          <el-row>
            <img width="40px" height="15px" :src="getSignedTag(scope.row)" />
          </el-row>
<!--          <el-row v-if="scope.row.cannelStatus == 'APPLYING'">-->
<!--            <img width="40px" height="15px" :src="getCannelTag(scope.row)" />-->
<!--          </el-row>-->
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">明细</el-button>
            <el-divider direction="vertical"></el-divider>
            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">账务</el-button>
            <el-divider direction="vertical"></el-divider>
            <el-button type="text" v-if="scope.row.status=='PENDING_CONFIRM'" @click="onUpdate(scope.row)"
              class="purchase-list-button">修改订单</el-button>
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
  } = createNamespacedHelpers('PurchaseOrdersModule');

  export default {
    name: 'PurchaseOrderSearchResultList',
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
      },
      onUpdate(row) {
        this.$emit('onUpdate', row);
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
