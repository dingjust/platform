<template>
  <div class="material-append-table">
    <el-row type="flex">
      <el-col :span="12">
        <el-row type="flex" justify="end">
          <h6>添加物料</h6>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row type="flex" justify="end">
          <el-button type="text" @click="importVisible=true">批量导入</el-button>
        </el-row>
      </el-col>
    </el-row>
    <el-form ref="form" :model="entries" :hide-required-asterisk="true">
      <el-table ref="resultTable" stripe :data="entries.workOrders" :height="autoHeight">
        <el-table-column min-width="100px">
          <template slot="header">
            <span>物料名称<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.name'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.name" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column prop="materialsType" min-width="100px">
          <template slot="header">
            <span>物料类别<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.materialsType'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-select v-model="scope.row.materialsType" style="width: 90px">
                <template v-for="item in materialsType">
                  <el-option :label="item.name" :value="item.code" :key="item.code"></el-option>
                </template>
              </el-select>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料编号" prop="code" min-width="100px">
          <template slot="header">
            <span>物料编号<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.code'">
              <el-input v-model="scope.row.code" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="幅宽/型号" prop="modelName" min-width="100px">
          <template slot="header">
            <span>幅宽/型号<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.modelName'">
              <el-input v-model="scope.row.modelName" style="width: 90px"></el-input>
            </el-form-item>
          </template></el-table-column>
        <el-table-column label="克重/规格" prop="specName" min-width="100px">
          <template slot-scope="scope">
            <el-form-item>
              <el-input v-model="scope.row.specName" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料单位" prop="unit" min-width="100px">
          <template slot="header">
            <span>物料单位<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.unit'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.unit" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料颜色" prop="colorName" min-width="100px">
          <template slot="header">
            <span>物料颜色<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.colorName'">
              <el-input v-model="scope.row.colorName" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="单件用量" prop="unitQuantity" min-width="100px">
          <template slot="header">
            <span>单件用量<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.unitQuantity'" :rules="[{required: true, validator: validateValue, tigger: 'change'}]">
              <el-input v-model="scope.row.unitQuantity" style="width: 90px" 
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="预计损耗" prop="estimatedLoss" min-width="100px">
          <template slot="header">
            <span>预计损耗<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.estimatedLoss'" :rules="[{required: true, validator: validateValue, tigger: 'change'}]">
              <el-input v-model="scope.row.estimatedLoss" style="width: 90px"
                        v-number-input.float="{ min: 0, max: 100, decimal: 2 }">
                <span slot="suffix">%</span>
              </el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="预计用量" prop="estimatedUsage" min-width="100px">
          <template slot="header">
            <span>预计用量<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item>
              <span>{{getExpectQuantity(scope.$index)}}</span>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="订单数" prop="orderCount" min-width="100px">
          <template slot="header">
            <span>订单数<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.orderCount'" :rules="[{required: true, validator: validateValue, tigger: 'change'}]">
              <el-input v-model="scope.row.orderCount" style="width: 90px"
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="空差" prop="emptySent" min-width="100px">
          <template slot-scope="scope">
            <el-form-item>
              <el-input v-model="scope.row.emptySent" style="width: 90px" placeholder="100"
                        v-number-input.float="{ min: 0, max: 100, decimal: 2 }">
                <span slot="suffix">%</span>
              </el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="需求数量" prop="requiredAmount" min-width="100px">
          <template slot="header">
            <span>需求数量<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item>
              <span>{{getNeedQuantity(scope.$index)}}</span>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="供应商" prop="cooperatorName" min-width="100px" v-if="!isFromCost">
          <template slot-scope="scope">
            <el-form-item>
              <el-input v-model="scope.row.cooperatorName" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料单价" prop="price" min-width="100px">
          <template slot="header">
            <span>物料单价<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.price'" :rules="[{required: true, validator: validateValue, tigger: 'change'}]">
              <el-input v-model="scope.row.price" style="width: 90px"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="总金额" prop="totalPrice" min-width="100px">
          <template slot-scope="scope">
            <el-form-item>
              <span>{{getTotalPrice(scope.$index)}}</span>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="到料时间" prop="estimatedRecTime" min-width="150px">
          <template slot="header">
            <span>到料时间<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.estimatedRecTime'" :rules="[{required: true, type: 'number',message: '必填', tigger: 'blur'}]">
              <el-date-picker
                v-model="scope.row.estimatedRecTime"
                type="date"
                value-format="timestamp"
                style="width: 130px"
                placeholder="选择日期">
              </el-date-picker>
            </el-form-item>
          </template>
        </el-table-column>
        <!-- <el-table-column label="是否批色" prop="auditColor" min-width="110px">
          <template slot-scope="scope">
            <el-form-item>
              <el-select v-model="scope.row.auditColor" style="width:90px" placeholder="否">
                <el-option label="是" :value="true"></el-option>
                <el-option label="否" :value="false"></el-option>
              </el-select>
            </el-form-item>
          </template>
        </el-table-column> -->
        <el-table-column label="操作" min-width="100px" fixed="right">
          <template slot-scope="scope">
            <el-form-item>
              <el-button type="text" @click="onAdd(scope.$index, scope.row)">
                <i class="el-icon-plus"></i>
              </el-button>
              <el-button type="text" @click="onCopy(scope.$index, scope.row)">
                <i class="el-icon-copy-document"></i>
              </el-button>
              <el-button type="text" @click="onDelete(scope.$index, scope.row)">
                <i class="el-icon-delete"></i>
              </el-button>
            </el-form-item>
          </template>
        </el-table-column>
      </el-table>
    </el-form>
    <el-row type="flex" justify="center" style="margin-top: 30px">
      <el-button class="sumbit-btn" @click="onSumbit">确认</el-button>
    </el-row>
    <el-dialog :visible.sync="importVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <materials-import v-if="importVisible" @onImport="onImport"/>
    </el-dialog>
  </div>  
