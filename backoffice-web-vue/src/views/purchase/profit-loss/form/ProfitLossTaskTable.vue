<!--
* @Description: 盈亏分析表单中的工单表
* @Date 2021/03/19 10:31
* @Author L.G.Y
-->
<template>
  <div class="task-table">
    <div class="top-row">
      <div>
        <h6 class="table-title">生产工单：{{task.code}}
          <span style="color: #909399" v-if="todoColor !== ''">
            (尚未对<span style="color: #F56C6C"> {{todoColor}} </span>进行盈亏分析)
          </span>
        </h6>
      </div>
      <div>
        <el-button type="text" @click="columnVisible = true">添加成本费用</el-button>
        <el-divider direction="vertical"></el-divider>
        <el-button type="text" @click="addRow">添加行</el-button>
      </div>
    </div>
    <el-table :data="tableData" border >
      <el-table-column label="基本信息" header-align="center">
        <el-table-column label="款号" prop="skuID" min-width="120px">
          <template slot-scope="scope">
            <span v-if="scope.row.countRow">{{scope.row.countRow}}</span>
            <span v-else>{{scope.row.skuID}}</span>
          </template>
        </el-table-column>
        <el-table-column label="品类" prop="category.name" min-width="120px"></el-table-column>
        <el-table-column label="颜色" prop="colors" min-width="180px">
          <template slot-scope="scope">
            <el-select v-if="!scope.row.countRow" v-model="scope.row.colors" multiple placeholder="请选择" 
                        value-key="id" @change="handleChange($event, scope.row)" :disabled="scope.row.purchaseTaskId != null">
              <el-option v-for="item in options"
                :key="item.id"
                :label="item.colorName"
                :value="item"
                :disabled="optionDisabled(item, scope.row)">
              </el-option>
            </el-select>
          </template>
        </el-table-column>
      </el-table-column>
      <el-table-column label="客户报价" header-align="center"	>
        <el-table-column label="合同单价" prop="unitContractAmount" min-width="120px"></el-table-column>
        <el-table-column label="数量" prop="totalQuantity" min-width="120px"></el-table-column>
        <el-table-column label="合同金额" prop="totalContractAmount" min-width="120px">
          <template slot-scope="scope">
            <span v-if="scope.row.countRow">{{scope.row.totalContractAmount}}</span>
            <span v-else>{{calculation(scope.row, 'unitContractAmount').toFixed(2)}}</span>
          </template>
        </el-table-column>
      </el-table-column>
      <el-table-column label="成本费用" header-align="center">
        <el-table-column label="单价成本" prop="unitCostAmount" min-width="120px">
          <template slot-scope="scope" v-if="!scope.row.countRow">
            <div class="top-row" style="flex-wrap: wrap">
              <span>{{scope.row.unitCostAmount.toFixed(4)}}</span>
              <div>
                <el-button v-if="scope.row.costOrder.product" type="text" :disabled="scope.row.purchaseTaskId != null"
                            @click="modifyCost(scope.$index, scope.row.costOrder)" :title="tips">修改</el-button>
                <el-button type="text" style="margin: 0px" :disabled="scope.row.purchaseTaskId != null" 
                            @click="openCostList(scope.$index)" :title="tips">选择</el-button>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="成本总额" prop="totalCostAmount" min-width="120px">
          <template slot-scope="scope">
            <span v-if="scope.row.countRow">{{scope.row.totalCostAmount}}</span>
            <span v-else>{{calculation(scope.row, 'unitCostAmount').toFixed(4)}}</span>
          </template>
        </el-table-column>
        <template v-if="item.additionalCharges.length > 0">
          <el-table-column v-for="(column, index) in item.additionalCharges" :key="column.key" min-width="120px">
            <template slot="header" slot-scope="scope">
              <div style="display: flex;align-items: baseline">
                <span>{{column.remarks}}</span>
                <el-button type="text" @click="onModifyColName(column)">修改</el-button>
                <el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteCol(index)"/>
              </div>
            </template>
            <template slot-scope="scope">
              <el-input v-model="scope.row.additionalCharges[index].amount"
                        v-if="!scope.row.countRow"
                        @change="inputChange(scope.$index, index)" 
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
            </template>
          </el-table-column>
        </template>
        <el-table-column label="总金额" prop="totalAmount" min-width="120px">
          <template slot-scope="scope">
            <span v-if="scope.row.countRow">{{scope.row.totalAmount}}</span>
            <span v-else>{{totalAmount(scope.row).toFixed(4)}}</span>
          </template>
        </el-table-column>
      </el-table-column>
      <el-table-column label="盈亏评估" header-align="center">
        <el-table-column label="总盈亏" prop="totalProfitLossAmount" min-width="120px">
          <template slot-scope="scope">
            <span>{{(scope.row.totalContractAmount - scope.row.totalAmount).toFixed(2)}}</span>
          </template>
        </el-table-column>
        <el-table-column label="盈亏比例" prop="profitLossRatio" min-width="120px">
          <template slot-scope="scope">
            <span>{{profitLossRatio(scope.row)}}%</span>
          </template>
        </el-table-column>
      </el-table-column>
      <el-table-column label="操作" min-width="120px">
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-button :disabled="scope.row.purchaseTaskId != null" type="text" @click="onDelete(scope.$index)" :title="tips">删除</el-button>
          <el-button v-if="scope.row.purchaseTaskId" type="text" @click="onPurhcaseDetail(scope.row)">采购详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :title="columnDialogtitle" :visible.sync="columnVisible" width="400px" 
                append-to-body :close-on-click-modal="false" :show-close="false" :close-on-press-escape="false">
      <append-column v-if="columnVisible" :modifyColumn="modifyColumn" 
                      @toModifyColumn="_modifyColumn" @addColumn="addColumn" @callback="callback" />
    </el-dialog>
    <el-dialog :visible.sync="costDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <cost-select-list v-if="costDialogVisible" @onSelectCost="onSelectCost" :product="task.product"/>
    </el-dialog>
    <el-dialog :visible.sync="editDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <cost-edit-form v-if="editDialogVisible" :costOrder="handleCostOrder" @editCostForm="editCostForm"/>
    </el-dialog>
    <el-dialog :visible.sync="purchaseDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <purchase-requirement-detail v-if="purchaseDialogVisible" :id="purchaseId" />
    </el-dialog>
  </div>
