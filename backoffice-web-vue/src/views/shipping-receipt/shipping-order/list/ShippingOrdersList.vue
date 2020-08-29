<template>
  <div class="shipping-order-list-container">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" row-key="id"
      @selection-change="handleSelectionChange" @row-click="rowClick">
      <el-table-column type="selection" :reserve-selection="true" width="55" v-if="canCreateReceipt"></el-table-column>
      <el-table-column label="发货单号" prop="code" min-width="110px" fixed="left"></el-table-column>
      <el-table-column label="产品名称" min-width="150px">
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
      <el-table-column label="跟单员">
        <template slot-scope="scope">
          <span v-if="mode=='import'">{{scope.row.merchandiser?scope.row.merchandiser.name:''}}</span>
          <span v-if="mode=='export'">{{scope.row.originMerchandiser?scope.row.originMerchandiser.name:''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="发货数/收货数" min-width="70px">
        <template slot-scope="scope">
          <span>{{getTotalNum(scope.row)}}/{{countTotalSheetsNum(scope.row.receiptSheets)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="发货日期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="收货单" min-width="110px">
        <template slot-scope="scope" v-if="scope.row.receiptSheets!=null">
          <template v-for="(sheet,sheetIndex) in scope.row.receiptSheets">
            <el-row :key="'sheet'+sheetIndex" type="flex">
              <el-button type="text" @click="onReceiptDetail(scope.row.receiptSheets[sheetIndex].id)">
                {{scope.row.receiptSheets[sheetIndex].code}}</el-button>
            </el-row>
          </template>
        </template>
      </el-table-column>
      <el-table-column label="收货数量">
        <template slot-scope="scope" v-if="scope.row.receiptSheets!=null">
          <span>{{countTotalSheetsNum(scope.row.receiptSheets)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="退货单" min-width="110px">
        <template slot-scope="scope" v-if="scope.row.returnSheets!=null">
          <template v-for="(sheet,sheetIndex) in scope.row.returnSheets">
            <el-row :key="'sheet'+sheetIndex" type="flex">
              <el-button type="text" @click="onReturnDetail(scope.row.returnSheets[sheetIndex].id)">
                {{scope.row.returnSheets[sheetIndex].code}}</el-button>
            </el-row>
          </template>
        </template>
      </el-table-column> -->
      <el-table-column label="退货数/退货已收数">
        <template slot-scope="scope">
          <span>{{scope.row.returnQuantity}}/{{scope.row.returnReceivedQuantity}}</span>
        </template>
      </el-table-column>
      <el-table-column label="差异数/复议数/通过数">
        <template slot-scope="scope">
          <span>{{scope.row.diffQuantity?scope.row.diffQuantity:0}}/{{getReconsiderQuantity(scope.row)}}/{{getReconsiderPassQuantity(scope.row)}}</span>
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
    name: 'ShippingOrdersList',
    props: {
      page: {
        type: Object,
        required: true
      },
      canCreateReceipt: {
        type: Boolean,
        default: false
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
      onReceiptDetail(id) {
        this.$router.push('/receipt/orders/' + id);
      },
      onReturnDetail(id) {
        this.$router.push('/returned/orders/' + id);
      },
      handleSelectionChange(val) {
        // 限制单选
        if (val.length > 1) {
          this.$refs.resultTable.toggleRowSelection(val[0], false);
          this.selectionRow = val[val.length - 1];
        } else if (val.length == 1) {
          this.selectionRow = val[val.length - 1];
        } else if (val.length == 0) {
          this.selectionRow = '';
        }
      },
      rowClick(row) {
        if (this.selectionRow == '') {
          this.$refs.resultTable.toggleRowSelection(row, true);
        } else {
          if (this.selectionRow.id == row.id) {
            this.$refs.resultTable.toggleRowSelection(row, false);
          } else {
            this.$refs.resultTable.toggleRowSelection(this.selectionRow, false);
            this.$refs.resultTable.toggleRowSelection(row, true);
          }
        }
      },
      //统计单数
      countTotalSheetsNum(sheets) {
        let result = 0;
        if (sheets != null) {
          sheets.forEach(element => {
            let num = parseInt(element.totalQuantity);
            if (!Number.isNaN(num)) {
              result += num;
            }
          });
        }
        return result;
      },
      //统计发货数量
      getTotalNum(order) {
        let result = 0;
        if (order.packageSheets != null) {
          order.packageSheets.forEach(element => {
            if (element.colorSizeEntries != null) {
              element.colorSizeEntries.forEach(entry => {
                let num = parseInt(entry.quantity);
                if (!Number.isNaN(num)) {
                  result += num;
                }
              });
            }
          });
        }
        return result;
      },
      //复议数
      getReconsiderQuantity(row) {
        let result = 0;
        if (row.reconsiderSheets) {
          row.reconsiderSheets.forEach(sheet => {
            if (sheet.reconsiderQuantity) {
              result += sheet.reconsiderQuantity;
            }
          });
        }
        return result;
      },
      //复议通过
      getReconsiderPassQuantity(row) {
        let result = 0;
        if (row.reconsiderSheets) {
          row.reconsiderSheets.forEach(sheet => {
            if (sheet.reconsiderPassQuantity) {
              result += sheet.reconsiderPassQuantity;
            }
          });
        }
        return result;
      },
    },
    data() {
      return {
        selectionRow: '',
        openId: '',
        dialogVisible: false
      }
    },
    create() {

    },
    watch: {
      'page.content': function (n, o) {
        this.$nextTick(() => {
          this.$refs.resultTable.doLayout()
        })
      },
    },
  }

</script>

<style scoped>
  .shipping-order-list-container>>>.el-table th>.cell .el-checkbox {
    display: none;
  }

</style>