</template>

<script>
import MaterialsImport from './MaterialsImport'

export default {
  name: 'MaterialAppendTable',
  props: ['formData', 'entries', 'isFromCost'],
  components: {
    MaterialsImport
  },
  methods: {
    onImport (data) {
      this.entries.workOrders = data;
      this.importVisible = false;
    },
    getExpectQuantity (index) {
      let count = 0;
      if (!Number.isNaN(Number.parseFloat(this.entries.workOrders[index].unitQuantity)) && !Number.isNaN(Number.parseFloat(this.entries.workOrders[index].estimatedLoss))) {
        count = Number.parseFloat(this.entries.workOrders[index].unitQuantity) * (1 + Number.parseFloat(this.entries.workOrders[index].estimatedLoss) / 100);
      }
      this.entries.workOrders[index].estimatedUsage = count.toFixed(2);
      return count.toFixed(2);
    },
    getNeedQuantity (index) {
      let count = 0;
      const estimatedUsage = this.getExpectQuantity(index);
      if (!Number.isNaN(Number.parseFloat(this.entries.workOrders[index].orderCount))) {
        const orderCount = Number.parseFloat(this.entries.workOrders[index].orderCount);
        let emptySent = 100;
        if (!Number.isNaN(Number.parseFloat(this.entries.workOrders[index].emptySent))) {
          emptySent = Number.parseFloat(this.entries.workOrders[index].emptySent);
        }
        count = estimatedUsage * orderCount / (emptySent / 100);
      }
      this.entries.workOrders[index].requiredAmount = count.toFixed(2);
      return count.toFixed(2);
    },
    getTotalPrice (index) {
      let count = 0;
      if (!Number.isNaN(Number.parseFloat(this.entries.workOrders[index].price))) {
        count = Number.parseFloat(this.entries.workOrders[index].price) * this.getNeedQuantity(index);
      }
      this.entries.workOrders[index].totalPrice = count.toFixed(2);
      return count.toFixed(2);
    },
    onAdd (index, row) {
      this.entries.workOrders.splice(index + 1, 0 , {
        name: '',
        code: '',
        unit: '',
        materialsType: '',
        unitQuantity: '',
        specName: '',
        colorName: '',
        modelName: '',
        emptySent: '',
        requiredAmount: '',
        estimatedLoss: '',
        estimatedUsage: '',
        orderCount: '',
        auditColor: '',
        estimatedRecTime: '',
        cooperatorName: '',
        price: '',
        totalPrice: ''
      })
    },
    onCopy (index, row) {
      this.entries.workOrders.splice(index + 1, 0, Object.assign({}, row));
    },
    onDelete (index, row) {
      this.entries.workOrders.splice(index, 1);
      if (this.entries.workOrders.length <= 0 && index === 0) {
        this.onAdd(-1);
      }
    },
    onSumbit () {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this._onImport();
        } else {
          this.$message.error('请完善表单信息');
        }
      })
    },
    _onImport () {
      // const flag = this.checkRepeat(this.entries.workOrders);

      // if (flag) {
        this.$emit('onSelect', this.arrangeData(this.entries.workOrders));
      // }
    },
    arrangeData (materials) {
      let result = [];

      result = result.concat(materials);

      result.forEach(item => {
        this.$set(item, 'estimatedLoss', (Number.parseFloat(item.estimatedLoss) / 100).toFixed(2));
        
        if (Number.isNaN(Number.parseFloat(item.emptySent))) {
          this.$set(item, 'emptySent', 1.00);
        } else {
          this.$set(item, 'emptySent', (Number.parseFloat(item.emptySent) / 100).toFixed(2));
        }
      })
      return result;
    },
    checkRepeat (materials) {
      let stark = [];

      stark = stark.concat(materials);

      let repeat;
      let formRepeat;
      while (stark.length) {
        let temp = stark.shift();
        repeat = stark.filter(item => item.code === temp.code);
        if (repeat.length > 0) {
          if (repeat.filter(val => val.name === temp.name && val.materialsType === temp.materialsType && val.unit === temp.unit && val.cooperatorName === temp.cooperatorName).length !== repeat.length) {
            this.$message.warning('添加表单中存在相同物料编号 ' + temp.code + '，但名字、类型、单位，供应商其一不一致的物料，请先进行处理');
            return false;
          }
        }
        formRepeat = this.formData.workOrders.filter(item => item.code === temp.code);
        if (formRepeat.length > 0) {
          if (formRepeat.filter(val => val.name === temp.name && val.materialsType === temp.materialsType && val.unit === temp.unit && val.cooperatorName === temp.cooperatorName).length !== formRepeat.length) {
            this.$message.warning('采购明细中已存在相同物料编号 ' + temp.code + '，但名字、类型、单位，供应商其一不一致的物料，请先进行处理');
            return false;
          }
        }
      }
      return true;
    },
    validateValue (rule, value, callback) {
      if (value && value !== '') {
        callback();
      } else {
        callback(new Error('必填'));
      }
    }
  },
  data () {
    return {
      materialsType: this.$store.state.EnumsModule.MaterialsType,
      importVisible: false
    }
  }  
}
</script>

<style scoped>
  /deep/ .el-input__suffix {
    display: flex;
    align-items: center;
  }

  /deep/ .el-table--small td, .el-table--small th {
    padding: 8px 0px 0px 0px;
  }

  button {
    outline:none;
  }
   
  /deep/ .el-table .warning-row {
    background: oldlace;
  }

  .sumbit-btn {
    width: 100px;
    color: #606266;
    background-color: #ffd60c;
  }
</style>