</template>

<script>
import AppendColumn from '@/views/order/delivery-recon/components/AppendColumn'
import CostSelectList from '@/views/purchase/cost/components/CostSelectList'
import CostEditForm from '@/views/purchase/profit-loss/form/CostEditForm'
import PurchaseRequirementDetail from '../../requirement/details/PurchaseRequirementDetail.vue'
export default {
  name: 'ProfitLossTaskTable',
  props: ['task', 'taskRows', 'tips'],
  components: {
    AppendColumn,
    CostSelectList,
    CostEditForm,
    PurchaseRequirementDetail
  },
  computed: {
    todoColor: function () {
      let str = ''
      this.options.forEach(item => {
        if (!this.optionDisabled(item)) {
          str += (item.colorName + ', ')
        }
      })

      return  str.substring(0, str.length - 2);
    },
    tableData: function () {
      let data = [];
      data = data.concat(this.plRows);
      if (this.plRows.length > 0) {
        data.push({
          countRow: '合计',
          totalQuantity: this.countColumn(this.plRows, 'totalQuantity').toFixed(0),
          totalContractAmount: this.countColumn(this.plRows, 'totalContractAmount').toFixed(2),
          totalCostAmount: this.countColumn(this.plRows, 'totalCostAmount').toFixed(4),
          totalAmount: this.countColumn(this.plRows, 'totalAmount').toFixed(4)
        });
      }

      return data;
    }
  },
  data () {
    return {
      purchaseId: null,
      purchaseDialogVisible: false,
      columnDialogtitle: '添加成本费用',
      plRows: [],
      options: [],
      modifyColumn: '',
      columnVisible: false,
      costDialogVisible: false,
      editDialogVisible: false,
      handleIndex: '',
      handleCostOrder: '',
      item: {
        productionTaskOrderCode: '',
        productionTaskOrderId: '',
        skuID: '',
        category: {
          id: null,
          name: ''
        },
        colors: [],
        costOrder: {},
        totalQuantity: 0,
        unitContractAmount: 0,
        totalContractAmount: '',
        unitCostAmount: 0,
        totalCostAmount: '',
        totalAmount: '',
        additionalCharges: []
      }
    }
  },
  methods: {
    countColumn (arr, attribute) {
      let count = 0;
      arr.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item[attribute]))) {
          count += Number.parseFloat(item[attribute]);
        }
      })
      
      return arr.some(item => !Number.isNaN(Number.parseFloat(item[attribute]))) ? count : 0;
    },
    addRow () {
      this.plRows.push(JSON.parse(JSON.stringify(this.item)));
    },
    handleChange (selection, row) {
      row.totalQuantity = 0;
      selection.forEach(item => {
        if (!Number.isNaN(Number.parseInt(item.totalQuantity))) {
          row.totalQuantity += item.totalQuantity;
        }
      })
    },
    calculation (row, attribute) {
      let count = 0;
      if (!Number.isNaN(Number.parseInt(row.totalQuantity)) && !Number.isNaN(Number.parseFloat(row[attribute]))) {
        count = Number.parseInt(row.totalQuantity) * Number.parseFloat(row[attribute]);
      }
      if (attribute === 'unitCostAmount') {
        row.totalCostAmount = count;
      }
      if (attribute === 'unitContractAmount') {
        row.totalContractAmount = count;
      }
      return count;
    },
    openCostList (index) {
      this.handleIndex = index;
      this.costDialogVisible = true;
    },
    modifyCost (index, costOrder) {
      this.handleIndex = index;
      this.handleCostOrder = costOrder;
      this.editDialogVisible = true;
    },
    editCostForm (data) {
      this.onSelectCost(data);
      this.editDialogVisible = false;
    },
    onSelectCost (data) {
      if (!data) {
        this.plRows[this.handleIndex].unitCostAmount = 0;
        this.plRows[this.handleIndex].costOrder = {};
      } else {

        let amount = 0;

        if (data.totalCost) {
          amount = data.totalCost;
        } else {
          if (data.customRows && data.customRows.length > 0) {
            data.customRows.forEach(item => amount += Number.parseFloat(item.specList[0].price));
          }
          if (data.purchaseMaterials && data.purchaseMaterials.length > 0) {
            data.purchaseMaterials.forEach(item => amount += Number.parseFloat(item.specList[0].totalPrice));
          }
        }
  
        this.plRows[this.handleIndex].unitCostAmount = amount;
        
        // 无id的情况下为新建
        if (this.plRows[this.handleIndex].costOrder.id) {
          data.id = this.plRows[this.handleIndex].costOrder.id;
        } else {
          data.id = null;
        }
        data.type = 'PRODUCT';
        
        this.plRows[this.handleIndex].costOrder = data;
      }      

      this.costDialogVisible = false;
      this.handleIndex = '';
    },
    totalAmount (row) {
      if (!row.countRow) {
        let totalAmount = this.calculation(row, 'unitCostAmount');
  
        row.additionalCharges.forEach(item => {
          if (!Number.isNaN(Number.parseFloat(item.amount))) {
            totalAmount += Number.parseFloat(item.amount);
          }
        })
        row.totalAmount = totalAmount;
        return row.totalAmount;
      }
    },
    profitLossRatio (row) {
      if (!Number.isNaN((row.totalContractAmount - row.totalAmount) / row.totalContractAmount)) {
        return ((row.totalContractAmount - row.totalAmount) / row.totalContractAmount * 100).toFixed(2);
      }
      return 0.00;
    },
    onDelete (index) {
      this.plRows.splice(index, 1);
    },
    optionDisabled (color, row) {
      return this.plRows.some(item => {
        return item.colors.findIndex(val => val.id === color.id) > -1 && item != row;
      })
    },
    addColumn (title) {
      const newC = Number(Math.random().toString().substr(3, 3) + Date.now()).toString(36);

      this.item.additionalCharges.push({
        key: newC,
        remarks: title,
        amount: 0
      })

      this.plRows.forEach(item => {
        item.additionalCharges.push({
          key: newC,
          remarks: title,
          amount: 0
        })
      });

      this.columnVisible = false;
    },
    onModifyColName (column) {
      this.columnDialogtitle = '修改成本费用';
      this.modifyColumn = {
        id: column.id,
        value: column.remarks
      };
      this.columnVisible = true;
    },
    _modifyColumn (column) {
      let index = this.item.additionalCharges.findIndex(val => val.key === column.key);
      this.item.additionalCharges[index].remarks = column.value;

      this.plRows.forEach(val => {
        val.additionalCharges[index].remarks = column.value;
      })

      this.callback();
    },
    onDeleteCol (index) {
      this.$confirm('是否删除此列?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this.item.additionalCharges.splice(index, 1);
        this.$nextTick(() => {
          this.plRows.forEach(val => {
            val.additionalCharges.splice(index, 1);
          })
        })
      });
    },
    callback () {
      this.columnVisible = false;
      this.modifyColumn = '';
    },    
    inputChange (index, attribute) {
      const regexp = /^.*\.$/;
      if (regexp.test(this.plRows[index].additionalCharges[attribute].amount)) {
        this.plRows[index].additionalCharges[attribute].amount = 
          Number.parseFloat(this.plRows[index].additionalCharges[attribute].amount.slice(0, this.plRows[index].additionalCharges[attribute].amount.length - 1));
      }
    },
    initOptions () {
      let index;
      this.task.colorSizeEntries.forEach(item => {
        index = this.options.findIndex(val => val.id === item.color.id);
        if (index > -1) {
          this.options[index].totalQuantity += item.quantity;
        } else {
          this.options.push({
            id: item.color.id,
            colorName: item.color.name,
            totalQuantity: item.quantity
          });
        }
      })

      this.item.productionTaskOrderId = this.task.id;
      this.item.productionTaskOrderCode = this.task.code;
      this.item.skuID = this.task.product.skuID;
      this.item.category = {
        id: this.task.product.category.id,
        name: this.task.product.category.name
      };
      
      this.item.unitContractAmount = this.task.unitPrice;
    },
    onPurhcaseDetail (row) {
      this.purchaseId = row.purchaseTaskId;
      this.purchaseDialogVisible = true;
    }
  },
  mounted () {
    if (this.taskRows && this.taskRows.length > 0) {
      // 处理回显数据
      let rows = this.taskRows.filter(item => item[0].productionTaskOrderId === this.task.id)[0];
  
      if (rows[0].additionalCharges) {
        rows[0].additionalCharges.forEach((item, index) => {
          this.item.additionalCharges.push({
            remarks: item.remarks,
            key: Number(Math.random().toString().substr(3, 3) + Date.now()).toString(36) + '.' + index,
            amount: 0
          })
        });
      }
  
      rows.forEach(item => {
        this.plRows.push({
          id: item.id,
          purchaseTaskId: item.purchaseTaskId ? item.purchaseTaskId : null,
          productionTaskOrderCode: item.productionTaskOrderCode,
          productionTaskOrderId: item.productionTaskOrderId,
          skuID: item.skuID,
          category: item.category,
          colors: this.options.filter(v => item.colors.findIndex(v1 => v.id === v1.id) > -1),
          costOrder: item.costOrder,
          totalQuantity: item.totalQuantity,
          unitContractAmount: item.unitContractAmount,
          totalContractAmount: item.totalContractAmount,
          unitCostAmount: item.unitCostAmount,
          totalCostAmount: item.totalCostAmount,
          totalAmount: item.totalAmount,
          additionalCharges: item.additionalCharges ? item.additionalCharges.map(val => {
            return {
              id: val.id ? val.id : null,
              remarks: val.remarks,
              amount: val.amount,
              key: this.item.additionalCharges.filter(v => v.remarks === val.remarks)[0].key
            }
          }) : []
        });
      })
    }
  },
  created () {
    this.initOptions();
  }
}
</script>

<style scoped>
  .task-table {
    margin-bottom: 20px;
  }

  .table-title {
    font-size: 14px;
    color: #606266;
  }

  .top-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .column-close {
    margin: 0px;
    color: #C0C4CC
  }

  .column-close:hover {
    color: #606266
  }
</style>