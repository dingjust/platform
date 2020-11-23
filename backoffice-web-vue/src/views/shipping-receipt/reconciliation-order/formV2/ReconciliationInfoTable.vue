<template>
  <div>
    <el-row type="flex" justify="end" align="middle">
      <el-button type="text" size="medium" @click="onAdd">添加</el-button>
      <el-button type="text" size="medium" @click="importVisible = true">批量导入</el-button>
    </el-row>
    <el-table :data="formData.entries" border >
      <el-table-column label="产品图片" min-width="80px">
        <template slot-scope="scope">
          <div v-if="scope.row.product && scope.row.product.id && scope.row.product.id !== ''"> 
            <img :src="scope.row.product.thumbnail.url" style="width: 50px; height: 50px"/>
          </div>
          <el-button type="text" @click="onSelectProduct(scope.$index)" v-else>
            <div class="product-select-icon">
              <i class="el-icon-plus select-icon"></i>
            </div>
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="产品名称" prop="product.name" min-width="120px" />
      <el-table-column label="波段" prop="bd" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.waveBand"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="产品款号" prop="product.skuID" min-width="120px" />
      <el-table-column label="订单款号" prop="orderItemNo" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.orderItemNo"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="交货时间" prop="deliveryDate" min-width="160px">
        <template slot-scope="scope">
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
        <template slot-scope="scope">
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
        <template slot-scope="scope">
          <el-input v-model="scope.row.customizedMode"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="下单数" prop="orderQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.orderQuantity" 
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="裁数" prop="cutQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.cutQuantity" 
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="装箱单数" prop="packageQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.packageQuantity" 
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="正品入库数" prop="storageQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.storageQuantity" 
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="合同单价（不含税）" prop="unitContractPrice" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.unitContractPrice" @change="inputChange(scope.$index, 'unitContractPrice')"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="货款金额" prop="loanAmount" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.loanAmount" @change="inputChange(scope.$index, 'loanAmount')"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="快递费" prop="expressFee" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.expressFee" @change="inputChange(scope.$index, 'expressFee')"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="扣款" prop="deductionAmount" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.deductionAmount" @change="inputChange(scope.$index, 'deductionAmount')"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="退货" prop="returnQuantity" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.returnQuantity" 
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="结算金额" prop="settlementAmount" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.settlementAmount" @change="inputChange(scope.$index, 'settlementAmount')"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="备注" prop="remark" min-width="120px">
        <template slot-scope="scope">
          <el-input v-model="scope.row.remarks" :title="scope.row.remarks"></el-input>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="80px" fixed="right">
        <template slot-scope="scope">
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
  components: {
    SampleProductsSelectDialog,
    ReconciliationEntryImport
  },
  data () {
    return {
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
        remarks: ''
      },
      productDialog: false,
      operateIndex: '',
      importVisible: false
    }
  },
  methods: {
    inputChange (index, attribute) {
      const regexp = /^.*\.$/;
      if (regexp.test(this.formData.entries[index][attribute])) {
        this.formData.entries[index][attribute] = 
          Number.parseFloat(this.formData.entries[index][attribute].slice(0, this.formData.entries[index][attribute].length - 1));
      }
    },
    onAdd () {
      this.formData.entries.push(Object.assign({}, this.item));
    },
    onCopy (index, row) {
      this.formData.entries.splice(index + 1, 0, Object.assign({}, row));
    },
    onDelete (index, row) {
      this.formData.entries.splice(index, 1);
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
      console.log(sumbitData);
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