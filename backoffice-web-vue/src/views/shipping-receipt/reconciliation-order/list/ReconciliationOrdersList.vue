<template>
  <div class="shipping-order-list-container">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" row-key="id"
      @selection-change="handleSelectionChange" @row-click="rowClick">
      <el-table-column label="对账单号" prop="code" min-width="120"></el-table-column>
      <el-table-column label="商品名称" min-width="150px">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product.name}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <!-- <el-table-column label="关联发货单" min-width="120px">
        <template slot-scope="scope">
          <el-row v-for="item in scope.row.shippingSheets" :key="item.id">
            <el-button type="text" @click="onShipDetail(item.id)">{{item.code}}</el-button>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="关联收货单" min-width="120px">
        <template slot-scope="scope">
          <el-row v-for="item in scope.row.shippingSheets" :key="item.id">
            <el-button type="text" @click="onReceDetail(item.receiptSheets[0].id)">{{item.receiptSheets[0].code}}
            </el-button>
          </el-row>
        </template>
      </el-table-column> -->
      <el-table-column label="关联对账任务" min-width="120px">
        <template slot-scope="scope">
          <el-button type="text" @click="onReconciliationTaskDetail(scope.row.reconciliationTask.id)">
            {{scope.row.reconciliationTask.code}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="关联订单" min-width="120px">
        <template slot-scope="scope">
          <el-button type="text" @click="onProductionOrderDetai(scope.row.productionTaskOrder.id)"
            v-if="scope.row.productionTaskOrder">
            {{scope.row.productionTaskOrder.code}}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="单价" prop="productionTaskOrder.unitPrice"></el-table-column>
      <el-table-column label="收货数量" prop="reconciliationQuantity"></el-table-column>
      <el-table-column label="收货总额" prop="reconciliationAmount"></el-table-column>
      <el-table-column label="对账日期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('ReconciliationOrderState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" fixed="right">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row.id)">详情</el-button>
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
  export default {
    name: 'ReconciliationOrdersList',
    props: {
      page: {
        type: Object,
        required: true
      },
      canCreateReceipt: {
        type: Boolean,
        default: false
      }
    },
    components: {

    },
    computed: {

    },
    methods: {
      onShipDetail(id) {
        this.$router.push('/shipping/orders/' + id);
      },
      onReceDetail(id) {
        this.$router.push('/receipt/orders/' + id);
      },
      onProductionOrderDetai(id) {
        this.$router.push('/sales/productionOrder/' + id);
      },
      onDetail(id) {
        this.$router.push('/reconciliation/orders/' + id);
      },
      onPageSizeChanged(val) {
        this.$emit('onAdvancedSearch', 0, val);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged(val) {
        this.$emit('onAdvancedSearch', val - 1);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onReconciliationTaskDetail(id) {
        this.$router.push('/reconciliation/tasks/detail/' + id);
      },
      handleSelectionChange(val) {
        console.log(val);
      },
      rowClick(row) {
        this.$refs.resultTable.toggleRowSelection(row);
      }
    },
    data() {
      return {
        selectionRow: []
      }
    },
    watch: {
      'page.content': function (n, o) {
        this.$nextTick(() => {
          this.$refs.resultTable.doLayout()
        })
      },
    },
    create() {

    }
  }

</script>

<style scoped>
  .shipping-order-list-container>>>.el-table th>.cell .el-checkbox {
    display: none;
  }

</style>
