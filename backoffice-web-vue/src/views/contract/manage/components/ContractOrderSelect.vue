<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed"
      :height="autoHeight">
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
              <img width="54px" height="54px" :src="scope.row.product.thumbnail.url">
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>货号:{{scope.row.product.skuID}}</span>
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
        <span>刘少立</span>
      </el-table-column>
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
        <el-tag type="danger">欠款</el-tag>
      </el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onSelected(scope.row)" class="purchase-list-button">选择</el-button>
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
    name: 'ContractOrderSelect',
    props: ["page"],
    components: {},
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      async handleFilterChange(val) {
        this.statuses = val.status;

        // this.$emit('onSearchOrder','', 0,10);
        const url = this.apis().getPurchaseOrders();
        const result = await this.$http.post(url,{
          keyword: ''
        }, {
          page: 0,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.page = result;
        console.log(result);
      },
      async onPageSizeChanged(val) {
        this._reset();
        console.log(val);
        const url = this.apis().getPurchaseOrders();
        const result = await this.$http.post(url,{
          keyword: ''
        }, {
          page: val,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.page = result;
        console.log(result);
      },
      async onCurrentPageChanged(val) {
        const url = this.apis().getPurchaseOrders();
        const result = await this.$http.post(url,{
          keyword: ''
        }, {
          page: val - 1,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.page = result;
        console.log(result);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
      countTotalQuantity(entries) {
        let amount = 0;
        entries.forEach(element => {
          amount += element.quantity;
        });
        return amount;
      },
      onSelected(item) {
        if (item.code == this.selectedItem.code) {
          //空选择
          this.selectedItem = {};
        } else {
          this.selectedItem = item;
        }
        console.log(this.selectedItem);
        this.$emit('onOrderSelectChange',this.selectedItem );
      },
    },
    data() {
      return {
        statuses: this.$store.state.PurchaseOrdersModule.statuses,
        selectedItem:{},
      }
    }
  }

</script>
<style>
.purchase-list-button{
  color: #FFA403;
}
</style>

