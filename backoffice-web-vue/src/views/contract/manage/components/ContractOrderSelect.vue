<template>
  <div class="animated fadeIn">
    <div style="height: 50px;">
      <el-form :inline="true">
        <!--<el-form-item label="">-->
        <!--<el-input placeholder="请输入产品货号/名称查询" v-model="keyword"></el-input>-->
        <!--</el-form-item>-->
        <!-- <el-button-group> -->
        <!--<el-button type="text" @click="onSearch">查找</el-button>-->
        <!-- </el-button-group> -->
        <el-button class="product-select-btn" @click="onSelected">确定</el-button>
      </el-form>
    </div>
    <!--<el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed"-->
    <!--:height="autoHeight">-->
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight"
        @selection-change="handleSelectionChange" @row-click="clickRow">
      <el-table-column type="selection" width="55">
      </el-table-column>
      <el-table-column label="生产订单号" min-width="130">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
            <el-tag>{{getEnum('salesApplication', scope.row.salesApplication)}}</el-tag>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="产品" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'">
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
      <!--<el-table-column label="跟单员">-->
      <!--</el-table-column>-->
      <!-- <el-table-column label="预计交货时间" prop="expectedDeliveryDate">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | formatDate}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="订单生成时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签">
        <template slot-scope="scope">
          <el-row>
            <img width="40px" height="15px" :src="getPaymentStatusTag(scope.row)" />
          </el-row>
          <el-row>
            <img width="40px" height="15px" :src="getSignedTag(scope.row)" />
          </el-row>
        </template>
      </el-table-column>
      <!--<el-table-column label="操作" min-width="100">-->
      <!--<template slot-scope="scope">-->
      <!--<el-row>-->
      <!--<el-button type="text" @click="onSelected(scope.row)" class="purchase-list-button">选择</el-button>-->
      <!--</el-row>-->
      <!--</template>-->
      <!--</el-table-column>-->
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
    name: 'ContractOrderSelect',
    props: ['page'],
    components: {},
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      async handleFilterChange (val) {
        this.statuses = val.status;

        // this.$emit('onSearchOrder','', 0,10);
        const url = this.apis().getPurchaseOrders();
        const result = await this.$http.post(url, {
          keyword: ''
        }, {
          page: 0,
          size: 10
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.page = result;
      },
      async onPageSizeChanged (val) {
        this._reset();
        this.$emit('onSearchOrder', 0, val);
      },
      async onCurrentPageChanged (val) {
        this.$emit('onSearchOrder', val - 1);
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
      onSelected () {
        // if (item.code == this.selectedItem.code) {
        //   //空选择
        //   this.selectedItem = {};
        // } else {
        //   this.selectedItem = item;
        // }
        this.$emit('onOrderSelectChange', this.selectedItems);
      },
      handleSelectionChange (val) {
        this.selectedItems = val;
      },
      // 选中行
      handleCurrentChange (val) {
        this.selectedItems = val;
      },
      getPaymentStatusTag (row) {
        return row.balancePaid ? 'static/img/paid.png' : 'static/img/arrears.png';
      },
      getSignedTag (row) {
        if (row.userAgreementIsSigned == null) {
          return 'static/img/not_signed.png';
        } else {
          return row.userAgreementIsSigned ? 'static/img/signed.png' : 'static/img/not_signed.png';
        }
      },
      clickRow (row) {
        this.$refs.resultTable.toggleRowSelection(row);
      }
    },
    data () {
      return {
        statuses: this.$store.state.PurchaseOrdersModule.statuses,
        selectedItems: [],
        keyword: ''
      }
    }
  }
</script>
<style>
  .purchase-list-button {
    color: #FFA403;
  }

  .product-info {
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-size: 12px;
  }

  .el-table--striped .el-table__body tr.el-table__row--striped.current-row td {
    background-color: #ffc107;
  }

  .product-select-btn {
    width: 70px;
    height: 30px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
    margin-top: 10px;
  }

  .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }

</style>
