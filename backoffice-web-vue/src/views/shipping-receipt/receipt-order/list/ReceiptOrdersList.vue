<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="收货单号" prop="code" min-width="120" fixed></el-table-column>
      <el-table-column label="产品名称" min-width="150">
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
      <el-table-column :label="mode=='import'?'生产工单':'关联外发工单'" min-width="110px">
        <template slot-scope="scope">
          <el-button type="text" v-if="scope.row.productionTaskOrder!=null"
            @click="onProductionOrderDetail(scope.row.productionTaskOrder.id)">{{scope.row.productionTaskOrder.code}}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="合作商">
        <template slot-scope="scope">
          <span v-if="mode=='import'">{{scope.row.receiveParty?scope.row.receiveParty.name:''}}</span>
          <span v-if="mode=='export'">{{scope.row.shipParty?scope.row.shipParty.name:''}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="品类" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.product.category.parent.name}} - {{scope.row.product.category.name}}</span>
        </template>
      </el-table-column> -->
      <!-- <el-table-column label="收货人" prop="creator.name"></el-table-column> -->
      <el-table-column label="跟单员">
        <template slot-scope="scope">
          <span v-if="mode=='import'">{{scope.row.merchandiser?scope.row.merchandiser.name:''}}</span>
          <span v-if="mode=='export'">{{scope.row.originMerchandiser?scope.row.originMerchandiser.name:''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="单价" prop="productionTaskOrder.unitPrice"></el-table-column>
      <el-table-column label="收货数量" prop="totalQuantity" />
      <el-table-column label="收货总额">
        <template slot-scope="scope">
          <span>{{countTotalPrice(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货日期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('ShippingSheetState', scope.row.state)}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="操作" fixed="right">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-order-detail :id="openId" v-if="dialogVisible" />
    </el-dialog>
  </div>
</template>

<script>
  import ProductionOrderDetail from '../../../order/salesProduction/production-order/details/ProductionOrderDetail'

  export default {
    name: 'ReceiptOrdersList',
    props: {
      page: {

      },
      mode: {
        type: String,
        default: 'import'
      }
    },
    components: {
      ProductionOrderDetail
    },
    computed: {

    },
    methods: {
      onDetail(row) {
        this.$emit('onDetail', row);
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
      onProductionOrderDetail(id) {
        // this.$router.push('/sales/productionOrder/' + id);
        this.openId = id;
        this.dialogVisible = true;
      },
      countTotalPrice(row) {
        let unitPrice = 0;
        let result = 0;
        if (row.productionTaskOrder) {
          unitPrice = row.productionTaskOrder.unitPrice;
          result = unitPrice * row.totalQuantity;
        }
        return result.toFixed(2);
      }
    },
    data() {
      return {
        openId: '',
        dialogVisible: false
      }
    },
    create() {

    }
  }

</script>

<style scoped>

</style>
