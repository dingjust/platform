<template>
  <div>
    <el-row type="flex" justify="end" align="middle">
      <el-button type="text" size="medium" @click="onAdd">添加</el-button>
      <el-button type="text" size="medium" @click="importVisible = true">批量导入</el-button>
    </el-row>
    <el-table :data="tableData" border>
      <el-table-column label="产品图片" min-width="80px">
        <template slot-scope="scope">
          <div v-if="scope.row.countRow">{{scope.row.countRow}}</div>
          <div v-else>
            <el-button type="text" @click="onSelectProduct(scope.$index)">
              <div v-if="scope.row.product && scope.row.product.id && scope.row.product.id !== ''"> 
                <img :src="scope.row.product.thumbnail.url" style="width: 50px; height: 50px"/>
              </div>
              <div class="product-select-icon" v-else>
                <i class="el-icon-plus select-icon"></i>
              </div>
            </el-button>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="产品名称" prop="product.name" min-width="120px" />
      <el-table-column label="波段" prop="waveBand" min-width="120px">
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-input v-model="scope.row.waveBand"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="产品款号" prop="product.skuID" min-width="120px" />
      <el-table-column label="订单款号" prop="orderItemNo" min-width="120px">
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-input v-model="scope.row.orderItemNo"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="交货时间" prop="deliveryDate" min-width="160px">
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
      <el-table-column label="合同时间" prop="contractDate" min-width="160px">
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
      <el-table-column label="定作方式" prop="customizedMode" min-width="120px">
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
      <el-table-column label="装箱单数" prop="packageQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.packageQuantity" v-if="!scope.row.countRow"
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
          <span v-else>{{scope.row.packageQuantity}}</span>
        </template>
      </el-table-column>
      <el-table-column label="正品入库数" prop="storageQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.storageQuantity" v-if="!scope.row.countRow"
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
          <span v-else>{{scope.row.storageQuantity}}</span>
        </template>
      </el-table-column>
      <el-table-column label="合同单价（不含税）" prop="unitContractPrice" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.unitContractPrice" 
                    v-if="!scope.row.countRow"
                    @change="inputChange(scope.$index, 'unitContractPrice')"
                    v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
          <span v-else>{{scope.row.unitContractPrice}}</span>
        </template>
      </el-table-column>
      <el-table-column label="货款金额" prop="loanAmount" min-width="120px">
        <template slot-scope="scope">
          <el-input v-if="!scope.row.countRow"
                    v-model="scope.row.loanAmount" 
                    @change="inputChange(scope.$index, 'loanAmount')"
                    v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
          <span v-else>{{scope.row.loanAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="快递费" prop="expressFee" min-width="120px">
        <template slot-scope="scope">
          <el-input v-if="!scope.row.countRow"
                    v-model="scope.row.expressFee" 
                    @change="inputChange(scope.$index, 'expressFee')"
                    v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
          <span v-else>{{scope.row.expressFee}}</span>
        </template>
      </el-table-column>
      <el-table-column label="扣款" prop="deductionAmount" min-width="120px">
        <template slot-scope="scope">
          <el-input v-if="!scope.row.countRow"
                    v-model="scope.row.deductionAmount" 
                    @change="inputChange(scope.$index, 'deductionAmount')"
                    v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
          <span v-else>{{scope.row.deductionAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="退货" prop="returnQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.returnQuantity" v-if="!scope.row.countRow"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
          <span v-else>{{scope.row.returnQuantity}}</span>
        </template>
      </el-table-column>
      <el-table-column label="结算金额" prop="settlementAmount" min-width="120px">
        <template slot-scope="scope">
          <el-input v-if="!scope.row.countRow"
                    v-model="scope.row.settlementAmount" 
                    @change="inputChange(scope.$index, 'settlementAmount')"
                    v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
          <span v-else>{{scope.row.settlementAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" prop="remark" min-width="120px">
        <template slot-scope="scope" v-if="!scope.row.countRow">
          <el-input v-model="scope.row.remarks" :title="scope.row.remarks"></el-input>
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
  </div>
</template>

<script>
import SampleProductsSelectDialog from '@/views/product/sample/components/SampleProductsSelectDialog'
import ReconciliationEntryImport from './ReconciliationEntryImport'
export default {
  name: 'ReconciliationInfoTable',
  props: ['formData'],
  computed: {
    tableData: function () {
      let data = [];
      data = data.concat(this.formData.entries);
      if (this.formData.entries.length > 0) {
        data.push({
          countRow: '合计',
          orderQuantity: this.countColumn(this.formData.entries, 'orderQuantity'),
          // cutQuantity: this.countColumn(this.formData.entries, 'cutQuantity'),
          packageQuantity: this.countColumn(this.formData.entries, 'packageQuantity'),
          storageQuantity: this.countColumn(this.formData.entries, 'storageQuantity'),
          // unitContractPrice: this.countColumn(this.formData.entries, 'unitContractPrice'),
          loanAmount: this.countColumn(this.formData.entries, 'loanAmount'),
          expressFee: this.countColumn(this.formData.entries, 'expressFee'),
          // deductionAmount: this.countColumn(this.formData.entries, 'deductionAmount'),
          // returnQuantity: this.countColumn(this.formData.entries, 'returnQuantity'),
          settlementAmount: this.countColumn(this.formData.entries, 'settlementAmount')
        });
      }
      return data;
    }
  },
  components: {
    SampleProductsSelectDialog,
    ReconciliationEntryImport
  },
  data () {
    return {
      // item: {
      //   product: {
      //     id: '',
      //     name: '',
      //     thumbnail: '',
      //     skuID: ''
      //   },
      //   waveBand: '',
      //   orderItemNo: '',
      //   customizedMode: '',
      //   deliveryDate: '',
      //   contractDate: '',
      //   orderQuantity: '',
      //   cutQuantity: '',
      //   packageQuantity: '',
      //   storageQuantity: '',
      //   returnQuantity: '',
      //   unitContractPrice: '',
      //   loanAmount: '',
      //   expressFee: '',
      //   deductionAmount: '',
      //   settlementAmount: '',
      //   remarks: ''
      // },
      productDialog: false,
      operateIndex: '',
      importVisible: false
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
      
      let regexp = /^.*\.0*$/;
      if (regexp.test(count.toFixed(2) + '')) {
        return count.toFixed(0) == 0 ? '' : count.toFixed(0);
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
      this.formData.entries.push({
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
        remarks: ''
      });
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
      this.formData.entries = this.formData.entries.concat(sumbitData);
      this.importVisible = false;
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

</style>