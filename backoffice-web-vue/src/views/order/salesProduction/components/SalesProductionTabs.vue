<template>
  <div class="border-container">
    <el-dialog :visible.sync="salesProductAppendVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-plan-append-product-form v-if="salesProductAppendVisible" @onSave="onSave" :isUpdate="true"
        :updataEntry="updateEntry" :productionLeader="form.productionLeader" />
    </el-dialog>
    <div class="over-tabs">
      <el-row type="flex">
        <el-button v-if="isCreate" class="material-btn" @click="appendProduct">添加商品</el-button>
      </el-row>
    </div>
    <el-tabs type="border-card">
      <el-tab-pane label="产品明细">
        <!-- <el-table :data="form.entries" stripe style="width: 100%">
          <el-table-column type="selection" width="55">
          </el-table-column>
          <el-table-column prop="product.name" label="产品名称"></el-table-column>
          <el-table-column label="数量">
            <template slot-scope="scope">
              <span>{{getEntryTotalAmount(scope.row)}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="unitPrice" label="预计销售单价/元" min-width="100"></el-table-column>
          <el-table-column label="预计销售总价/元" min-width="100">
            <template slot-scope="scope">
              {{getEntryTotalPrice(scope.row)}}
            </template>
          </el-table-column>
          <el-table-column label="预计总成本">
            <template slot-scope="scope">
              {{getEntryTotalCost(scope.row)}}
            </template>
          </el-table-column>
          <el-table-column label="预计利润">
            <template slot-scope="scope">
              {{getEntryProfit(scope.row)}}
            </template>
          </el-table-column>
          <el-table-column label="预计利润率">
            <template slot-scope="scope">
              {{getEntryProfitPercent(scope.row)}}
            </template>
          </el-table-column>
          <el-table-column label="交货时间">
            <template slot-scope="scope">
              <span>{{scope.row.deliveryDate | timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="审核状态">
            <template slot-scope="scope">
              <span>{{scope.row.status!=null? getEnum('SalesProductionOrderEntryAuditStatus', scope.row.auditState):''}}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" min-width="120">
            <template slot-scope="scope">
              <el-button type="text" @click="onModify(scope.$index)">编辑</el-button>
              <el-button slot="reference" type="text" @click="onDelete(scope.$index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table> -->
        <sales-production-products-table :form="form" @onDelete="onDelete" @onModify="onModify" />
      </el-tab-pane>
    </el-tabs>
    <el-dialog :visible.sync="salesProductDetailsVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-plan-product-detail v-if="salesProductDetailsVisible" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    Popconfirm
  } from 'element-ui';

  import SalesPlanProductDetail from '../details/SalesPlanProductDetail';
  import SalesPlanAppendProductForm from '../form/SalesPlanAppendProductForm';
  import SalesProductionProductsTable from './SalesProductionProductsTable';

  export default {
    name: 'SalesProductionTabs',
    components: {
      SalesPlanProductDetail,
      SalesPlanAppendProductForm,
      SalesProductionProductsTable
    },
    props: {
      isCreate: {
        type: Boolean,
        default: true
      },
      form: {
        type: Object
      }
    },
    methods: {
      appendProduct() {
        this.$emit('appendProduct');
      },
      handleCommand(command) {
        switch (command) {
          case 'delete':
            this.onDelete();
            break;
          case 'close':
            this.onClose();
            break;
          case 'modify':
            this.onModify();
            break;
        }
      },
      onProductDetail(row) {
        this.salesProductDetailsVisible = true;
      },
      onDelete(index) {
        this.$confirm('确认删除？')
          .then(_ => {
            this.form.entries.splice(index, 1);
            popVisible = false;
          })
          .catch(_ => {});
      },
      onClose() {
        this.$message('------close--------');
      },
      onModify(index) {
        this.updateIndex = index;
        this.updateEntry = this.form.entries[index];
        this.salesProductAppendVisible = true;
      },
      //数量
      getEntryTotalAmount(entry) {
        var result = 0;
        entry.colorSizeEntries.forEach(element => {
          let num = parseFloat(element.quantity);
          if (!Number.isNaN(num)) {
            result += num
          }
        });
        return result;
      },
      //销售总价    
      getEntryTotalPrice(entry) {
        let result = this.getEntryTotalAmount(entry) * (parseFloat(entry.unitPrice));
        if (!Number.isNaN(result)) {
          return result;
        } else {
          return '';
        }
      },
      //总成本
      getEntryTotalCost(entry) {
        let result = this.getEntryTotalAmount(entry) * (parseFloat(entry.costOrder.totalPrice));
        if (!Number.isNaN(result)) {
          return result;
        } else {
          return '';
        }
      },
      //利润
      getEntryProfit(entry) {
        let result = '';
        if (this.getEntryTotalPrice(entry) != '' && this.getEntryTotalCost(entry) != '') {
          result = this.getEntryTotalPrice(entry) - this.getEntryTotalCost(entry);
        }
        return result;
      },
      //利润率
      getEntryProfitPercent(entry) {
        let profit = this.getEntryProfit(entry);
        let totalPrice = this.getEntryTotalPrice(entry);
        if (profit != '' && totalPrice != '') {
          return (parseFloat(profit / totalPrice) * 100).toFixed(2);
        } else {
          return '';
        }
      },
      //编辑回调
      onSave(entries) {
        var newEntry = Object.assign(this.updateEntry, entries[0]);
        this.$set(this.form.entries, this.updateIndex, newEntry);
        this.salesProductAppendVisible = false;
      }
    },
    data() {
      return {
        salesProductDetailsVisible: false,
        popVisible: false,
        updateEntry: null,
        updateIndex: null,
        salesProductAppendVisible: false,
      }
    }
  }

</script>

<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 100px;
    height: 40px;
    border-radius: 5px;
  }

  .border-container {
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    background-color: #F5F5F5;
  }

  .sales-container-box {
    background-color: #D5D5DE;
    padding: 18px;
    border-radius: 3px;
  }

  .el-dropdown-link {
    cursor: pointer;
    color: #409EFF;
    font-size: 12px;
  }

  .el-icon-arrow-down {
    font-size: 12px;
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

</style>
