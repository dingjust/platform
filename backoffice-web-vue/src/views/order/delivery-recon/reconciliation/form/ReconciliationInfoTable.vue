<template>
  <div>
    <el-row type="flex" justify="end" align="middle">
      <el-button type="text" size="medium" @click="columnVisible = true">添加表单列</el-button>
      <el-divider direction="vertical"></el-divider>
      <el-button type="text" size="medium" @click="onAdd">添加表单行</el-button>
      <el-button type="text" size="medium" @click="importVisible = true">批量导入</el-button>
    </el-row>
    <el-table :data="tableData" border ref="table">
      <el-table-column label="产品图片" min-width="80px">
        <template slot-scope="scope">
          <div v-if="scope.row.countRow">{{scope.row.countRow}}</div>
          <div v-else>
            <el-button type="text" @click="onSelectProduct(scope.$index)">
              <div v-if="scope.row.product && scope.row.product.id && scope.row.product.id !== ''"> 
                <img v-if="scope.row.product.thumbnail" :src="scope.row.product.thumbnail.url" style="width: 50px; height: 50px"/>
                <img v-else :src="scope.row.product.images[0].url" style="width: 50px; height: 50px"/>
              </div>
              <div class="product-select-icon" v-else>
                <i class="el-icon-plus select-icon"></i>
              </div>
            </el-button>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="产品名称" prop="product.name" min-width="120px" />
      <el-table-column lable="波段" prop="waveBand" min-width="120px" v-if="tableCol['waveBand'].have">
        <template slot="header">
          <span>波段<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('waveBand')"/></span>
        </template>
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-input v-model="scope.row.waveBand"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="产品款号" prop="product.skuID" min-width="120px" />
      <el-table-column label="订单款号" prop="orderItemNo" min-width="120px" v-if="tableCol['orderItemNo'].have">
        <template slot="header">
          <span>订单款号<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('orderItemNo')"/></span>
        </template>
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-input v-model="scope.row.orderItemNo"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="交货时间" prop="deliveryDate" min-width="160px" v-if="tableCol['deliveryDate'].have">
        <template slot="header">
          <span>交货时间<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('deliveryDate')"/></span>
        </template>
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-date-picker
            v-model="scope.row.deliveryDate"
            type="date"
            value-format="timestamp"
            style="width: 130px"
            placeholder="选择日期">
          </el-date-picker>
        </template>
      </el-table-column>
      <el-table-column label="合同时间" prop="contractDate" min-width="160px" v-if="tableCol['contractDate'].have">
        <template slot="header">
          <span>合同时间<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('contractDate')"/></span>
        </template>
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-date-picker
              v-model="scope.row.contractDate"
              type="date"
              value-format="timestamp"
              style="width: 130px"
              placeholder="选择日期">
            </el-date-picker>
        </template>
      </el-table-column>
      <el-table-column label="定作方式" prop="customizedMode" min-width="120px" v-if="tableCol['customizedMode'].have">
        <template slot="header">
          <span>定作方式<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('customizedMode')"/></span>
        </template>
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-input v-model="scope.row.customizedMode"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="下单数" prop="orderQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.orderQuantity" v-if="!scope.row.countRow"
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
          <span v-else>{{scope.row.orderQuantity}}</span>
        </template>
      </el-table-column>
      <el-table-column label="裁数" prop="cutQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.cutQuantity" v-if="!scope.row.countRow"
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
          <span v-else>{{scope.row.cutQuantity}}</span>
        </template>
      </el-table-column>
      <el-table-column label="装箱单数" prop="packageQuantity" min-width="120px" v-if="tableCol['packageQuantity'].have">
        <template slot="header">
          <span>装箱单数<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('packageQuantity')"/></span>
        </template>
        <template slot-scope="scope">
          <el-input v-model="scope.row.packageQuantity" v-if="!scope.row.countRow"
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
          <span v-else>{{scope.row.packageQuantity}}</span>
        </template>
      </el-table-column>
      <el-table-column label="正品入库数" prop="storageQuantity" min-width="120px" v-if="tableCol['storageQuantity'].have">
        <template slot="header">
          <span>正品入库数<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('storageQuantity')"/></span>
        </template>
        <template slot-scope="scope">
          <el-input v-model="scope.row.storageQuantity" v-if="!scope.row.countRow"
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
          <span v-else>{{scope.row.storageQuantity}}</span>
        </template>
      </el-table-column>
      <el-table-column label="合同单价（不含税）" prop="unitContractPrice" min-width="150px" v-if="tableCol['unitContractPrice'].have">
        <template slot="header">
          <span>合同单价（不含税）<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('unitContractPrice')"/></span>
        </template>
        <template slot-scope="scope">
          <el-input v-model="scope.row.unitContractPrice"
                    v-if="!scope.row.countRow"
                    @change="inputChange(scope.$index, 'unitContractPrice')"
                    v-number-input.float="{ decimal: 2 }"></el-input>
          <span v-else>{{scope.row.unitContractPrice}}</span>
        </template>
      </el-table-column>
      <el-table-column label="快递费" prop="expressFee" min-width="120px" v-if="tableCol['expressFee'].have">
        <template slot="header">
          <span>快递费<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('expressFee')"/></span>
        </template>
        <template slot-scope="scope">
          <el-input v-if="!scope.row.countRow"
                    v-model="scope.row.expressFee"
                    @change="inputChange(scope.$index, 'expressFee')"
                    v-number-input.float="{ decimal: 2 }"></el-input>
          <span v-else>{{scope.row.expressFee}}</span>
        </template>
      </el-table-column>
      <el-table-column label="扣款" prop="deductionAmount" min-width="120px" v-if="tableCol['deductionAmount'].have">
        <template slot="header">
          <span>扣款<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('deductionAmount')"/></span>
        </template>
        <template slot-scope="scope">
          <el-input v-if="!scope.row.countRow"
                    v-model="scope.row.deductionAmount"
                    @change="inputChange(scope.$index, 'deductionAmount')"
                    v-number-input.float="{ decimal: 2 }"></el-input>
          <span v-else>{{scope.row.deductionAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="退货" prop="returnQuantity" min-width="120px" v-if="tableCol['returnQuantity'].have">
        <template slot="header">
          <span>退货<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('returnQuantity')"/></span>
        </template>
        <template slot-scope="scope">
          <el-input v-model="scope.row.returnQuantity" v-if="!scope.row.countRow"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
          <span v-else>{{scope.row.returnQuantity}}</span>
        </template>
      </el-table-column>
      <el-table-column label="定金" prop="depositAmount" min-width="120px" v-if="tableCol['depositAmount'].have">
        <template slot="header">
          <span>定金<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('depositAmount')"/></span>
        </template>
        <template slot-scope="scope">
          <el-input v-if="!scope.row.countRow"
                    v-model="scope.row.depositAmount"
                    @change="inputChange(scope.$index, 'depositAmount')"
                    v-number-input.float="{ decimal: 2 }"></el-input>
          <span v-else>{{scope.row.depositAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" prop="remarks" min-width="225px" v-if="tableCol['remarks'].have">
        <template slot="header">
          <span>备注<el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteOri('remarks')"/></span>
        </template>
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-input v-model="scope.row.remarks" type="textarea" style="width: 200px" :rows="3" :title="scope.row.remarks"></el-input>
        </template>
      </el-table-column>
      <template v-if="formData.colNames.length > 0">
        <el-table-column v-for="column in formData.colNames" :label="column.id" :key="column.id" min-width="120px">
          <template slot="header" slot-scope="scope">
            <div style="display: flex;align-items: center">
              <span>{{column.value}}</span>
              <el-button type="text" @click="onModifyColName(column)">修改</el-button>
              <el-button type="text" icon="el-icon-error" class="column-close" @click="onDeleteCol(column)"/>
            </div>
          </template>
          <template slot-scope="scope">
            <el-input v-if="!scope.row.countRow" v-model="scope.row[column.id].value"></el-input>
          </template>
        </el-table-column>
      </template>
      <el-table-column label="货款金额" prop="loanAmount" min-width="120px">
        <template slot-scope="scope">
          <el-input v-if="!scope.row.countRow"
                    v-model="scope.row.loanAmount" 
                    @change="inputChange(scope.$index, 'loanAmount')"
                    v-number-input.float="{ decimal: 2 }"></el-input>
          <span v-else>{{scope.row.loanAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="结算金额" prop="settlementAmount" min-width="120px">
        <template slot-scope="scope">
          <el-input v-if="!scope.row.countRow"
                    v-model="scope.row.settlementAmount" 
                    @change="inputChange(scope.$index, 'settlementAmount')"
                    v-number-input.float="{ decimal: 2 }"></el-input>
          <span v-else>{{scope.row.settlementAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="80px" fixed="right">
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-button type="text" size="medium" @click="onCopy(scope.$index, scope.row)">
            <i class="el-icon-copy-document" title="复制"></i>
          </el-button>
          <el-button type="text" size="medium" @click="onDelete(scope.$index, scope.row)">
            <i class="el-icon-delete" title="删除"></i>
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="productDialog" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-products-select-dialog v-if="productDialog" @onSelectSample="onSelectSample" :isSingleSelect="true"/>
    </el-dialog>
    <el-dialog :visible.sync="importVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <reconciliation-entry-import v-if="importVisible" @onImport="onImport"/>
    </el-dialog>
    <el-dialog :title="columnDialogtitle" :visible.sync="columnVisible" width="400px" 
                append-to-body :close-on-click-modal="false" :show-close="false" :close-on-press-escape="false">
      <append-column v-if="columnVisible" :modifyColumn="modifyColumn" @toModifyColumn="_modifyColumn" @addColumn="addColumn" @callback="callback" />
    </el-dialog>
  </div>
</template>

<script>
import SampleProductsSelectDialog from '@/views/product/sample/components/SampleProductsSelectDialog'
import ReconciliationEntryImport from './ReconciliationEntryImport'
import AppendColumn from '../../components/AppendColumn.vue';
export default {
  name: 'ReconciliationInfoTable',
  props: {
    formData: {
      required: true
    },
    tableCol: {
      required: true
    },
    isCreate: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    tableData: function () {
      let data = [];
      data = data.concat(this.formData.entries);
      if (this.formData.entries.length > 0) {
        data.push({
          countRow: '合计',
          orderQuantity: this.countColumn(this.formData.entries, 'orderQuantity'),
          loanAmount: this.countColumn(this.formData.entries, 'loanAmount'),
          settlementAmount: this.countColumn(this.formData.entries, 'settlementAmount')
        });
      }

      return data;
    }
  },
  components: {
    SampleProductsSelectDialog,
    ReconciliationEntryImport,
    AppendColumn
  },
  data () {
    return {
      productDialog: false,
      operateIndex: '',
      importVisible: false,
      columnVisible: false,
      columnDialogtitle: '添加表单列',
      modifyColumn: '',
      item: {
        product: {
          id: '',
          name: '',
          thumbnail: '',
          skuID: ''
        },
        waveBand: '',
        orderItemNo: '',
        customizedMode: '',
        deliveryDate: '',
        contractDate: '',
        orderQuantity: '',
        cutQuantity: '',
        packageQuantity: '',
        storageQuantity: '',
        returnQuantity: '',
        unitContractPrice: '',
        loanAmount: '',
        expressFee: '',
        deductionAmount: '',
        settlementAmount: '',
        depositAmount: '',
        remarks: '',
        customColumns: []
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
      const flag = arr.some(item => !Number.isNaN(Number.parseFloat(item[attribute])));
      
      let regexp = /^.*\.0*$/;
      if (regexp.test(count.toFixed(2) + '')) {
        return flag ? count.toFixed(0) : '';
      }
      return count.toFixed(2);
    },
    inputChange (index, attribute) {
      const regexp = /^.*\.$/;
      if (regexp.test(this.formData.entries[index][attribute])) {
        this.formData.entries[index][attribute] = 
          Number.parseFloat(this.formData.entries[index][attribute].slice(0, this.formData.entries[index][attribute].length - 1));
      }
    },
    onAdd () {
      this.formData.entries.push(JSON.parse(JSON.stringify(this.item)));
    },
    onCopy (index, row) {
      this.formData.entries.splice(index + 1, 0, Object.assign({}, row));
    },
    onDelete (index, row) {
      if (row.relationId) {
        this.$confirm('删除此行将同时删除已选择关联发货单，是否继续？', '提示', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          const i = this.formData.shippingSheets.findIndex(item => item.id === row.relationId);
          if (i > -1) {
            this.formData.shippingSheets.splice(i, 1);
          }
          this.formData.entries.splice(index, 1);
        });
      } else {
        this.formData.entries.splice(index, 1);
      }
    },
    onSelectProduct (index) {
      this.productDialog = true;
      this.operateIndex = index;
    },
    onSelectSample (products) {
      this.formData.entries[this.operateIndex].product.skuID = products[0].skuID;
      this.formData.entries[this.operateIndex].product.name = products[0].name;
      this.formData.entries[this.operateIndex].product.id = products[0].id;
      this.formData.entries[this.operateIndex].product.thumbnail = products[0].thumbnail;
      this.productDialog = false;
    },
    onImport (sumbitData) {
      sumbitData.forEach(item => {
        this.formData.colNames.forEach(val => {
          this.$set(item, val.id, {
            id: '',
            value: ''
          });
        })
      })
      this.formData.entries = this.formData.entries.concat(sumbitData);
      this.importVisible = false;
    },
    addColumn (title) {
      const newC = Number(Math.random().toString().substr(3, 3) + Date.now()).toString(36);

      this.$set(this.item, newC, {
        id: '',
        value: ''
      });

      this.formData.entries.forEach(item => {
        this.$set(item, newC, {
          id: '',
          value: ''
        });
      });

      this.formData.colNames.push({
        id: newC,
        value: title
      });

      this.columnVisible = false;
    },
    onModifyColName (column) {
      this.columnDialogtitle = '修改表单列名';
      this.modifyColumn = Object.assign({}, column);
      this.columnVisible = true;
    },
    _modifyColumn (column) {
      let index = this.formData.colNames.findIndex(item => item.id === column.id);
      if (index > -1) {
        this.formData.colNames[index].value = column.value;
      }

      this.callback();
    },
    onDeleteCol (column) {
      let index = this.formData.colNames.findIndex(item => item.id === column.id);
      this.formData.colNames.splice(index, 1);
      this.formData.entries.forEach(item => {
        this.$delete(item, column.id);
      })

      this.$delete(this.item, column.id);
    },
    onDeleteOri (attribute) {
      this.tableCol[attribute].have = false;

      this.$delete(this.item, attribute);

      this.formData.entries.forEach(item => {
        this.$delete(item, attribute);
      })
    },
    callback () {
      this.columnVisible = false;
      this.modifyColumn = '';
    }
  },
  created () {
    if (this.formData.colNames.length > 0) {
      this.formData.colNames.forEach(item => {
        this.$set(this.item, item.id, {
          id: '',
          value: ''
        })
      })
    }
  }
}
</script>

<style scoped lang="scss">
  .product-select-icon {
    width: 50px;
    height: 50px;
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #fff;
    .select-icon {
      font-size: 28px;
      color: #8c939d;
    }
  }

  .product-select-icon:hover{
    border: 1px dashed #409eff;
    color: #409eff !important;
    .select-icon {
      color: #409eff;
    }
  }

  .column-close {
    margin: 0px;
    color: #C0C4CC
  }

  .column-close:hover {
    color: #606266
  }
</style>
